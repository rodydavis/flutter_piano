import 'package:audioplayers/audioplayers.dart';

final sustainMidi = <int, String>{
  21: 'sounds/sustain/-1_A.mp3',
  22: 'sounds/sustain/-1_Ab.mp3',
  23: 'sounds/sustain/-1_B.mp3',
  24: 'sounds/sustain/0_C.mp3',
  25: 'sounds/sustain/0_Cb.mp3',
  26: 'sounds/sustain/0_D.mp3',
  27: 'sounds/sustain/0_Db.mp3',
  28: 'sounds/sustain/0_E.mp3',
  29: 'sounds/sustain/0_F.mp3',
  30: 'sounds/sustain/0_Fb.mp3',
  31: 'sounds/sustain/0_G.mp3',
  32: 'sounds/sustain/0_Gb.mp3',
  33: 'sounds/sustain/0_A.mp3',
  34: 'sounds/sustain/0_Ab.mp3',
  35: 'sounds/sustain/0_B.mp3',
  36: 'sounds/sustain/1_C.mp3',
  37: 'sounds/sustain/1_Cb.mp3',
  38: 'sounds/sustain/1_D.mp3',
  39: 'sounds/sustain/1_Db.mp3',
  40: 'sounds/sustain/1_E.mp3',
  41: 'sounds/sustain/1_F.mp3',
  42: 'sounds/sustain/1_Fb.mp3',
  43: 'sounds/sustain/1_G.mp3',
  44: 'sounds/sustain/1_Gb.mp3',
  45: 'sounds/sustain/1_A.mp3',
  46: 'sounds/sustain/1_Ab.mp3',
  47: 'sounds/sustain/1_B.mp3',
  48: 'sounds/sustain/2_C.mp3',
  49: 'sounds/sustain/2_Cb.mp3',
  50: 'sounds/sustain/2_D.mp3',
  51: 'sounds/sustain/2_Db.mp3',
  52: 'sounds/sustain/2_E.mp3',
  53: 'sounds/sustain/2_F.mp3',
  54: 'sounds/sustain/2_Fb.mp3',
  55: 'sounds/sustain/2_G.mp3',
  56: 'sounds/sustain/2_Gb.mp3',
  57: 'sounds/sustain/2_A.mp3',
  58: 'sounds/sustain/2_Ab.mp3',
  59: 'sounds/sustain/2_B.mp3',
  60: 'sounds/sustain/3_C.mp3',
  61: 'sounds/sustain/3_Cb.mp3',
  62: 'sounds/sustain/3_D.mp3',
  63: 'sounds/sustain/3_Db.mp3',
  64: 'sounds/sustain/3_E.mp3',
  65: 'sounds/sustain/3_F.mp3',
  66: 'sounds/sustain/3_Fb.mp3',
  67: 'sounds/sustain/3_G.mp3',
  68: 'sounds/sustain/3_Gb.mp3',
  69: 'sounds/sustain/3_A.mp3',
  70: 'sounds/sustain/3_Ab.mp3',
  71: 'sounds/sustain/3_B.mp3',
  72: 'sounds/sustain/4_C.mp3',
  73: 'sounds/sustain/4_Cb.mp3',
  74: 'sounds/sustain/4_D.mp3',
  75: 'sounds/sustain/4_Db.mp3',
  76: 'sounds/sustain/4_E.mp3',
  77: 'sounds/sustain/4_F.mp3',
  78: 'sounds/sustain/4_Fb.mp3',
  79: 'sounds/sustain/4_G.mp3',
  80: 'sounds/sustain/4_Gb.mp3',
  81: 'sounds/sustain/4_A.mp3',
  82: 'sounds/sustain/4_Ab.mp3',
  83: 'sounds/sustain/4_B.mp3',
  84: 'sounds/sustain/5_C.mp3',
  85: 'sounds/sustain/5_Cb.mp3',
  86: 'sounds/sustain/5_D.mp3',
  87: 'sounds/sustain/5_Db.mp3',
  88: 'sounds/sustain/5_E.mp3',
  89: 'sounds/sustain/5_F.mp3',
  90: 'sounds/sustain/5_Fb.mp3',
  91: 'sounds/sustain/5_G.mp3',
  92: 'sounds/sustain/5_Gb.mp3',
  93: 'sounds/sustain/5_A.mp3',
  94: 'sounds/sustain/5_Ab.mp3',
  95: 'sounds/sustain/5_B.mp3',
  96: 'sounds/sustain/6_C.mp3',
  97: 'sounds/sustain/6_Cb.mp3',
  98: 'sounds/sustain/6_D.mp3',
  99: 'sounds/sustain/6_Db.mp3',
  100: 'sounds/sustain/6_E.mp3',
  101: 'sounds/sustain/6_F.mp3',
  102: 'sounds/sustain/6_Fb.mp3',
  103: 'sounds/sustain/6_G.mp3',
  104: 'sounds/sustain/6_Gb.mp3',
  105: 'sounds/sustain/6_A.mp3',
  106: 'sounds/sustain/6_Ab.mp3',
  107: 'sounds/sustain/6_B.mp3',
  108: 'sounds/sustain/7_C.mp3',
};

final shotMidi = <int, String>{
  21: 'sounds/shot/-1_A.mp3',
  22: 'sounds/shot/-1_Ab.mp3',
  23: 'sounds/shot/-1_B.mp3',
  24: 'sounds/shot/0_C.mp3',
  25: 'sounds/shot/0_Cb.mp3',
  26: 'sounds/shot/0_D.mp3',
  27: 'sounds/shot/0_Db.mp3',
  28: 'sounds/shot/0_E.mp3',
  29: 'sounds/shot/0_F.mp3',
  30: 'sounds/shot/0_Fb.mp3',
  31: 'sounds/shot/0_G.mp3',
  32: 'sounds/shot/0_Gb.mp3',
  33: 'sounds/shot/0_A.mp3',
  34: 'sounds/shot/0_Ab.mp3',
  35: 'sounds/shot/0_B.mp3',
  36: 'sounds/shot/1_C.mp3',
  37: 'sounds/shot/1_Cb.mp3',
  38: 'sounds/shot/1_D.mp3',
  39: 'sounds/shot/1_Db.mp3',
  40: 'sounds/shot/1_E.mp3',
  41: 'sounds/shot/1_F.mp3',
  42: 'sounds/shot/1_Fb.mp3',
  43: 'sounds/shot/1_G.mp3',
  44: 'sounds/shot/1_Gb.mp3',
  45: 'sounds/shot/1_A.mp3',
  46: 'sounds/shot/1_Ab.mp3',
  47: 'sounds/shot/1_B.mp3',
  48: 'sounds/shot/2_C.mp3',
  49: 'sounds/shot/2_Cb.mp3',
  50: 'sounds/shot/2_D.mp3',
  51: 'sounds/shot/2_Db.mp3',
  52: 'sounds/shot/2_E.mp3',
  53: 'sounds/shot/2_F.mp3',
  54: 'sounds/shot/2_Fb.mp3',
  55: 'sounds/shot/2_G.mp3',
  56: 'sounds/shot/2_Gb.mp3',
  57: 'sounds/shot/2_A.mp3',
  58: 'sounds/shot/2_Ab.mp3',
  59: 'sounds/shot/2_B.mp3',
  60: 'sounds/shot/3_C.mp3',
  61: 'sounds/shot/3_Cb.mp3',
  62: 'sounds/shot/3_D.mp3',
  63: 'sounds/shot/3_Db.mp3',
  64: 'sounds/shot/3_E.mp3',
  65: 'sounds/shot/3_F.mp3',
  66: 'sounds/shot/3_Fb.mp3',
  67: 'sounds/shot/3_G.mp3',
  68: 'sounds/shot/3_Gb.mp3',
  69: 'sounds/shot/3_A.mp3',
  70: 'sounds/shot/3_Ab.mp3',
  71: 'sounds/shot/3_B.mp3',
  72: 'sounds/shot/4_C.mp3',
  73: 'sounds/shot/4_Cb.mp3',
  74: 'sounds/shot/4_D.mp3',
  75: 'sounds/shot/4_Db.mp3',
  76: 'sounds/shot/4_E.mp3',
  77: 'sounds/shot/4_F.mp3',
  78: 'sounds/shot/4_Fb.mp3',
  79: 'sounds/shot/4_G.mp3',
  80: 'sounds/shot/4_Gb.mp3',
  81: 'sounds/shot/4_A.mp3',
  82: 'sounds/shot/4_Ab.mp3',
  83: 'sounds/shot/4_B.mp3',
  84: 'sounds/shot/5_C.mp3',
  85: 'sounds/shot/5_Cb.mp3',
  86: 'sounds/shot/5_D.mp3',
  87: 'sounds/shot/5_Db.mp3',
  88: 'sounds/shot/5_E.mp3',
  89: 'sounds/shot/5_F.mp3',
  90: 'sounds/shot/5_Fb.mp3',
  91: 'sounds/shot/5_G.mp3',
  92: 'sounds/shot/5_Gb.mp3',
  93: 'sounds/shot/5_A.mp3',
  94: 'sounds/shot/5_Ab.mp3',
  95: 'sounds/shot/5_B.mp3',
  96: 'sounds/shot/6_C.mp3',
  97: 'sounds/shot/6_Cb.mp3',
  98: 'sounds/shot/6_D.mp3',
  99: 'sounds/shot/6_Db.mp3',
  100: 'sounds/shot/6_E.mp3',
  101: 'sounds/shot/6_F.mp3',
  102: 'sounds/shot/6_Fb.mp3',
  103: 'sounds/shot/6_G.mp3',
  104: 'sounds/shot/6_Gb.mp3',
  105: 'sounds/shot/6_A.mp3',
  106: 'sounds/shot/6_Ab.mp3',
  107: 'sounds/shot/6_B.mp3',
  108: 'sounds/shot/7_C.mp3',
};

class $Player {
  final players = <(int, bool), List<AudioPlayer>>{};

  Future<void> stopSustain() async {
    for (final group in players.values) {
      for (final player in group) {
        await player.stop();
      }
    }
  }

  Future<AudioPlayer?> load(
    int midi, {
    bool sustain = false,
  }) async {
    final key = (midi, sustain);
    final file = sustain ? sustainMidi[midi] : shotMidi[midi];
    if (file == null) return null;
    final player = AudioPlayer();
    await player.setSource(AssetSource(file));
    players[key] ??= [];
    final current = players[key]!.toList();
    current.add(player);
    players[key] = current;
    player.onPlayerStateChanged.listen((state) {
      if (state != PlayerState.playing) {
        final current = players[key]!.toList();
        current.remove(player);
        players[key] = current;
      }
    });
    return player;
  }

  Future<void> play(
    int midi, {
    bool sustain = false,
  }) async {
    final player = await load(midi, sustain: sustain);
    if (player == null) return;
    if (player.state == PlayerState.playing) {
      await player.seek(Duration.zero);
    }
    await player.resume();
  }

  Future<void> stop(
    int midi, {
    bool sustain = false,
  }) async {
    final player = await load(midi, sustain: sustain);
    if (player == null) return;
    await player.stop();
    await player.seek(Duration.zero);
  }
}
