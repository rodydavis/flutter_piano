// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:test/test.dart';
import '../scripts/changelog_parser.dart';
import '../scripts/update_release_notes.dart';

void main() {
  group('ReleaseCommit Unit Tests', () {
    test('categorizes commit messages correctly', () {
      final feat = ReleaseCommit(
        hash: 'abc1234567890',
        shortHash: 'abc1234',
        subject: 'feat(piano): add chord detector in landscape',
        author: 'Rody Davis',
      );
      expect(feat.category, equals('🚀 Features'));

      final fix = ReleaseCommit(
        hash: 'def1234567890',
        shortHash: 'def1234',
        subject: 'fix(audio): resolve sustain release timing',
        author: 'Rody Davis',
      );
      expect(fix.category, equals('🐛 Bug Fixes'));
    });

    test('formats conventional markdown lines with commit links', () {
      final commit = ReleaseCommit(
        hash: '0123456789abcdef',
        shortHash: '0123456',
        subject: 'feat(ui): add dark mode high-contrast palette',
        author: 'Rody Davis',
      );

      final line = commit.formatMarkdown(
        'https://git.rodydavis.dev/rodydavis/the-pocket-piano',
      );
      expect(line, contains('**ui**: add dark mode high-contrast palette'));
      expect(
        line,
        contains(
          '([`0123456`](https://git.rodydavis.dev/rodydavis/the-pocket-piano/commit/0123456789abcdef))',
        ),
      );
    });
  });

  group('ReleaseNotesGenerator Unit Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('piano_test_artifacts_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test(
      'generateMarkdown produces What\'s New, distribution links, and categorized commit history',
      () {
        final generator = ReleaseNotesGenerator();

        final commits = [
          ReleaseCommit(
            hash: 'cb26056dca6e89e2934ab5dcb6d4affd11824524',
            shortHash: 'cb26056',
            subject: 'feat(piano): add chord detector in landscape',
            author: 'Rody Davis',
          ),
          ReleaseCommit(
            hash: '575606580fcf753960c604e9dd87c595a8fa1726',
            shortHash: '5756065',
            subject: 'fix(audio): fix piano playback speed',
            author: 'Rody Davis',
          ),
        ];

        final publicEntries = [
          PublicChangelogEntry(
            category: 'Added',
            description: 'Add chord detector in landscape.',
            scope: 'piano',
          ),
          PublicChangelogEntry(
            category: 'Fixed',
            description: 'Fix piano playback speed.',
            scope: 'audio',
          ),
        ];

        final markdown = generator.generateMarkdown(
          currentTag: 'v2026.10.23+503',
          previousTag: 'v2.0.1+502',
          commits: commits,
          publicEntries: publicEntries,
          channel: 'daily',
        );

        expect(
          markdown,
          contains('# 🎹 The Pocket Piano v2026.10.23+503'),
        );
        expect(markdown, contains('Automated release for channel **daily**.'));
        expect(markdown, contains('## 🌟 What\'s New'));
        expect(
          markdown,
          contains('- 🚀 **piano**: Add chord detector in landscape.'),
        );
        expect(
          markdown,
          contains('- 🐛 **audio**: Fix piano playback speed.'),
        );
        expect(markdown, contains('## 📱 Platforms & Distribution'));
        expect(markdown, contains('https://pocketpiano.app'));
        expect(
          markdown,
          contains('https://apps.apple.com/us/app/the-pocket-piano/id1453992672'),
        );
        expect(
          markdown,
          contains(
            'https://play.google.com/store/apps/details?id=com.appleeducate.flutter_piano',
          ),
        );
        expect(markdown, contains('## 🐳 Docker Containers'));
        expect(
          markdown,
          contains(
            '<summary><b>📋 Full Developer Commit History (2 commits since v2.0.1+502)</b></summary>',
          ),
        );
        expect(markdown, contains('### 🚀 Features'));
        expect(markdown, contains('### 🐛 Bug Fixes'));
        expect(markdown, contains('</details>'));
      },
    );
  });
}
