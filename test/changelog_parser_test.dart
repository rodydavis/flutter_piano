// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:test/test.dart';
import '../scripts/changelog_parser.dart';

void main() {
  group('ChangelogParser Unit Tests', () {
    test('extracts single-line Changelog trailer', () {
      final commit = GitCommitData(
        hash: '1111111111111111',
        shortHash: '1111111',
        subject: 'feat(piano): add chord detector for keys pressed in landscape',
        author: 'Rody Davis',
        body: '''
Added chord recognition overlay in landscape orientation.

Changelog: Real-time chord detection in landscape mode.
''',
      );

      final entries = ChangelogParser.extractPublicEntries(commit);
      expect(entries.length, equals(1));
      expect(entries.first.category, equals('Added'));
      expect(entries.first.scope, equals('piano'));
      expect(
        entries.first.description,
        equals('Real-time chord detection in landscape mode.'),
      );
      expect(
        entries.first.formattedLine,
        equals('- **piano**: Real-time chord detection in landscape mode.'),
      );
    });

    test('extracts multi-line bullet list Changelog trailer', () {
      final commit = GitCommitData(
        hash: '2222222222222222',
        shortHash: '2222222',
        subject: 'fix(audio): resolve sustain and polyphony playback issues',
        author: 'Rody Davis',
        body: '''
Changelog:
- Switch to MIDI engine and support dynamic sustain.
- Spacebar now toggles sustain on desktop and web.
''',
      );

      final entries = ChangelogParser.extractPublicEntries(commit);
      expect(entries.length, equals(2));
      expect(entries[0].category, equals('Fixed'));
      expect(entries[0].scope, equals('audio'));
      expect(
        entries[0].description,
        equals('Switch to MIDI engine and support dynamic sustain.'),
      );
      expect(
        entries[1].description,
        equals('Spacebar now toggles sustain on desktop and web.'),
      );
    });

    test('extracts fenced ```release-note and ```release-notes blocks', () {
      final commit = GitCommitData(
        hash: '3535353535353535',
        shortHash: '3535353',
        subject: 'feat(keyboard): physical keyboard mapping',
        author: 'Rody Davis',
        body: '''
Added keyboard shortcuts for octaves and velocity.

```release-note
- Play piano notes directly from a computer keyboard.
- Adjust velocity and octave range with shortcut keys.
```
''',
      );

      final entries = ChangelogParser.extractPublicEntries(commit);
      expect(entries.length, equals(2));
      expect(entries[0].category, equals('Added'));
      expect(entries[0].scope, equals('keyboard'));
      expect(
        entries[0].description,
        equals('Play piano notes directly from a computer keyboard.'),
      );
      expect(
        entries[1].description,
        equals('Adjust velocity and octave range with shortcut keys.'),
      );
    });

    test('respects explicit Release-Notes: none / NONE suppression', () {
      final suppressedTrailer = GitCommitData(
        hash: '3636363636363636',
        shortHash: '3636363',
        subject: 'feat(internal): internal debug telemetry hook',
        author: 'Rody Davis',
        body: 'Release-Notes: none',
      );
      expect(ChangelogParser.extractPublicEntries(suppressedTrailer), isEmpty);
    });

    test('smart fallback includes feat and fix without trailers', () {
      final feat = GitCommitData(
        hash: '4444444444444444',
        shortHash: '4444444',
        subject: 'feat(piano): add sustain toggle',
        author: 'Rody Davis',
        body: '',
      );

      final fix = GitCommitData(
        hash: '5555555555555555',
        shortHash: '5555555',
        subject: 'fix(player): fix piano playback speed',
        author: 'Rody Davis',
        body: '',
      );

      final featEntries = ChangelogParser.extractPublicEntries(feat);
      expect(featEntries.length, equals(1));
      expect(featEntries.first.category, equals('Added'));
      expect(featEntries.first.scope, equals('piano'));
      expect(
        featEntries.first.description,
        equals('Add sustain toggle'),
      );

      final fixEntries = ChangelogParser.extractPublicEntries(fix);
      expect(fixEntries.length, equals(1));
      expect(fixEntries.first.category, equals('Fixed'));
      expect(fixEntries.first.scope, equals('player'));
      expect(
        fixEntries.first.description,
        equals('Fix piano playback speed'),
      );
    });

    test(
      'updateChangelogFile replaces placeholder and merges same-day builds',
      () {
        final tempDir = Directory.systemTemp.createTempSync(
          'piano_changelog_test_',
        );
        final changelogFile = File('${tempDir.path}/changelog.md');

        changelogFile.writeAsStringSync('''## 2026.10.23

- Automated release updates.

## 2.0.0

- Update UI to match related apps
''');

        final build1Entries = [
          PublicChangelogEntry(
            category: 'Added',
            description: 'Add chord detector for keys pressed in landscape.',
            scope: 'piano',
          ),
        ];

        ChangelogParser.updateChangelogFile(
          file: changelogFile,
          semver: '2026.10.23',
          entries: build1Entries,
        );

        var result = changelogFile.readAsStringSync();
        expect(result, isNot(contains('Automated release updates.')));
        expect(
          result,
          contains(
            '- **piano**: Add chord detector for keys pressed in landscape.',
          ),
        );
        expect(result, contains('## 2.0.0'));

        final build2Entries = [
          PublicChangelogEntry(
            category: 'Fixed',
            description: 'Fix piano playback speed.',
            scope: 'audio',
          ),
        ];

        ChangelogParser.updateChangelogFile(
          file: changelogFile,
          semver: '2026.10.23',
          entries: build2Entries,
        );

        result = changelogFile.readAsStringSync();
        expect(
          result,
          contains('- **audio**: Fix piano playback speed.'),
        );
        expect(
          result,
          contains(
            '- **piano**: Add chord detector for keys pressed in landscape.',
          ),
        );

        tempDir.deleteSync(recursive: true);
      },
    );
  });
}
