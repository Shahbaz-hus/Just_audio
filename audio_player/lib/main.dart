import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer player;
  TextEditingController audioSeconds = TextEditingController();
  int duration = 0;

  String dropdownValue = 'Auto';

  bool _flag = true;

  late Animation<double> _myAnimation;
  late AnimationController _controller;

  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    audioSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Select mode: '),
                  const SizedBox(
                    width: 40,
                  ),
                  DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    items: <String>['Auto', 'Manual']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              (dropdownValue == "Manual")
                  ? Column(
                      children: [
                        Text(
                          'Current audio duration: $duration seconds',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter audio playing time',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: TextFormField(
                                controller: audioSeconds,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    duration = int.parse(audioSeconds.text);
                                  });
                                },
                                child: const Text('Set'))
                          ],
                        ),
                      ],
                    )
                  : const Text(
                      'Auto mode selected',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              const SizedBox(
                height: 20,
              ),
              const Text('Audio files...'),
              const SizedBox(
                height: 4,
              ),
              AudioFilesCard(
                // onCardTapped: (bool isPlayingValueCalledBack) {
                //   isPlaying = isPlayingValueCalledBack;
                //   print(isPlaying);
                //   if (isPlaying) {
                //     _controller.reverse();
                //   } else {
                //     player.play();
                //     _controller.forward();
                //   }
                // },
                player: player,
                fileName: 'whiteNoise',
                audioDuration: duration,
                selectedMode: dropdownValue,
              ),
              AudioFilesCard(
                // onCardTapped: (bool isPlayingValueCalledBack) {
                //   isPlaying = isPlayingValueCalledBack;
                //   print(isPlaying);
                //   if (isPlaying) {
                //     _controller.reverse();
                //   } else {
                //     player.play();
                //     player.playing;
                //     _controller.forward();
                //   }
                // },
                player: player,
                fileName: 'CantinaBand3',
                audioDuration: duration,
                selectedMode: dropdownValue,
              ),
              const SizedBox(
                height: 20,
              ),

              Text(player.duration.toString()),

              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (player.playing) {
                    player.pause();

                    setState(() {
                      isPlaying = false;
                    });
                    // _controller.reverse();
                  } else {
                    player.play();
                    setState(() {
                      isPlaying = true;
                    });
                    // _controller.forward();
                  }
                  isPlaying = !isPlaying;
                },
                child: (player.playing)
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                // child: AnimatedIcon(
                //   progress: _myAnimation,
                //   icon: AnimatedIcons.play_pause,
                //   size: 60,
                // )
              )
              //StopButton(player: player)
            ],
          ),
        ),
      ),
    );
  }
}

typedef isPlayingBoolCallBack = void Function(bool isPlayingCallBack);

class AudioFilesCard extends StatefulWidget {
  AudioFilesCard({
    Key? key,
    required this.player,
    required this.fileName,
    required this.audioDuration,
    required this.selectedMode,
    //required this.onCardTapped,
  }) : super(key: key);

  //final isPlayingBoolCallBack onCardTapped;

  final AudioPlayer player;
  final String fileName;
  final int audioDuration;
  final String selectedMode;

  @override
  State<AudioFilesCard> createState() => _AudioFilesCardState();
}

class _AudioFilesCardState extends State<AudioFilesCard> {
  //bool isPlayingFromCard = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () async {
          final stopwatch = Stopwatch()..start();

          int prevInt = 10;

          var rng = Random();
          while (prevInt != 6) {
            prevInt = rng.nextInt(10);
            print(prevInt);
          }
          stopwatch.stop();

          print(
              'Value reached from 10 to 6 in ${stopwatch.elapsed.inMilliseconds} ms');

          stopwatch.reset();

          // setState(() {
          //   isPlayingFromCard = !isPlayingFromCard;
          //   widget.onCardTapped(isPlayingFromCard);
          // });

          if (widget.selectedMode == "Manual") {
            await widget.player
                .setAsset('assets/audio_clips/${widget.fileName}.wav');
            await widget.player.setLoopMode(LoopMode.one);

            widget.player.play();

            await Future.delayed(
                Duration(seconds: widget.audioDuration), () {});
            widget.player.stop();
          } else if (widget.selectedMode == "Auto") {
            autoModePlayAudio(int duration) async {
              widget.player.play();

              await Future.delayed(Duration(seconds: duration), () {});
            }

            autoModePauseAudio(int duration) async {
              widget.player.pause();

              await Future.delayed(Duration(seconds: duration), () {});
            }

            await widget.player
                .setAsset('assets/audio_clips/${widget.fileName}.wav');
            await widget.player.setLoopMode(LoopMode.one);

            await autoModePlayAudio(20);
            await autoModePauseAudio(10);

            await autoModePlayAudio(20);
            await autoModePauseAudio(10);

            await autoModePlayAudio(20);
            widget.player.stop();
          }
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.fileName,
                style: const TextStyle(
                    color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
