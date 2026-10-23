// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/args.dart';
import 'changelog_parser.dart';

void main(List<String> rawArgs) async {
  final parser = ArgParser()
    ..addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'date',
      allowed: ['date', 'major', 'minor', 'patch', 'build'],
      help:
          'Version bump mode: date (YYYY.M.D+build), major, minor, patch, or build',
    )
    ..addOption(
      'channel',
      abbr: 'c',
      defaultsTo: 'manual',
      help:
          'Release channel / schedule target (e.g. daily, weekly, monthly, manual)',
    )
    ..addFlag(
      'dry-run',
      defaultsTo: false,
      help:
          'Simulate version calculation without writing files or git operations',
    )
    ..addFlag(
      'commit',
      defaultsTo: true,
      help: 'Commit modified version files to git',
    )
    ..addFlag(
      'tag',
      defaultsTo: true,
      help: 'Create annotated git tag for the new version',
    )
    ..addFlag(
      'push',
      defaultsTo: true,
      help: 'Push commit and tags to git remote',
    )
    ..addFlag(
      'github-output',
      defaultsTo: false,
      help: 'Write version metadata to \$GITHUB_OUTPUT environment file',
    )
    ..addOption(
      'git-user-name',
      defaultsTo: 'Gitea Actions',
      help: 'Git user name for commit',
    )
    ..addOption(
      'git-user-email',
      defaultsTo: 'actions@git.rodydavis.dev',
      help: 'Git user email for commit',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final args = parser.parse(rawArgs);

  if (args['help'] == true) {
    print('Usage: dart scripts/release.dart [options]');
    print(parser.usage);
    exit(0);
  }

  final isDryRun = args['dry-run'] as bool;
  final shouldCommit = args['commit'] as bool && !isDryRun;
  final shouldTag = args['tag'] as bool && !isDryRun;
  final shouldPush = args['push'] as bool && !isDryRun;
  final gitUserName = args['git-user-name'] as String;
  final gitUserEmail = args['git-user-email'] as String;
  final mode = args['mode'] as String;
  final channel = args['channel'] as String;

  final primaryPubspec = File('pubspec.yaml');
  if (!await primaryPubspec.exists()) {
    print('Error: pubspec.yaml not found');
    exit(1);
  }

  final pubspecContent = await primaryPubspec.readAsString();
  final versionMatch = RegExp(
    r'^version:\s*([^\s\r\n]+)',
    multiLine: true,
  ).firstMatch(pubspecContent);
  if (versionMatch == null) {
    print('Error: Could not find version in pubspec.yaml');
    exit(1);
  }

  final currentFullVersion = versionMatch.group(1)!;
  final parts = currentFullVersion.split('+');
  final versionNumbers = parts[0]
      .split('.')
      .map((e) => int.tryParse(e) ?? 0)
      .toList();
  while (versionNumbers.length < 3) {
    versionNumbers.add(0);
  }

  int build = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;

  // Scan existing git tags to find the highest build number across the repository
  int maxBuild = build;
  try {
    final tagResult = Process.runSync('git', ['tag', '-l', 'v*']);
    if (tagResult.exitCode == 0) {
      final tagLines = tagResult.stdout.toString().split('\n');
      for (final tag in tagLines) {
        final match = RegExp(r'v\d+\.\d+\.\d+\+(\d+)').firstMatch(tag.trim());
        if (match != null) {
          final tagBuild = int.tryParse(match.group(1)!);
          if (tagBuild != null && tagBuild > maxBuild) {
            maxBuild = tagBuild;
          }
        }
      }
    }
  } catch (_) {}

  final now = DateTime.now().toUtc();

  // In CalVer (YYYY.M.D+build), the date portion is always the current UTC date,
  // and version bumps always bump the build number only (never the patch/day component).
  final year = now.year;
  final minor = now.month;
  final patch = now.day;
  final newBuild = maxBuild + 1;

  final newVersion = '$year.$minor.$patch+$newBuild';
  final semver = '$year.$minor.$patch';
  final tagName = 'v$newVersion';

  print('====================================================');
  print('Release Mode:    $mode');
  print('Channel:         $channel');
  print('Current Version: $currentFullVersion');
  print('New Version:     $newVersion (semver: $semver)');
  print('Tag Name:        $tagName');
  if (isDryRun) {
    print('Mode:            [DRY RUN]');
  }
  print('====================================================');

  if (args['github-output'] == true) {
    final outputFilePath = Platform.environment['GITHUB_OUTPUT'];
    if (outputFilePath != null && outputFilePath.isNotEmpty) {
      final outputFile = File(outputFilePath);
      outputFile.writeAsStringSync(
        'version=$newVersion\n'
        'semver=$semver\n'
        'build_number=$newBuild\n'
        'tag_name=$tagName\n'
        'release_channel=$channel\n',
        mode: FileMode.append,
      );
      print('✓ Wrote outputs to $outputFilePath');
    }
  }

  if (isDryRun) {
    print('[DRY RUN] Skipping file writes and git commands.');
    return;
  }

  // Update pubspec.yaml
  if (await primaryPubspec.exists()) {
    final content = await primaryPubspec.readAsString();
    final updated = content.replaceFirst(
      RegExp(r'^version:\s*[^\s\r\n]+', multiLine: true),
      'version: $newVersion',
    );
    await primaryPubspec.writeAsString(updated);
    print('✓ Updated pubspec.yaml to $newVersion');
  }

  // Update lib/src/version.dart
  final flutterVersionFile = File('lib/src/version.dart');
  if (!flutterVersionFile.parent.existsSync()) {
    flutterVersionFile.parent.createSync(recursive: true);
  }
  await flutterVersionFile.writeAsString('''// Generated code. Do not modify.
const packageVersion = '$newVersion';
''');
  print('✓ Updated lib/src/version.dart');

  // Update content/changelog.md and CHANGELOG.md with public commit entries
  final prevTag = ChangelogParser.getPreviousTag();
  final commits = ChangelogParser.getCommits(fromRef: prevTag, toRef: 'HEAD');
  final publicEntries = ChangelogParser.extractAll(commits);

  final changelogFile = File('content/changelog.md');
  if (await changelogFile.exists()) {
    ChangelogParser.updateChangelogFile(
      file: changelogFile,
      semver: semver,
      entries: publicEntries,
    );
    print(
      '✓ Updated ## $semver in content/changelog.md (${publicEntries.length} public entries since ${prevTag ?? "start"})',
    );
  }

  final rootChangelogFile = File('CHANGELOG.md');
  if (await rootChangelogFile.exists()) {
    ChangelogParser.updateChangelogFile(
      file: rootChangelogFile,
      semver: semver,
      entries: publicEntries,
    );
    print(
      '✓ Updated ## $semver in CHANGELOG.md (${publicEntries.length} public entries since ${prevTag ?? "start"})',
    );
  }

  // Git operations
  if (shouldCommit) {
    print('Configuring git user identity ($gitUserName <$gitUserEmail>)...');
    await Process.run(
      'git',
      ['config', 'user.name', gitUserName],
      runInShell: true,
    );
    await Process.run(
      'git',
      ['config', 'user.email', gitUserEmail],
      runInShell: true,
    );

    print('Committing version changes...');
    final filesToAdd = [
      'pubspec.yaml',
      'lib/src/version.dart',
      'content/changelog.md',
      'CHANGELOG.md',
    ];
    for (final path in filesToAdd) {
      if (File(path).existsSync()) {
        await runCommand('git', ['add', path]);
      }
    }
    await runCommand('git', [
      'commit',
      '-m',
      'chore(release): bump version to $tagName [skip ci]',
    ]);
    print('✓ Committed version bump commit');
  }

  if (shouldTag) {
    print('Creating tag $tagName...');
    await runCommand('git', ['tag', '-a', tagName, '-m', 'Release $tagName']);
    print('✓ Created git tag $tagName');
  }

  if (shouldPush) {
    print('Pushing changes and tags...');
    await runCommand('git', ['push']);
    if (shouldTag) {
      await runCommand('git', ['push', 'origin', tagName]);
    }
    print('✓ Pushed changes and tags to origin');
  }

  print('Done! Successfully processed release $newVersion');
}

Future<void> runCommand(String executable, List<String> arguments) async {
  final result = await Process.run(executable, arguments, runInShell: true);
  if (result.exitCode != 0) {
    print('Error running $executable ${arguments.join(' ')}');
    print(result.stdout);
    print(result.stderr);
    exit(1);
  }
}
