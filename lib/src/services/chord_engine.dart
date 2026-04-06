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
  dom7('Dom 7'),
  maj7('Maj 7'),
  min7('Min 7'),
  dim7('Dim 7'),
  halfDim7('Half-Dim 7'),
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
  ChordPattern('[0, 4, 7]'): ChordType.major,
  ChordPattern('[0, 3, 7]'): ChordType.minor,
  ChordPattern('[0, 3, 6]'): ChordType.dim,
  ChordPattern('[0, 4, 8]'): ChordType.aug,
  ChordPattern('[0, 2, 7]'): ChordType.sus2,
  ChordPattern('[0, 5, 7]'): ChordType.sus4,
  ChordPattern('[0, 4, 7, 10]'): ChordType.dom7,
  ChordPattern('[0, 4, 7, 11]'): ChordType.maj7,
  ChordPattern('[0, 3, 7, 10]'): ChordType.min7,
  ChordPattern('[0, 3, 6, 9]'): ChordType.dim7,
  ChordPattern('[0, 3, 6, 10]'): ChordType.halfDim7,
  ChordPattern('[0, 7]'): ChordType.power,
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
  return 'Unknown';
}
