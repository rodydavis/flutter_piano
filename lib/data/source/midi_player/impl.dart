abstract class IMidiPlayer {
  Future<void> play(int note, int velocity);

  Future<void> init();
}
