// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'changelog_parser.dart';

Map<String, String> _loadDotEnv() {
  final env = <String, String>{};
  final possiblePaths = ['.env', '../.env'];
  for (final p in possiblePaths) {
    final file = File(p);
    if (file.existsSync()) {
      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final idx = trimmed.indexOf('=');
        if (idx > 0) {
          final key = trimmed.substring(0, idx).trim();
          final val = trimmed.substring(idx + 1).trim();
          env[key] = val;
        }
      }
      break;
    }
  }
  return env;
}

/// Class representing a parsed git commit for developer history.
class ReleaseCommit {
  final String hash;
  final String shortHash;
  final String subject;
  final String author;

  ReleaseCommit({
    required this.hash,
    required this.shortHash,
    required this.subject,
    required this.author,
  });

  String get category {
    final clean = subject.trim().toLowerCase();
    if (clean.startsWith('feat') || clean.startsWith('feature')) {
      return '🚀 Features';
    }
    if (clean.startsWith('fix')) {
      return '🐛 Bug Fixes';
    }
    if (clean.startsWith('perf')) {
      return '⚡ Performance';
    }
    if (clean.startsWith('refactor')) {
      return '🔄 Refactoring';
    }
    if (clean.startsWith('docs')) {
      return '📚 Documentation';
    }
    if (clean.startsWith('test')) {
      return '🧪 Tests';
    }
    if (clean.startsWith('chore') ||
        clean.startsWith('ci') ||
        clean.startsWith('build')) {
      return '🛠️ Maintenance & Tooling';
    }
    return '🌱 Other Changes';
  }

  String formatMarkdown(String repoBaseUrl) {
    var desc = subject.trim();
    final match = RegExp(r'^(\w+)(?:\(([^)]+)\))?!?:\s*(.*)$').firstMatch(desc);
    if (match != null) {
      final scope = match.group(2);
      final rest = match.group(3) ?? '';
      if (scope != null && scope.isNotEmpty) {
        desc = '**$scope**: $rest';
      } else {
        desc = rest;
      }
    }

    final commitUrl = '$repoBaseUrl/commit/$hash';
    return '- $desc ([`$shortHash`]($commitUrl))';
  }
}

/// Metadata for a downloadable release file artifact.
class ReleaseArtifact {
  final String platform;
  final String packageType;
  final String arch;
  final File file;
  final String fileName;
  final int sizeBytes;
  final String sha256Checksum;
  final String downloadUrl;

  ReleaseArtifact({
    required this.platform,
    required this.packageType,
    required this.arch,
    required this.file,
    required this.fileName,
    required this.sizeBytes,
    required this.sha256Checksum,
    required this.downloadUrl,
  });

  String get formattedSize {
    if (sizeBytes <= 0) return '0 B';
    final mb = sizeBytes / (1024 * 1024);
    if (mb >= 1.0) {
      return '${mb.toStringAsFixed(1)} MB';
    }
    final kb = sizeBytes / 1024;
    return '${kb.toStringAsFixed(1)} KB';
  }
}

class ReleaseNotesGenerator {
  final String repoUrl;
  final String repoName;
  final String apiBaseUrl;
  final String? giteaToken;

  ReleaseNotesGenerator({
    this.repoUrl = 'https://git.rodydavis.dev/rodydavis/the-pocket-piano',
    this.repoName = 'rodydavis/the-pocket-piano',
    this.apiBaseUrl = 'https://git.rodydavis.dev',
    this.giteaToken,
  });

  /// Check if a commit subject is a release version bump.
  static bool isReleaseBumpCommit(String subject) {
    return ChangelogParser.isReleaseBumpCommit(subject);
  }

  /// Discover all commits between [fromRef] and [toRef].
  List<ReleaseCommit> getCommits({String? fromRef, required String toRef}) {
    final gitCommits = ChangelogParser.getCommits(
      fromRef: fromRef,
      toRef: toRef,
    );
    return gitCommits
        .map(
          (c) => ReleaseCommit(
            hash: c.hash,
            shortHash: c.shortHash,
            subject: c.subject,
            author: c.author,
          ),
        )
        .toList();
  }

  /// Find the preceding `v*` tag before [currentTag], ignoring moving channel tags (`daily`, `weekly`, `monthly`).
  String? getPreviousTag(String currentTag) {
    return ChangelogParser.getPreviousTag(currentTag: currentTag);
  }

  /// Compute SHA-256 for a given file.
  static String calculateSha256(File file) {
    if (!file.existsSync()) return '';
    final bytes = file.readAsBytesSync();
    return sha256.convert(bytes).toString();
  }

  /// Scan an artifacts directory for build outputs if present.
  List<ReleaseArtifact> scanArtifacts({
    required Directory artifactsDir,
    required String version,
  }) {
    final list = <ReleaseArtifact>[];
    if (!artifactsDir.existsSync()) return list;

    final allFiles = artifactsDir.listSync(recursive: true).whereType<File>();

    for (final file in allFiles) {
      final name = file.uri.pathSegments.last;
      final lower = name.toLowerCase();

      if (lower.endsWith('.aab')) {
        final hash = calculateSha256(file);
        list.add(
          ReleaseArtifact(
            platform: 'Android',
            packageType: 'App Bundle (AAB)',
            arch: 'Universal',
            file: file,
            fileName: name,
            sizeBytes: file.lengthSync(),
            sha256Checksum: hash,
            downloadUrl: '$repoUrl/releases/download/v$version/$name',
          ),
        );
      } else if (lower.endsWith('.apk')) {
        final hash = calculateSha256(file);
        list.add(
          ReleaseArtifact(
            platform: 'Android',
            packageType: 'APK Installer',
            arch: 'Universal',
            file: file,
            fileName: name,
            sizeBytes: file.lengthSync(),
            sha256Checksum: hash,
            downloadUrl: '$repoUrl/releases/download/v$version/$name',
          ),
        );
      } else if (lower.endsWith('.ipa')) {
        final hash = calculateSha256(file);
        list.add(
          ReleaseArtifact(
            platform: 'iOS / iPadOS',
            packageType: 'App Store IPA',
            arch: 'ARM64',
            file: file,
            fileName: name,
            sizeBytes: file.lengthSync(),
            sha256Checksum: hash,
            downloadUrl: '$repoUrl/releases/download/v$version/$name',
          ),
        );
      } else if (lower.endsWith('.dmg')) {
        final hash = calculateSha256(file);
        list.add(
          ReleaseArtifact(
            platform: 'macOS',
            packageType: 'Universal DMG',
            arch: 'Apple Silicon + Intel',
            file: file,
            fileName: name,
            sizeBytes: file.lengthSync(),
            sha256Checksum: hash,
            downloadUrl: '$repoUrl/releases/download/v$version/$name',
          ),
        );
      }
    }

    return list;
  }

  /// Generate comprehensive release markdown notes.
  String generateMarkdown({
    required String currentTag,
    String? previousTag,
    required List<ReleaseCommit> commits,
    List<ReleaseArtifact> artifacts = const [],
    List<PublicChangelogEntry> publicEntries = const [],
    String channel = 'daily',
  }) {
    final buffer = StringBuffer();
    final cleanVersion = currentTag.startsWith('v')
        ? currentTag.substring(1)
        : currentTag;

    buffer.writeln('# 🎹 The Pocket Piano v$cleanVersion\n');
    buffer.writeln('Automated release for channel **$channel**.\n');

    // 1. Public What's New Section
    buffer.write(ChangelogParser.formatReleaseNotesWhatIsNew(publicEntries));
    buffer.writeln('---\n');

    // 2. Platforms & Distribution Table
    buffer.writeln('## 📱 Platforms & Distribution\n');
    if (artifacts.isNotEmpty) {
      buffer.writeln(
        '| Platform | Package | Architecture | Size | Checksum (SHA-256) | Download |',
      );
      buffer.writeln(
        '| :--- | :--- | :--- | :--- | :--- | :--- |',
      );
      for (final a in artifacts) {
        final shortHash = a.sha256Checksum.isNotEmpty
            ? '`${a.sha256Checksum.substring(0, 12)}...`'
            : '—';
        buffer.writeln(
          '| **${a.platform}** | ${a.packageType} | ${a.arch} | ${a.formattedSize} | $shortHash | [${a.fileName}](${a.downloadUrl}) |',
        );
      }
      buffer.writeln();
    } else {
      buffer.writeln(
        '| Platform | Channel | Link |',
      );
      buffer.writeln(
        '| :--- | :--- | :--- |',
      );
      buffer.writeln(
        '| **Web App** | Production | [pocketpiano.app](https://pocketpiano.app) |',
      );
      buffer.writeln(
        '| **iOS & iPadOS** | App Store / TestFlight | [App Store](https://apps.apple.com/us/app/the-pocket-piano/id1453992672) |',
      );
      buffer.writeln(
        '| **Android** | Google Play | [Google Play](https://play.google.com/store/apps/details?id=com.appleeducate.flutter_piano) |',
      );
      buffer.writeln();
    }

    buffer.writeln('---\n');

    // 3. Docker Containers Table
    buffer.writeln('## 🐳 Docker Containers\n');
    buffer.writeln('| Service | Registry Image | Tag(s) | Architecture |');
    buffer.writeln('| :--- | :--- | :--- | :--- |');
    buffer.writeln(
      '| **Web App** | `git.rodydavis.dev/rodydavis/the-pocket-piano` | `:latest` | `linux/amd64` |',
    );
    buffer.writeln();

    buffer.writeln('---\n');

    // 4. Developer Commit History (Collapsible details)
    final commitCount = commits.length;
    final historyTitle = previousTag != null && previousTag.isNotEmpty
        ? '📋 Full Developer Commit History ($commitCount commits since $previousTag)'
        : '📋 Full Developer Commit History ($commitCount commits)';

    buffer.writeln('<details>');
    buffer.writeln('<summary><b>$historyTitle</b></summary>\n');

    if (commits.isEmpty) {
      buffer.writeln('*No code commits recorded in this release.*');
    } else {
      final grouped = <String, List<ReleaseCommit>>{};
      for (final c in commits) {
        grouped.putIfAbsent(c.category, () => []).add(c);
      }

      final categoryOrder = [
        '🚀 Features',
        '🐛 Bug Fixes',
        '⚡ Performance',
        '🔄 Refactoring',
        '📚 Documentation',
        '🧪 Tests',
        '🛠️ Maintenance & Tooling',
        '🌱 Other Changes',
      ];

      for (final cat in categoryOrder) {
        final catCommits = grouped[cat];
        if (catCommits != null && catCommits.isNotEmpty) {
          buffer.writeln('### $cat');
          for (final c in catCommits) {
            buffer.writeln(c.formatMarkdown(repoUrl));
          }
          buffer.writeln();
        }
      }
    }
    buffer.writeln('</details>');

    return buffer.toString().trim();
  }

  /// Update or create the Gitea Release object via REST API.
  Future<bool> updateGiteaRelease({
    required String tagName,
    required String title,
    required String body,
    List<ReleaseArtifact> artifactsToUpload = const [],
  }) async {
    if (giteaToken == null || giteaToken!.isEmpty) {
      print('Warning: No Gitea token provided, skipping remote API update.');
      return false;
    }

    final headers = {
      'Authorization': 'token $giteaToken',
      'Content-Type': 'application/json',
    };

    final client = http.Client();
    try {
      // 1. Fetch release by tag
      final getUri = Uri.parse(
        '$apiBaseUrl/api/v1/repos/$repoName/releases/tags/$tagName',
      );
      final getRes = await client.get(getUri, headers: headers);
      int? releaseId;

      if (getRes.statusCode == 200) {
        final data = jsonDecode(getRes.body) as Map<String, dynamic>;
        releaseId = data['id'] as int?;
      }

      // 2. Create or patch release
      if (releaseId == null) {
        print(
          'Release for tag $tagName not found on Gitea. Creating new release...',
        );
        final postUri = Uri.parse('$apiBaseUrl/api/v1/repos/$repoName/releases');
        final createRes = await client.post(
          postUri,
          headers: headers,
          body: jsonEncode({
            'tag_name': tagName,
            'name': title,
            'body': body,
            'draft': false,
            'prerelease': false,
          }),
        );
        if (createRes.statusCode >= 200 && createRes.statusCode < 300) {
          final data = jsonDecode(createRes.body) as Map<String, dynamic>;
          releaseId = data['id'] as int?;
          print('✓ Created Gitea Release for $tagName (ID: $releaseId)');
        } else {
          print(
            'Error creating Gitea Release: ${createRes.statusCode} ${createRes.body}',
          );
          return false;
        }
      } else {
        print('Updating Gitea Release ID: $releaseId...');
        final patchUri = Uri.parse(
          '$apiBaseUrl/api/v1/repos/$repoName/releases/$releaseId',
        );
        final patchRes = await client.patch(
          patchUri,
          headers: headers,
          body: jsonEncode({
            'name': title,
            'body': body,
          }),
        );
        if (patchRes.statusCode >= 200 && patchRes.statusCode < 300) {
          print('✓ Updated Gitea Release #$releaseId description for $tagName');
        } else {
          print(
            'Error updating release: ${patchRes.statusCode} ${patchRes.body}',
          );
          return false;
        }
      }

      // 3. Upload release assets if requested
      if (releaseId != null && artifactsToUpload.isNotEmpty) {
        print(
          'Uploading ${artifactsToUpload.length} artifacts to Gitea Release...',
        );
        final assetsUri = Uri.parse(
          '$apiBaseUrl/api/v1/repos/$repoName/releases/$releaseId/assets',
        );
        final existingRes = await client.get(assetsUri, headers: headers);
        final existingNames = <String>{};
        if (existingRes.statusCode == 200) {
          final items = jsonDecode(existingRes.body) as List<dynamic>? ?? [];
          for (final item in items) {
            final n = (item as Map<String, dynamic>)['name'] as String?;
            if (n != null) existingNames.add(n);
          }
        }

        for (final a in artifactsToUpload) {
          if (!a.file.existsSync()) continue;
          if (existingNames.contains(a.fileName)) {
            print(
              'Asset ${a.fileName} already uploaded to Gitea Release, skipping.',
            );
            continue;
          }

          print('Uploading ${a.fileName} (${a.formattedSize}) to Gitea...');
          final uploadUri = Uri.parse(
            '$apiBaseUrl/api/v1/repos/$repoName/releases/$releaseId/assets?name=${Uri.encodeComponent(a.fileName)}',
          );

          final request = http.MultipartRequest('POST', uploadUri)
            ..headers['Authorization'] = 'token $giteaToken'
            ..files.add(
              await http.MultipartFile.fromPath(
                'attachment',
                a.file.path,
                filename: a.fileName,
              ),
            );

          final streamed = await client.send(request);
          if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
            print('✓ Uploaded asset: ${a.fileName}');
          } else {
            print(
              'Warning: Failed to upload ${a.fileName}: HTTP ${streamed.statusCode}',
            );
          }
        }
      }

      return true;
    } finally {
      client.close();
    }
  }
}

void main(List<String> rawArgs) async {
  final parser = ArgParser()
    ..addOption(
      'tag',
      abbr: 't',
      help: 'Target git release tag (e.g. v2026.10.23+503)',
    )
    ..addOption(
      'from',
      help: 'Optional starting git tag or ref (auto-detected if omitted)',
    )
    ..addOption(
      'metadata-dir',
      abbr: 'm',
      defaultsTo: 'artifacts',
      help: 'Directory containing downloaded build artifacts & metadata',
    )
    ..addOption(
      'channel',
      abbr: 'c',
      defaultsTo: 'daily',
      help: 'Release channel name (e.g. daily, weekly, monthly)',
    )
    ..addOption('token', help: 'Gitea API token')
    ..addOption(
      'repo',
      help: 'Gitea repository (owner/repo)',
      defaultsTo: 'rodydavis/the-pocket-piano',
    )
    ..addOption(
      'url',
      help: 'Gitea base URL',
      defaultsTo: 'https://git.rodydavis.dev',
    )
    ..addOption(
      'api-url',
      help: 'Alias for --url (Gitea base URL)',
    )
    ..addFlag(
      'upload-assets',
      defaultsTo: false,
      help: 'Upload binary files directly as Gitea Release assets',
    )
    ..addFlag(
      'dry-run',
      defaultsTo: false,
      help: 'Print markdown release notes without updating Gitea',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final results = parser.parse(rawArgs);
  if (results['help'] == true) {
    print('Usage: dart scripts/update_release_notes.dart [options]');
    print(parser.usage);
    exit(0);
  }

  final dotEnv = _loadDotEnv();
  final rawToken = results['token'] as String?;
  final token = (rawToken != null && rawToken.isNotEmpty)
      ? rawToken
      : (Platform.environment['GITEA_TOKEN'] ??
            Platform.environment['GIT_TOKEN'] ??
            Platform.environment['GITHUB_TOKEN'] ??
            dotEnv['GITEA_TOKEN'] ??
            dotEnv['GIT_TOKEN'] ??
            '');
  final giteaUrl =
      (results['api-url'] as String?) ??
      (results['url'] as String?) ??
      Platform.environment['GITEA_URL'] ??
      dotEnv['GITEA_URL'] ??
      'https://git.rodydavis.dev';
  final giteaRepo =
      (results['repo'] as String?) ??
      Platform.environment['GITHUB_REPOSITORY'] ??
      Platform.environment['GITEA_REPO'] ??
      dotEnv['GITEA_REPO'] ??
      'rodydavis/the-pocket-piano';
  final channel = results['channel'] as String;
  final metadataDir = Directory(results['metadata-dir'] as String);
  final shouldUploadAssets = results['upload-assets'] as bool;
  final isDryRun = results['dry-run'] as bool;

  // 1. Resolve Tag (matching v* to avoid moving channel tags like daily/weekly/monthly)
  String tag = results['tag'] as String? ?? '';
  if (tag.isEmpty) {
    final describe = Process.runSync('git', [
      'describe',
      '--tags',
      '--match',
      'v*',
      '--abbrev=0',
    ]);
    if (describe.exitCode == 0) {
      tag = describe.stdout.toString().trim();
    } else {
      final tagList = Process.runSync('git', [
        'tag',
        '-l',
        'v*',
        '--sort=-v:refname',
      ]);
      if (tagList.exitCode == 0) {
        final tags = tagList.stdout
            .toString()
            .trim()
            .split('\n')
            .where((t) => RegExp(r'^v\d+\.\d+').hasMatch(t.trim()))
            .toList();
        if (tags.isNotEmpty) {
          tag = tags.first.trim();
        }
      }
    }
  }
  if (tag.isEmpty) {
    final pubspec = File('pubspec.yaml');
    if (pubspec.existsSync()) {
      final match = RegExp(
        r'^version:\s*([^\s\r\n]+)',
        multiLine: true,
      ).firstMatch(pubspec.readAsStringSync());
      if (match != null) {
        tag = 'v${match.group(1)}';
      }
    }
  }

  if (tag.isEmpty) {
    print('Error: Could not determine release tag.');
    exit(1);
  }

  final generator = ReleaseNotesGenerator(
    repoUrl: '$giteaUrl/$giteaRepo',
    repoName: giteaRepo,
    apiBaseUrl: giteaUrl,
    giteaToken: token,
  );

  final tagExists =
      Process.runSync('git', ['rev-parse', '--verify', tag]).exitCode == 0;
  final toRef = tagExists ? tag : 'HEAD';

  final previousTag =
      (results['from'] as String?) ??
      generator.getPreviousTag(tagExists ? tag : '');
  print(
    'Updating release notes for $tag (previous tag: ${previousTag ?? "none"})...',
  );

  final commits = generator.getCommits(fromRef: previousTag, toRef: toRef);
  final gitCommits = ChangelogParser.getCommits(
    fromRef: previousTag,
    toRef: toRef,
  );
  final publicEntries = ChangelogParser.extractAll(gitCommits);

  final cleanVersion = tag.startsWith('v') ? tag.substring(1) : tag;
  final artifacts = generator.scanArtifacts(
    artifactsDir: metadataDir,
    version: cleanVersion,
  );

  final releaseBody = generator.generateMarkdown(
    currentTag: tag,
    previousTag: previousTag,
    commits: commits,
    artifacts: artifacts,
    publicEntries: publicEntries,
    channel: channel,
  );

  print('\n--- GENERATED RELEASE NOTES ---\n');
  print(releaseBody);
  print('\n-------------------------------\n');

  if (isDryRun || token.isEmpty) {
    if (token.isEmpty && !isDryRun) {
      print('Warning: GITEA_TOKEN is not set. Skipping remote Gitea API update.');
    }
    return;
  }

  final success = await generator.updateGiteaRelease(
    tagName: tag,
    title: 'Release $tag',
    body: releaseBody,
    artifactsToUpload: shouldUploadAssets ? artifacts : [],
  );

  if (!success) {
    exit(1);
  }

  print('✓ Release notes processing complete.');
}
