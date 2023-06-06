import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? choice;
  FlutterMidi flutterMidi = FlutterMidi();

  @override
  void initState() {
    load('assets/drum.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(
        sf2: _byte, name: 'assets/$choice.sf2'.replaceAll('assets/', ''));
  }

  Uri? link;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.call),
          onPressed: () {
            link = Uri.parse('tel:059');
            launchUrl(link!);
          },
        ),
        title: Center(child: Text('PIANO')),
        actions: [
          DropdownButton(
              value: choice ?? 'drum',
              items: const [
                DropdownMenuItem(
                  child: Text(
                    'Drum',
                  ),
                  value: 'drum',
                ),
                DropdownMenuItem(
                  child: Text(
                    'Yamaha',
                  ),
                  value: 'yamaha',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
                load('assets/$choice.sf2');
              })
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          onNotePositionTapped: (position) {
            flutterMidi.playMidiNote(midi: position.pitch);
            // Use an audio library like flutter_midi to play the sound
          },
        ),
      ),
    );
  }
}
