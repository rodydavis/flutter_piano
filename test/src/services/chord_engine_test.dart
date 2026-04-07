import 'package:flutter_piano/src/services/chord_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('identifyChord', () {
    test('returns empty string for empty list', () {
      expect(identifyChord([]), '');
    });

    test('identifies single notes', () {
      expect(identifyChord([const MidiNote(60)]), 'C'); // Middle C
      expect(identifyChord([const MidiNote(61)]), 'C#');
      expect(identifyChord([const MidiNote(72)]), 'C'); // C5
    });

    test('identifies major triads', () {
      // C Major (C, E, G)
      expect(identifyChord([const MidiNote(60), const MidiNote(64), const MidiNote(67)]), 'C Major');
      // G Major (G, B, D)
      expect(identifyChord([const MidiNote(67), const MidiNote(71), const MidiNote(74)]), 'G Major');
    });

    test('identifies minor triads', () {
      // C Minor (C, Eb, G)
      expect(identifyChord([const MidiNote(60), const MidiNote(63), const MidiNote(67)]), 'C Minor');
      // A Minor (A, C, E)
      expect(identifyChord([const MidiNote(57), const MidiNote(60), const MidiNote(64)]), 'A Minor');
    });

    test('identifies diminished and augmented triads', () {
      // C Diminished (C, Eb, Gb)
      expect(identifyChord([const MidiNote(60), const MidiNote(63), const MidiNote(66)]), 'C Diminished');
      // C Augmented (C, E, G#)
      expect(identifyChord([const MidiNote(60), const MidiNote(64), const MidiNote(68)]), 'C Augmented');
    });

    test('identifies 7th chords', () {
      // C Maj7 (C, E, G, B)
      expect(identifyChord([const MidiNote(60), const MidiNote(64), const MidiNote(67), const MidiNote(71)]), 'C Maj 7');
      // C Dom7 (C, E, G, Bb)
      expect(identifyChord([const MidiNote(60), const MidiNote(64), const MidiNote(67), const MidiNote(70)]), 'C Dom 7');
      // C Min7 (C, Eb, G, Bb)
      expect(identifyChord([const MidiNote(60), const MidiNote(63), const MidiNote(67), const MidiNote(70)]), 'C Min 7');
    });

    test('identifies inversions (slash chords)', () {
      // C Major first inversion (E, G, C) -> C Major / E
      expect(identifyChord([const MidiNote(64), const MidiNote(67), const MidiNote(72)]), 'C Major / E');
      // C Major second inversion (G, C, E) -> C Major / G
      expect(identifyChord([const MidiNote(67), const MidiNote(72), const MidiNote(76)]), 'C Major / G');
    });

    test('identifies power chords', () {
      // C5 (C, G)
      expect(identifyChord([const MidiNote(60), const MidiNote(67)]), 'C 5');
    });

    test('identifies sus chords', () {
      // Csus2 (C, D, G)
      expect(identifyChord([const MidiNote(60), const MidiNote(62), const MidiNote(67)]), 'C sus2');
      // Csus4 (C, F, G)
      expect(identifyChord([const MidiNote(60), const MidiNote(65), const MidiNote(67)]), 'C sus4');
    });

    test('handles multiple octaves and duplicate notes', () {
      // C Major with extra C and E
      expect(identifyChord([
        const MidiNote(60), // C4
        const MidiNote(64), // E4
        const MidiNote(67), // G4
        const MidiNote(72), // C5
        const MidiNote(76), // E5
      ]), 'C Major');
    });

    test('identifies rootless 7th chords', () {
      // C dom7 rootless (E, Bb) played as (E, Bb, C) -> wait, the dictionary has [0, 4, 10]
      // That means C, E, Bb.
      expect(identifyChord([const MidiNote(60), const MidiNote(64), const MidiNote(70)]), 'C Dom 7');
    });

    test('falls back to note symbols for unknown chords', () {
      // Random cluster that isn't a common chord
      final result = identifyChord([const MidiNote(60), const MidiNote(61), const MidiNote(62)]);
      expect(result, contains('C-C#-D'));
    });
  });
}
