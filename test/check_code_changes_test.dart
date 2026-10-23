import 'package:test/test.dart';
import '../scripts/check_code_changes.dart';

void main() {
  group('CodeChangeEvaluator Unit Tests', () {
    test('identifies release bump commits correctly', () {
      expect(
        CodeChangeEvaluator.isReleaseBumpCommit(
          'chore(release): bump version to v2026.10.23+503',
        ),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isReleaseBumpCommit('chore: release v2026.10.23'),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isReleaseBumpCommit('Bump version to 2.0.1+502'),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isReleaseBumpCommit('chore: bump version'),
        isTrue,
      );

      expect(
        CodeChangeEvaluator.isReleaseBumpCommit(
          'feat: add sustain pedal support',
        ),
        isFalse,
      );
      expect(
        CodeChangeEvaluator.isReleaseBumpCommit(
          'fix(player): resolve audio playback latency',
        ),
        isFalse,
      );
    });

    test('identifies version-only metadata files correctly', () {
      expect(
        CodeChangeEvaluator.isVersionOnlyFile('pubspec.yaml'),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isVersionOnlyFile('lib/src/version.dart'),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isVersionOnlyFile('content/changelog.md'),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isVersionOnlyFile('CHANGELOG.md'),
        isTrue,
      );
      expect(
        CodeChangeEvaluator.isVersionOnlyFile('pubspec.lock'),
        isTrue,
      );

      expect(
        CodeChangeEvaluator.isVersionOnlyFile('lib/src/services/player.dart'),
        isFalse,
      );
      expect(
        CodeChangeEvaluator.isVersionOnlyFile('lib/ui/screens/home.dart'),
        isFalse,
      );
    });

    test(
      'evaluateFromData detects code changes when functional commits and files exist',
      () {
        final res = CodeChangeEvaluator.evaluateFromData(
          logLines: [
            'c4e317c feat(ci): add scheduled releases',
            '6285521 chore(release): bump version to v2026.10.23+503',
          ],
          fileLines: [
            '.gitea/workflows/release-mobile.yml',
            'pubspec.yaml',
          ],
        );

        expect(res.hasCodeChanges, isTrue);
        expect(res.meaningfulCommits.length, equals(1));
        expect(res.meaningfulCommits.first, contains('feat(ci)'));
        expect(res.changedCodeFiles.length, equals(1));
        expect(
          res.changedCodeFiles.first,
          equals('.gitea/workflows/release-mobile.yml'),
        );
      },
    );

    test(
      'evaluateFromData ignores purely version bump commits and metadata files',
      () {
        final res = CodeChangeEvaluator.evaluateFromData(
          logLines: [
            '6285521 chore(release): bump version to v2026.10.23+503',
            '894a6e1 chore: bump version',
          ],
          fileLines: [
            'pubspec.yaml',
            'lib/src/version.dart',
            'content/changelog.md',
            'CHANGELOG.md',
          ],
        );

        expect(res.hasCodeChanges, isFalse);
        expect(res.meaningfulCommits, isEmpty);
        expect(res.changedCodeFiles, isEmpty);
      },
    );

    test(
      'evaluate() handles missing or invalid refs gracefully without crashing',
      () {
        final res = CodeChangeEvaluator.evaluate(
          fromRef: 'non_existent_ref_12345',
          toRef: 'HEAD',
        );

        expect(res.hasCodeChanges, isFalse);
      },
    );
  });
}
