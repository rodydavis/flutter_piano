import 'dart:async';

import 'package:dart_midi/dart_midi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/blocs/blocs.dart';
import '../../data/blocs/settings/settings.dart';
import '../../data/utils/index.dart';
import '../../generated/i18n.dart';
import '../../plugins/app_review/app_review.dart';
import '../../plugins/midi/midi.dart';
import '../../plugins/vibrate/vibrate.dart';
import '../common/index.dart';
import '../common/piano_view.dart';
import '../settings/screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  MidiFile _midi;
  final _controller = StreamController<List<int>>.broadcast();

  @override
  initState() {
    _loadSoundFont();
    Future.delayed(Duration(minutes: 5)).then((_) {
      if (mounted) ReviewUtils.requestReview();
    });
    super.initState();
  }

  void _loadSoundFont() async {
    MidiUtils.unmute();
    rootBundle.load("assets/sounds/Piano.sf2").then((bytes) {
      MidiUtils.prepare(bytes, "Piano.sf2");
    });
    rootBundle.load('assets/sounds/MIDI_sample.mid').then((bytes) {
      if (mounted)
        setState(() {
          _midi = midiParser(bytes.buffer.asUint8List());
        });
      play();
    });
    VibrateUtils.canVibrate.then((vibrate) {
      if (mounted)
        setState(() {
          canVibrate = vibrate;
        });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State: $state");
    _loadSoundFont();
  }

  Timer _timer;
  int bpm = 120;
  List<int> _currentNotes = [];

  void play() async {
    if (_timer != null) _timer.cancel();
    // _timer = Timer.periodic(Duration(milliseconds: (1000 * 60 / bpm).round()),
    //     (tick) {
    //   final t = tick.tick;
    //   _playMidiAtPosition(t);
    // });
    for (var track in _midi.tracks) {
      for (var i = 0; i < track.length; i++) {
        _playNotesAtTrack(track, i);
        await Future.delayed(Duration(milliseconds: 250));
      }
    }
  }

  void _playMidiAtPosition(int pos) {
    for (var track in _midi.tracks) {
      _playNotesAtTrack(track, pos);
    }
  }

  void _playNotesAtTrack(List<MidiEvent> track, int pos) {
    MidiEvent _event = track[pos];
    if (_event == null) return;
    if (_event is NoteOnEvent) {
      final _note = _event.noteNumber;
      // print('Node On: $_note');
      _currentNotes.add(_note);
      _controller.add(_currentNotes);
    }
    if (_event is NoteOffEvent) {
      final _note = _event.noteNumber;
      // print('Node Off: $_note');
      _currentNotes.remove(_note);
      _controller.add(_currentNotes);
    }
  }

  bool canVibrate = false;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => Scaffold(
        drawer: _buildDrawer(context, state),
        appBar: AppBar(
          title: Text(
            I18n.of(context).title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30.0,
            ),
          ),
          actions: <Widget>[
            DarkModeToggle(),
          ],
        ),
        body: state is SettingsReady
            ? Container(
                color: state.settings.darkMode ? null : Colors.grey[300],
                child: _buildKeys(context, state.settings),
              )
            : Container(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, SettingsState state) {
    return Drawer(
        child: SafeArea(
      child: ListView(children: <Widget>[
        Container(height: 20.0),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
        if (state is SettingsReady) ...[
          ListTile(title: Text("Change Width")),
          Slider(
              activeColor: Colors.redAccent,
              inactiveColor: Colors.white,
              min: 0.0,
              max: 1.0,
              value: state.settings.widthRatio,
              onChanged: (double value) =>
                  BlocProvider.of<SettingsBloc>(context).dispatch(
                      ChangeSettings(state.settings..widthRatio = value))),
          ListTile(
              title: Text("Show Labels"),
              trailing: Switch(
                  value: state.settings.showLabels,
                  onChanged: (bool value) =>
                      BlocProvider.of<SettingsBloc>(context).dispatch(
                          ChangeSettings(state.settings..showLabels = value)))),
          Container(
            child: state.settings.showLabels
                ? ListTile(
                    title: Text("Only For Octaves"),
                    trailing: Switch(
                        value: state.settings.labelsOnlyOctaves,
                        onChanged: (bool value) =>
                            BlocProvider.of<SettingsBloc>(context).dispatch(
                                ChangeSettings(state.settings
                                  ..labelsOnlyOctaves = value))))
                : null,
          ),
          ListTile(
              title: Text("Disable Scroll"),
              trailing: Switch(
                  value: state.settings.disableScroll,
                  onChanged: (bool value) =>
                      BlocProvider.of<SettingsBloc>(context).dispatch(
                          ChangeSettings(
                              state.settings..disableScroll = value)))),
          Container(
            child: canVibrate
                ? ListTile(
                    title: Text("Key Feedback"),
                    trailing: Switch(
                      value: state.settings.shouldVibrate,
                      onChanged: (bool value) =>
                          BlocProvider.of<SettingsBloc>(context).dispatch(
                              ChangeSettings(
                                  state.settings..shouldVibrate = value)),
                    ),
                  )
                : null,
          ),
        ],
      ]),
    ));
  }

  Widget _buildKeys(BuildContext context, Settings settings) {
    final _stream = _controller.stream;
    double keyWidth = 40 + (80 * (settings.widthRatio ?? 0.5));
    final _vibrate = settings.shouldVibrate && canVibrate;
    if (MediaQuery.of(context).size.height > 600) {
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: settings.showLabels,
              labelsOnlyOctaves: settings.labelsOnlyOctaves,
              disableScroll: settings.disableScroll,
              feedback: _vibrate,
              listenables: _stream,
            ),
          ),
          Flexible(
            child: PianoView(
              keyWidth: keyWidth,
              showLabels: settings.showLabels,
              labelsOnlyOctaves: settings.labelsOnlyOctaves,
              disableScroll: settings.disableScroll,
              feedback: _vibrate,
              listenables: _stream,
            ),
          ),
        ],
      );
    }
    return PianoView(
      keyWidth: keyWidth,
      showLabels: settings.showLabels,
      labelsOnlyOctaves: settings.labelsOnlyOctaves,
      disableScroll: settings.disableScroll,
      feedback: _vibrate,
      listenables: _stream,
    );
  }
}
