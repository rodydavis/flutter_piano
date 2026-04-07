// ignore_for_file: constant_identifier_names

/// Represents the 12 fundamental musical notes.
enum Note {
  C('C'),
  CSharp('C#'),
  D('D'),
  DSharp('D#'),
  E('E'),
  F('F'),
  FSharp('F#'),
  G('G'),
  GSharp('G#'),
  A('A'),
  ASharp('A#'),
  B('B');

  final String symbol;
  const Note(this.symbol);
}

/// Supported chord qualities.
enum ChordType {
  major('Major'),
  minor('Minor'),
  dim('Diminished'),
  aug('Augmented'),
  sus2('sus2'),
  sus4('sus4'),
  maj6('Maj 6'),
  min6('Min 6'),
  dom7('Dom 7'),
  maj7('Maj 7'),
  min7('Min 7'),
  dim7('Dim 7'),
  halfDim7('Half-Dim 7'),
  minMaj7('Min-Maj 7'),
  dom7b5('Dom 7b5'),
  dom7S5('Dom 7#5'),
  maj7b5('Maj 7b5'),
  maj7S5('Maj 7#5'),
  add9('add9'),
  minAdd9('Min add9'),
  add11('add11'),
  minAdd11('Min add11'),
  dom9('Dom 9'),
  maj9('Maj 9'),
  min9('Min 9'),
  dom7b9('Dom 7b9'),
  dom7S9('Dom 7#9'),
  min9b5('Half-Dim 9'),
  dom11('Dom 11'),
  maj11('Maj 11'),
  min11('Min 11'),
  dom13('Dom 13'),
  maj13('Maj 13'),
  min13('Min 13'),
  dom7b13('Dom 7b13'),
  sus4_7('7sus4'),
  sus4_9('9sus4'),
  sixNine('6/9'),
  minSixNine('Min 6/9'),
  power('5');

  final String label;
  const ChordType(this.label);
}

/// Wraps a raw integer (0-127) representing a MIDI note.
extension type const MidiNote(int value) {
  PitchClass get pitchClass => PitchClass(value % 12);
}

/// Wraps a normalized integer (0-11) representing a pitch class.
extension type const PitchClass(int value) {
  Note get note => Note.values[value];

  /// Calculates the interval (in semitones) to another pitch class.
  int intervalTo(PitchClass other) => (other.value - value + 12) % 12;
}

/// A strongly-typed wrapper for interval patterns to use as Map keys.
extension type const ChordPattern(String value) {
  /// Takes a list of intervals, sorts them, and formats them as a comparable string.
  factory ChordPattern.fromIntervals(List<int> intervals) {
    final sorted = List<int>.from(intervals)..sort();
    return ChordPattern(sorted.toString());
  }
}

/// The definition dictionary for supported chords based on intervals from the root.
final Map<ChordPattern, ChordType> chordDictionary = {
  // Triads
  ChordPattern('[0, 4, 7]'): ChordType.major,
  ChordPattern('[0, 3, 7]'): ChordType.minor,
  ChordPattern('[0, 3, 6]'): ChordType.dim,
  ChordPattern('[0, 4, 8]'): ChordType.aug,
  ChordPattern('[0, 2, 7]'): ChordType.sus2,
  ChordPattern('[0, 5, 7]'): ChordType.sus4,
  ChordPattern('[0, 7]'): ChordType.power,

  // 6th Chords
  ChordPattern('[0, 4, 7, 9]'): ChordType.maj6,
  ChordPattern('[0, 3, 7, 9]'): ChordType.min6,

  // 7th Chords
  ChordPattern('[0, 4, 7, 10]'): ChordType.dom7,
  ChordPattern('[0, 4, 7, 11]'): ChordType.maj7,
  ChordPattern('[0, 3, 7, 10]'): ChordType.min7,
  ChordPattern('[0, 3, 6, 9]'): ChordType.dim7,
  ChordPattern('[0, 3, 6, 10]'): ChordType.halfDim7,
  ChordPattern('[0, 3, 7, 11]'): ChordType.minMaj7,
  ChordPattern('[0, 4, 6, 10]'): ChordType.dom7b5,
  ChordPattern('[0, 4, 8, 10]'): ChordType.dom7S5,
  ChordPattern('[0, 4, 6, 11]'): ChordType.maj7b5,
  ChordPattern('[0, 4, 8, 11]'): ChordType.maj7S5,

  // 7th Rootless (No 5th)
  ChordPattern('[0, 4, 10]'): ChordType.dom7,
  ChordPattern('[0, 4, 11]'): ChordType.maj7,
  ChordPattern('[0, 3, 10]'): ChordType.min7,

  // Sus variants
  ChordPattern('[0, 5, 7, 10]'): ChordType.sus4_7,
  ChordPattern('[0, 2, 5, 7, 10]'): ChordType.sus4_9,

  // Added Notes
  ChordPattern('[0, 2, 4, 7]'): ChordType.add9,
  ChordPattern('[0, 2, 3, 7]'): ChordType.minAdd9,
  ChordPattern('[0, 4, 5, 7]'): ChordType.add11,
  ChordPattern('[0, 3, 5, 7]'): ChordType.minAdd11,

  // 9th Chords
  ChordPattern('[0, 2, 4, 7, 10]'): ChordType.dom9,
  ChordPattern('[0, 2, 4, 7, 11]'): ChordType.maj9,
  ChordPattern('[0, 2, 3, 7, 10]'): ChordType.min9,
  ChordPattern('[0, 1, 4, 7, 10]'): ChordType.dom7b9,
  ChordPattern('[0, 3, 4, 7, 10]'): ChordType.dom7S9,
  ChordPattern('[0, 2, 3, 6, 10]'): ChordType.min9b5,

  // 9th Rootless (No 5th)
  ChordPattern('[0, 2, 4, 10]'): ChordType.dom9,
  ChordPattern('[0, 2, 4, 11]'): ChordType.maj9,
  ChordPattern('[0, 2, 3, 10]'): ChordType.min9,
  ChordPattern('[0, 1, 4, 10]'): ChordType.dom7b9,
  ChordPattern('[0, 3, 4, 10]'): ChordType.dom7S9,

  // 11th Chords
  ChordPattern('[0, 2, 4, 5, 7, 10]'): ChordType.dom11,
  ChordPattern('[0, 2, 4, 5, 7, 11]'): ChordType.maj11,
  ChordPattern('[0, 2, 3, 5, 7, 10]'): ChordType.min11,

  // 13th Chords
  ChordPattern('[0, 2, 4, 5, 7, 9, 10]'): ChordType.dom13,
  ChordPattern('[0, 2, 4, 5, 7, 9, 11]'): ChordType.maj13,
  ChordPattern('[0, 2, 3, 5, 7, 9, 10]'): ChordType.min13,
  ChordPattern('[0, 4, 7, 8, 10]'): ChordType.dom7b13,

  // 13th Rootless (root, 3, 7, 13)
  ChordPattern('[0, 4, 9, 10]'): ChordType.dom13,
  ChordPattern('[0, 4, 9, 11]'): ChordType.maj13,
  ChordPattern('[0, 3, 9, 10]'): ChordType.min13,

  // 6/9 Chords
  ChordPattern('[0, 2, 4, 7, 9]'): ChordType.sixNine,
  ChordPattern('[0, 2, 3, 7, 9]'): ChordType.minSixNine,
};

/// Evaluates a list of active MIDI notes and returns the recognized chord string.
String identifyChord(List<MidiNote> activeNotes) {
  if (activeNotes.isEmpty) return '';

  // 1. Get unique pitch classes (deduplicate octaves)
  final uniquePitchClasses = activeNotes
      .map((n) => n.pitchClass.value)
      .toSet()
      .map((v) => PitchClass(v))
      .toList();

  // Single note played
  if (uniquePitchClasses.length == 1) {
    return uniquePitchClasses.first.note.symbol;
  }

  // 2. Identify bass note for slash chords / inversions
  final lowestNote = activeNotes.reduce((a, b) => a.value < b.value ? a : b);
  final bassPitchClass = lowestNote.pitchClass;

  // 3. Test each pitch class as the potential root
  for (final potentialRoot in uniquePitchClasses) {
    // Calculate intervals relative to this root
    final intervals =
        uniquePitchClasses.map((pc) => potentialRoot.intervalTo(pc)).toList();

    // Create our typed pattern key
    final pattern = ChordPattern.fromIntervals(intervals);

    // 4. Check dictionary for a match
    if (chordDictionary.containsKey(pattern)) {
      final rootSymbol = potentialRoot.note.symbol;
      final typeLabel = chordDictionary[pattern]!.label;

      // Inversion / Slash chord formatting
      if (bassPitchClass.value != potentialRoot.value) {
        return '$rootSymbol $typeLabel / ${bassPitchClass.note.symbol}';
      }

      return '$rootSymbol $typeLabel';
    }
  }

  // If we have multiple notes but no dictionary match
  final sortedActiveNotes = List<MidiNote>.from(activeNotes)
    ..sort((a, b) => a.value.compareTo(b.value));
  final keysPressed = sortedActiveNotes
      .map((n) => n.pitchClass.note.symbol)
      .toSet()
      .join('-');
  return keysPressed;
}
