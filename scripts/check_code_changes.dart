// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/args.dart';

/// Evaluator for detecting whether functional code changes exist between git refs.
class CodeChangeEvaluator {
  /// Check if a commit subject is purely a release version bump.
  static bool isReleaseBumpCommit(String subject) {
    final clean = subject.trim().toLowerCase();
    return clean.startsWith('chore(release):') ||
        clean.startsWith('chore: release') ||
        clean.startsWith('chore: bump version') ||
        clean.startsWith('bump version to');
  }

  /// Check if a modified file path represents non-code/release metadata.
  static bool isVersionOnlyFile(String filePath) {
    final clean = filePath.trim().toLowerCase();
    return clean.endsWith('pubspec.yaml') ||
        clean.endsWith('version.dart') ||
        clean.endsWith('appcast.xml') ||
        clean.endsWith('changelog.md') ||
        clean.endsWith('pubspec.lock');
  }

  /// Check if a modified file path belongs exclusively to the web server/docker wrapper.
  static bool isWebServerOnlyFile(String filePath) {
    final clean = filePath.trim().toLowerCase();
    return clean.startsWith('bin/') ||
        clean.startsWith('templates/') ||
        clean.startsWith('content/') ||
        clean == 'dockerfile' ||
        clean == 'docker-compose.yaml' ||
        clean == 'docker-compose.yml' ||
        clean == '.gitea/workflows/deploy.yml';
  }

  /// Filter a raw list of git oneline log entries down to meaningful non-bump commits.
  static List<String> filterMeaningfulCommits(List<String> logLines) {
    final list = <String>[];
    for (final line in logLines) {
      if (line.trim().isEmpty) continue;
      final parts = line.split(' ');
      final subject = parts.length > 1 ? parts.sublist(1).join(' ') : line;
      if (!isReleaseBumpCommit(subject)) {
        list.add(line.trim());
      }
    }
    return list;
  }

  /// Filter a raw list of changed file paths down to code/asset files excluding release metadata.
  static List<String> filterChangedCodeFiles(
    List<String> fileLines, {
    String target = 'all',
  }) {
    final list = <String>[];
    for (final file in fileLines) {
      final clean = file.trim();
      if (clean.isEmpty || isVersionOnlyFile(clean)) continue;
      if (target == 'app' && isWebServerOnlyFile(clean)) continue;
      if (target == 'web' && !isWebServerOnlyFile(clean)) continue;
      list.add(clean);
    }
    return list;
  }

  /// Evaluate from log and diff lines in memory.
  static ({
    bool hasCodeChanges,
    List<String> meaningfulCommits,
    List<String> changedCodeFiles,
  })
  evaluateFromData({
    required List<String> logLines,
    required List<String> fileLines,
    String target = 'all',
  }) {
    final meaningfulCommits = filterMeaningfulCommits(logLines);
    final changedCodeFiles = filterChangedCodeFiles(
      fileLines,
      target: target,
    );
    final hasChanges =
        meaningfulCommits.isNotEmpty && changedCodeFiles.isNotEmpty;

    return (
      hasCodeChanges: hasChanges,
      meaningfulCommits: meaningfulCommits,
      changedCodeFiles: changedCodeFiles,
    );
  }

  /// Inspect commit logs and changed files between [fromRef] and [toRef].
  static ({
    bool hasCodeChanges,
    List<String> meaningfulCommits,
    List<String> changedCodeFiles,
  })
  evaluate({
    String? fromRef,
    String toRef = 'HEAD',
    String target = 'all',
  }) {
    try {
      // 1. Get commit list
      final logArgs = (fromRef != null && fromRef.isNotEmpty)
          ? ['log', '$fromRef..$toRef', '--oneline']
          : ['log', '-n', '20', '--oneline'];

      final logResult = Process.runSync('git', logArgs);
      final logLines = logResult.exitCode == 0
          ? logResult.stdout.toString().trim().split('\n')
          : <String>[];

      // 2. Get changed files
      final diffArgs = (fromRef != null && fromRef.isNotEmpty)
          ? ['diff', '--name-only', '$fromRef..$toRef']
          : ['diff', '--name-only', 'HEAD~1..$toRef'];

      final diffResult = Process.runSync('git', diffArgs);
      final fileLines = diffResult.exitCode == 0
          ? diffResult.stdout.toString().trim().split('\n')
          : <String>[];

      return evaluateFromData(
        logLines: logLines,
        fileLines: fileLines,
        target: target,
      );
    } catch (_) {
      return (
        hasCodeChanges: false,
        meaningfulCommits: <String>[],
        changedCodeFiles: <String>[],
      );
    }
  }
}

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption(
      'from',
      abbr: 'f',
      help: 'Base git tag or commit ref to compare against',
    )
    ..addOption(
      'to',
      abbr: 't',
      defaultsTo: 'HEAD',
      help: 'Target git commit ref (default: HEAD)',
    )
    ..addOption(
      'target',
      defaultsTo: 'all',
      allowed: ['all', 'app', 'web'],
      help: 'Filter scope for code changes: all, app, or web',
    )
    ..addFlag(
      'github-output',
      help: 'Write outputs to \$GITHUB_OUTPUT environment file',
      defaultsTo: false,
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final results = parser.parse(args);

  if (results['help'] == true) {
    print('Usage: dart scripts/check_code_changes.dart [options]');
    print(parser.usage);
    exit(0);
  }

  String? fromRef = results['from'] as String?;

  // Automatically find latest release tag if --from not specified
  if (fromRef == null || fromRef.isEmpty) {
    final tagResult = Process.runSync('git', [
      'tag',
      '-l',
      'v*',
      '--sort=-v:refname',
    ]);
    if (tagResult.exitCode == 0) {
      final tags = tagResult.stdout
          .toString()
          .trim()
          .split('\n')
          .where((t) => t.isNotEmpty)
          .toList();
      if (tags.isNotEmpty) {
        fromRef = tags.first;
      }
    }
  }

  final toRef = results['to'] as String;
  final target = results['target'] as String;

  print(
    'Evaluating changes (target: $target) between "${fromRef ?? 'repository start'}" and "$toRef"...',
  );

  final result = CodeChangeEvaluator.evaluate(
    fromRef: fromRef,
    toRef: toRef,
    target: target,
  );

  print('\nMeaningful Commits: ${result.meaningfulCommits.length}');
  for (final c in result.meaningfulCommits) {
    print('  • $c');
  }

  print(
    '\nChanged Source Files (excluding version metadata): ${result.changedCodeFiles.length}',
  );
  for (final f in result.changedCodeFiles.take(15)) {
    print('  • $f');
  }
  if (result.changedCodeFiles.length > 15) {
    print('  ... and ${result.changedCodeFiles.length - 15} more files');
  }

  print('\nResult: has_code_changes=${result.hasCodeChanges}');

  if (results['github-output'] == true) {
    final outputFilePath = Platform.environment['GITHUB_OUTPUT'];
    if (outputFilePath != null && outputFilePath.isNotEmpty) {
      final outputFile = File(outputFilePath);
      outputFile.writeAsStringSync(
        'has_code_changes=${result.hasCodeChanges}\n'
        'meaningful_commits_count=${result.meaningfulCommits.length}\n'
        'changed_files_count=${result.changedCodeFiles.length}\n',
        mode: FileMode.append,
      );
      print('✓ Wrote outputs to $outputFilePath');
    }
  }
}
