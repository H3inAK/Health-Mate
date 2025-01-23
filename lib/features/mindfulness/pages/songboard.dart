// // import 'package:flutter/material.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import '../utils/utils.dart';
// // import '../widgets/circle_play_button.dart';
// // import '../widgets/rectangle_button.dart';

// // class SongBoard extends StatefulWidget {
// //   const SongBoard({
// //     super.key,
// //     required this.musicName,
// //     required this.musicSource,
// //     required this.imageSource,
// //   });

// //   final String musicName;
// //   final String musicSource;
// //   final String imageSource;

// //   @override
// //   State<SongBoard> createState() => _SongBoardState();
// // }

// // class _SongBoardState extends State<SongBoard> {
// //   final player = AudioPlayer();
// //   bool isPlaying = false;
// //   Duration duration = Duration.zero;
// //   Duration position = Duration.zero;
// //   String musicName = '';
// //   String musicSource = '';
// //   String imageSource = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     updateUI(
// //       widget.musicName,
// //       widget.musicSource,
// //       widget.imageSource,
// //     );

// //     setAudio();
// //     // listion to state playing, paused, stop
// //     player.onPlayerStateChanged.listen((event) {
// //       setState(() {
// //         isPlaying = event == PlayerState.playing;
// //       });
// //     });

// //     // Listen to duration position
// //     player.onDurationChanged.listen((newDuration) {
// //       setState(() {
// //         duration = newDuration;
// //       });
// //     });
// //     // listen to audion position
// //     player.onPositionChanged.listen((newPostion) {
// //       setState(() {
// //         position = newPostion;
// //       });
// //     });
// //   }

// //   void updateUI(
// //     String newMusicName,
// //     String newMusicSource,
// //     String newImageSource,
// //   ) {
// //     musicName = newMusicName;
// //     musicSource = newMusicSource;
// //     imageSource = newImageSource;
// //     return;
// //   }

// //   Future setAudio() async {
// //     AssetSource source =
// //         AssetSource('assets/mindfullness_assets/musics/$musicSource');
// //     await player.play(source);
// //     // repeat the music
// //     player.setReleaseMode(ReleaseMode.loop);
// //     player.setSource(source);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(15.0),
// //           child: Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(20),
// //                   child: Image.asset(
// //                     'assets/mindfullness_assets/images/$imageSource',
// //                     width: double.infinity,
// //                     height: 350,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 Text(
// //                   musicName,
// //                   style: kLargeTextStyle,
// //                 ),
// //                 Slider(
// //                   min: 0,
// //                   max: duration.inSeconds.toDouble(),
// //                   value: position.inSeconds.toDouble(),
// //                   activeColor: Colors.deepPurple,
// //                   inactiveColor: Colors.deepPurple[200],
// //                   onChanged: (value) async {
// //                     final position = Duration(seconds: value.toInt());
// //                     await player.seek(position);
// //                     await player.resume();
// //                   },
// //                 ),
// //                 CirclePlayButton(isPlaying: isPlaying, player: player),
// //                 const SizedBox(
// //                   height: 120,
// //                 ),
// //                 RectangleButton(
// //                   onPressed: () async {
// //                     await player.stop();
// //                     Navigator.pop(context);
// //                   },
// //                   child: const Text(
// //                     "GO TO DASHBOARD",
// //                     style: kButtonTextStyle,
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class SongBoard extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final String imageSource;
//   final String musicSource;

//   const SongBoard({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.imageSource,
//     required this.musicSource,
//   }) : super(key: key);

//   @override
//   State<SongBoard> createState() => _SongBoardState();
// }

// class _SongBoardState extends State<SongBoard> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//   Duration _currentPosition = Duration.zero;
//   Duration _totalDuration = Duration.zero;

//   @override
//   void initState() {
//     super.initState();

//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (mounted) {
//         setState(() {
//           _isPlaying = state == PlayerState.playing;
//         });
//       }
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       if (mounted) {
//         setState(() {
//           _currentPosition = position;
//         });
//       }
//     });

//     _audioPlayer.onDurationChanged.listen((duration) {
//       if (mounted) {
//         setState(() {
//           _totalDuration = duration;
//         });
//       }
//     });
//   }

//   void _togglePlayPause() async {
//     AssetSource source =
//         AssetSource('mindfullness_assets/musics/${widget.musicSource}');

//     if (_isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.play(source);
//       await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//       await _audioPlayer.setSource(source);
//       await _audioPlayer.resume();
//     }
//   }

//   void _seekAudio(Duration position) async {
//     await _audioPlayer.seek(position);
//   }

//   @override
//   void dispose() {
//     _audioPlayer.stop();
//     _audioPlayer.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Hero(
//               tag: widget.imageSource,
//               child: Image.asset(
//                 'assets/mindfullness_assets/images/${widget.imageSource}',
//                 height: 200,
//                 width: 200,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               widget.subtitle,
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             IconButton(
//               icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//               iconSize: 64,
//               onPressed: _togglePlayPause,
//             ),
//             Slider(
//               min: 0,
//               max: _totalDuration.inSeconds.toDouble(),
//               value: _currentPosition.inSeconds.toDouble(),
//               onChanged: (value) {
//                 _seekAudio(Duration(seconds: value.toInt()));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongBoard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageSource;
  final String musicSource;

  const SongBoard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageSource,
    required this.musicSource,
  }) : super(key: key);

  @override
  State<SongBoard> createState() => _SongBoardState();
}

class _SongBoardState extends State<SongBoard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.musicSource));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: widget.imageSource,
              child: Image.asset(
                'assets/mindfullness_assets/images/${widget.imageSource}',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 64,
              onPressed: _togglePlayPause,
            ),
            Slider(
              min: 0,
              max: _totalDuration.inSeconds.toDouble(),
              value: _currentPosition.inSeconds.toDouble(),
              onChanged: (value) {
                _seekAudio(Duration(seconds: value.toInt()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
