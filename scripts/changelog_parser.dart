// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'package:args/args.dart';

/// Represents a single public-facing changelog entry.
class PublicChangelogEntry {
  final String category; // 'Added', 'Fixed', 'Changed', or 'Other'
  final String description;
  final String? scope;
  final String? commitHash;

  PublicChangelogEntry({
    required this.category,
    required this.description,
    this.scope,
    this.commitHash,
  });

  String get formattedLine {
    final trimmed = description.trim();
    if (trimmed.startsWith('**')) {
      return '- $trimmed';
    }
    if (scope != null && scope!.isNotEmpty) {
      return '- **$scope**: $trimmed';
    }
    return '- $trimmed';
  }
}

/// Represents a raw commit with its full body.
class GitCommitData {
  final String hash;
  final String shortHash;
  final String subject;
  final String author;
  final String body;

  GitCommitData({
    required this.hash,
    required this.shortHash,
    required this.subject,
    required this.author,
    required this.body,
  });
}

class ChangelogParser {
  /// Check if a commit subject is purely a release version bump.
  static bool isReleaseBumpCommit(String subject) {
    final clean = subject.trim().toLowerCase();
    return clean.startsWith('chore(release):') ||
        clean.startsWith('chore: release') ||
        clean.startsWith('chore: bump version') ||
        clean.startsWith('bump version to');
  }

  /// Find the latest or preceding release tag (`v*`), ignoring moving channel tags (`daily`, `weekly`, `monthly`).
  static String? getPreviousTag({String? currentTag}) {
    if (currentTag != null && currentTag.isNotEmpty) {
      final describeResult = Process.runSync('git', [
        'describe',
        '--tags',
        '--match',
        'v*',
        '--abbrev=0',
        '$currentTag^',
      ]);
      if (describeResult.exitCode == 0) {
        final candidate = describeResult.stdout.toString().trim();
        if (candidate.isNotEmpty && candidate != currentTag) {
          return candidate;
        }
      }
    }

    final result = Process.runSync('git', [
      'tag',
      '-l',
      'v*',
      '--sort=-v:refname',
    ]);
    if (result.exitCode != 0) return null;

    final tags = result.stdout
        .toString()
        .trim()
        .split('\n')
        .map((t) => t.trim())
        .where((t) => RegExp(r'^v\d+\.\d+').hasMatch(t))
        .toList();

    if (tags.isEmpty) return null;

    if (currentTag == null || currentTag.isEmpty) {
      return tags.first;
    }

    final idx = tags.indexOf(currentTag);
    if (idx != -1 && idx + 1 < tags.length) {
      return tags[idx + 1];
    }
    if (idx == -1) {
      return tags.first;
    }
    return null;
  }

  /// Parse git log output using record (0x1e) and field (0x1f) separators.
  static List<GitCommitData> parseGitLogOutput(String stdout) {
    final commits = <GitCommitData>[];
    if (stdout.trim().isEmpty) return commits;

    final records = stdout.split('\x1e');
    for (final rec in records) {
      final trimmed = rec.trim();
      if (trimmed.isEmpty) continue;

      final fields = trimmed.split('\x1f');
      if (fields.length >= 5) {
        final hash = fields[0].trim();
        final shortHash = fields[1].trim();
        final subject = fields[2].trim();
        final author = fields[3].trim();
        final body = fields[4].trim();

        if (!isReleaseBumpCommit(subject)) {
          commits.add(
            GitCommitData(
              hash: hash,
              shortHash: shortHash,
              subject: subject,
              author: author,
              body: body,
            ),
          );
        }
      }
    }
    return commits;
  }

  /// Fetch commit history from git between [fromRef] and [toRef].
  static List<GitCommitData> getCommits({
    String? fromRef,
    required String toRef,
  }) {
    final range = (fromRef != null && fromRef.isNotEmpty)
        ? '$fromRef..$toRef'
        : toRef;

    final args = [
      'log',
      '--format=%H%x1f%h%x1f%s%x1f%an%x1f%B%x1e',
      if (fromRef == null || fromRef.isEmpty) ...['-n', '40'],
      range,
    ];

    final result = Process.runSync('git', args);
    if (result.exitCode != 0) return [];

    return parseGitLogOutput(result.stdout.toString());
  }

  /// Extract conventional scope from commit subject (e.g. `feat(editor): ...` -> `editor`).
  static String? extractScope(String subject) {
    final match = RegExp(
      r'^\w+(?:\(([^)]+)\))?!?:\s*(.*)$',
    ).firstMatch(subject.trim());
    if (match != null) {
      final s = match.group(1)?.trim();
      if (s != null && s.isNotEmpty) return s;
    }
    return null;
  }

  /// Extract clean description without conventional commit prefix.
  static String cleanSubjectDescription(String subject) {
    final match = RegExp(
      r'^\w+(?:\([^)]+\))?!?:\s*(.*)$',
    ).firstMatch(subject.trim());
    if (match != null) {
      final desc = match.group(1)?.trim() ?? '';
      if (desc.isNotEmpty) {
        return desc[0].toUpperCase() + desc.substring(1);
      }
    }
    return subject.trim();
  }

  /// Determine category for conventional commit subject.
  static String determineCategory(String subject) {
    final clean = subject.trim().toLowerCase();
    if (clean.startsWith('feat') || clean.startsWith('feature')) {
      return 'Added';
    }
    if (clean.startsWith('fix')) {
      return 'Fixed';
    }
    if (clean.startsWith('perf') || clean.startsWith('refactor')) {
      return 'Changed';
    }
    return 'Other';
  }

  /// Check if a release-note value explicitly opts out of public release notes.
  static bool isSuppressionValue(String value) {
    final clean = value.trim().toLowerCase();
    return clean == 'none' ||
        clean == 'skip' ||
        clean == 'n/a' ||
        clean == 'false' ||
        clean == 'no';
  }

  /// Parse public changelog entries from a commit.
  static List<PublicChangelogEntry> extractPublicEntries(GitCommitData commit) {
    final entries = <PublicChangelogEntry>[];
    final scope = extractScope(commit.subject);
    final category = determineCategory(commit.subject);
    final fullText = '${commit.subject}\n\n${commit.body}';

    final collectedItems = <String>[];
    var explicitlySuppressed = false;

    // 1. Check for fenced ```release-note / ```release-notes / ```changelog blocks
    final fencedRegex = RegExp(
      r'```(?:release-notes?|changelog)\s*\r?\n([\s\S]*?)```',
      caseSensitive: false,
    );
    for (final match in fencedRegex.allMatches(commit.body)) {
      final blockContent = match.group(1)?.trim() ?? '';
      if (blockContent.isEmpty) continue;
      if (isSuppressionValue(blockContent)) {
        explicitlySuppressed = true;
        continue;
      }
      for (final line in blockContent.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        if (isSuppressionValue(trimmed)) {
          explicitlySuppressed = true;
          continue;
        }
        collectedItems.add(trimmed);
      }
    }

    // 2. Check for Git trailers: Changelog:, Release-Notes:, Release-Note:, Public:
    final lines = fullText.split('\n');
    var inTrailer = false;
    final trailerLines = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      final trailerMatch = RegExp(
        r'^(?:Changelog|Release-Notes?|Public):\s*(.*)$',
        caseSensitive: false,
      ).firstMatch(trimmed);

      if (trailerMatch != null) {
        inTrailer = true;
        final rest = trailerMatch.group(1)?.trim() ?? '';
        if (rest.isNotEmpty) {
          if (isSuppressionValue(rest)) {
            explicitlySuppressed = true;
            inTrailer = false;
          } else {
            trailerLines.add(rest);
          }
        }
        continue;
      }

      if (inTrailer) {
        if (RegExp(r'^[A-Z][a-zA-Z0-9_-]+:\s*').hasMatch(trimmed)) {
          inTrailer = false;
          continue;
        }
        if (trimmed.startsWith('- ') ||
            trimmed.startsWith('* ') ||
            line.startsWith('  ')) {
          trailerLines.add(trimmed);
        } else if (trimmed.isEmpty) {
          if (trailerLines.isNotEmpty) {
            inTrailer = false;
          }
        } else {
          if (trailerLines.isEmpty) {
            if (isSuppressionValue(trimmed)) {
              explicitlySuppressed = true;
            } else {
              trailerLines.add(trimmed);
            }
          } else {
            inTrailer = false;
          }
        }
      }
    }

    collectedItems.addAll(trailerLines);

    if (collectedItems.isNotEmpty) {
      for (var item in collectedItems) {
        item = item.trim();
        if (item.isEmpty) continue;
        if (item.startsWith('- ') || item.startsWith('* ')) {
          item = item.substring(2).trim();
        }
        if (item.isNotEmpty && !isSuppressionValue(item)) {
          item = item[0].toUpperCase() + item.substring(1);
          entries.add(
            PublicChangelogEntry(
              category: category,
              description: item,
              scope: scope,
              commitHash: commit.hash,
            ),
          );
        }
      }
      return entries;
    }

    if (explicitlySuppressed) {
      return entries;
    }

    // 3. Smart fallback: Only include conventional feat, fix, perf commits
    final convMatch = RegExp(
      r'^(feat|feature|fix|perf)(?:\(([^)]+)\))?!?:\s+(.+)$',
      caseSensitive: false,
    ).firstMatch(commit.subject.trim());

    if (convMatch != null) {
      final type = convMatch.group(1)!.toLowerCase();
      final rawScope = convMatch.group(2)?.trim().toLowerCase() ?? '';
      final scopeParts = rawScope
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      const internalScopes = {'ci', 'test', 'tests', 'chore', 'build', 'deps'};
      final isInternalOnlyScope =
          scopeParts.isNotEmpty &&
          scopeParts.every((s) => internalScopes.contains(s));

      if (!isInternalOnlyScope) {
        final fallbackCategory = (type == 'feat' || type == 'feature')
            ? 'Added'
            : type == 'fix'
            ? 'Fixed'
            : 'Changed';

        final desc = cleanSubjectDescription(commit.subject);
        entries.add(
          PublicChangelogEntry(
            category: fallbackCategory,
            description: desc,
            scope: scope,
            commitHash: commit.hash,
          ),
        );
      }
    }

    return entries;
  }

  /// Extract all public changelog entries from a list of commits.
  static List<PublicChangelogEntry> extractAll(List<GitCommitData> commits) {
    final all = <PublicChangelogEntry>[];
    for (final c in commits) {
      all.addAll(extractPublicEntries(c));
    }
    return all;
  }

  /// Format public entries for `content/changelog.md`:
  ///
  /// ## 2026.10.22
  ///
  /// - **piano**: Add chord detector for keys pressed in landscape
  static String formatChangelogSection({
    required String semver,
    required List<PublicChangelogEntry> entries,
  }) {
    final cleanSemver = semver
        .trim()
        .replaceFirst(RegExp(r'^v', caseSensitive: false), '')
        .split('+')
        .first;
    final buffer = StringBuffer();
    buffer.writeln('## $cleanSemver\n');

    if (entries.isEmpty) {
      buffer.writeln('- Maintenance and stability improvements.');
      return buffer.toString();
    }

    final seen = <String>{};
    for (final entry in entries) {
      final line = entry.formattedLine;
      if (seen.add(line)) {
        buffer.writeln(line);
      }
    }
    return buffer.toString().trimRight();
  }

  /// Check if a changelog section body is just a generic placeholder.
  static bool isPlaceholderChangelogBody(String body) {
    final clean = body.trim();
    if (clean.isEmpty) return true;
    final normalized = clean
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (normalized.length == 1) {
      final single = normalized.first.toLowerCase();
      return single == '- automated release updates.' ||
          single == '- automated release updates' ||
          single == '- maintenance and stability improvements.' ||
          single == '- maintenance and stability improvements';
    }
    return false;
  }

  /// Updates `content/changelog.md` content for [semver] with [entries].
  static String updateChangelogString({
    required String existingContent,
    required String semver,
    required List<PublicChangelogEntry> entries,
  }) {
    final cleanSemver = semver
        .trim()
        .replaceFirst(RegExp(r'^v', caseSensitive: false), '')
        .split('+')
        .first;

    final newLines = <String>[];
    for (final e in entries) {
      final line = e.formattedLine;
      if (!newLines.contains(line)) {
        newLines.add(line);
      }
    }

    final headerPattern = RegExp(
      r'^##\s+' + RegExp.escape(cleanSemver) + r'\s*$',
      multiLine: true,
    );
    final match = headerPattern.firstMatch(existingContent);

    if (match == null) {
      final section = formatChangelogSection(
        semver: cleanSemver,
        entries: entries,
      );
      final trimmedExisting = existingContent.trimLeft();
      if (trimmedExisting.isEmpty) {
        return '$section\n';
      }
      return '$section\n\n$trimmedExisting';
    }

    // Section `## <semver>` already exists; find where the next `## ` section begins.
    final nextHeaderRegex = RegExp(r'^##\s+', multiLine: true);
    final afterHeader = existingContent.substring(match.end);
    final nextMatch = nextHeaderRegex.firstMatch(afterHeader);

    final sectionEndIndex = nextMatch != null
        ? match.end + nextMatch.start
        : existingContent.length;

    final existingBody = existingContent
        .substring(match.end, sectionEndIndex)
        .trim();

    String updatedBody;
    if (isPlaceholderChangelogBody(existingBody)) {
      if (newLines.isEmpty) {
        updatedBody = existingBody.isNotEmpty
            ? existingBody
            : '- Maintenance and stability improvements.';
      } else {
        updatedBody = newLines.join('\n');
      }
    } else {
      final existingBulletLines = existingBody
          .split('\n')
          .map((l) => l.trimRight())
          .where((l) => l.trim().isNotEmpty)
          .toList();
      final combined = <String>[];
      for (final l in newLines) {
        if (!existingBulletLines.contains(l) && !combined.contains(l)) {
          combined.add(l);
        }
      }
      combined.addAll(existingBulletLines);
      updatedBody = combined.join('\n');
    }

    final before = existingContent.substring(0, match.start);
    final after = existingContent.substring(sectionEndIndex).trimLeft();
    final rebuiltSection = '## $cleanSemver\n\n$updatedBody';

    if (after.isEmpty) {
      return '$before$rebuiltSection\n';
    }
    return '$before$rebuiltSection\n\n$after';
  }

  /// Updates `content/changelog.md` on disk.
  static void updateChangelogFile({
    required File file,
    required String semver,
    required List<PublicChangelogEntry> entries,
  }) {
    final existing = file.existsSync() ? file.readAsStringSync() : '';
    final updated = updateChangelogString(
      existingContent: existing,
      semver: semver,
      entries: entries,
    );
    file.writeAsStringSync(updated);
  }

  /// Format public entries for Gitea Release markdown section:
  ///
  /// ## 🌟 What's New
  /// - 🚀 **Scope**: Feature description
  /// - 🐛 **Scope**: Fix description
  static String formatReleaseNotesWhatIsNew(
    List<PublicChangelogEntry> entries,
  ) {
    if (entries.isEmpty) {
      return '## 🌟 What\'s New\n\n- General stability and performance improvements.\n';
    }

    final buffer = StringBuffer();
    buffer.writeln('## 🌟 What\'s New\n');

    final seen = <String>{};
    for (final e in entries) {
      final emoji = e.category == 'Added'
          ? '🚀'
          : e.category == 'Fixed'
          ? '🐛'
          : '⚡';

      final desc = e.description.trim();
      final line =
          (e.scope != null && e.scope!.isNotEmpty && !desc.startsWith('**'))
          ? '- $emoji **${e.scope}**: $desc'
          : '- $emoji $desc';
      if (seen.add(line)) {
        buffer.writeln(line);
      }
    }
    buffer.writeln();
    return buffer.toString();
  }
}

void main(List<String> rawArgs) async {
  final parser = ArgParser()
    ..addOption('version', help: 'Target version (e.g. 2026.10.23+503)')
    ..addOption('from', help: 'Starting git ref or tag')
    ..addOption('to', defaultsTo: 'HEAD', help: 'Ending git ref or tag')
    ..addOption(
      'changelog-file',
      defaultsTo: 'content/changelog.md',
      help: 'Path to changelog.md to update',
    )
    ..addFlag(
      'write',
      defaultsTo: false,
      help: 'Update the changelog file on disk',
    )
    ..addFlag(
      'dry-run',
      defaultsTo: false,
      help: 'Print what would be generated without saving',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final args = parser.parse(rawArgs);

  if (args['help'] == true) {
    print('Usage: dart scripts/changelog_parser.dart [options]\n');
    print(parser.usage);
    exit(0);
  }

  var version = args['version'] as String? ?? '';
  if (version.isEmpty) {
    final pubspec = File('pubspec.yaml');
    if (pubspec.existsSync()) {
      final match = RegExp(
        r'^version:\s*([^\s\r\n]+)',
        multiLine: true,
      ).firstMatch(pubspec.readAsStringSync());
      if (match != null) {
        version = match.group(1)!;
      }
    }
  }
  if (version.isEmpty) {
    version = '2026.10.23+503';
  }

  final toRef = args['to'] as String;
  final fromRef =
      (args['from'] as String?) ??
      ChangelogParser.getPreviousTag(
        currentTag: toRef == 'HEAD' ? null : toRef,
      );
  final isDryRun = args['dry-run'] as bool;
  final shouldWrite = args['write'] as bool && !isDryRun;

  print('Extracting changelog from git commits ($fromRef..$toRef)...');
  final commits = ChangelogParser.getCommits(fromRef: fromRef, toRef: toRef);
  print('Found ${commits.length} commits.');

  final publicEntries = ChangelogParser.extractAll(commits);
  print('Extracted ${publicEntries.length} public changelog entries.');

  final semver = version.replaceFirst(RegExp(r'^v'), '').split('+').first;
  final section = ChangelogParser.formatChangelogSection(
    semver: semver,
    entries: publicEntries,
  );

  print('\n--- GENERATED CHANGELOG SECTION ---\n');
  print(section);
  print('-----------------------------------\n');

  if (shouldWrite) {
    final changelogPath = args['changelog-file'] as String;
    final file = File(changelogPath);
    ChangelogParser.updateChangelogFile(
      file: file,
      semver: semver,
      entries: publicEntries,
    );
    print('✓ Updated $changelogPath');
  }
}
