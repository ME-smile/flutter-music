import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music/components/loading.dart';
import 'package:music/dao/SingerDAO.dart';

import 'package:music/model/song.dart';

import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music/store/store.dart';
import 'package:music/utils/config.dart';
import 'package:provide/provide.dart';

class Player extends StatefulWidget {
  Player({this.songList, this.index, Key key}) : super(key: key);
  final List songList;
  final int index;
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  SongModel currentSong;
  int currentIndex;
  @override
  void initState() {
    setState(() {
      currentIndex = widget.index;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<AudioModel>(
        builder: (BuildContext context, Widget child, AudioModel audioModel) {
      currentSong = audioModel.playList[audioModel.currentIndex];
      return FutureBuilder(
          future: getAudioUrl(audioModel.playList, audioModel.currentIndex),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              currentSong.audioUrl = snapshot.data['data'][0]['url'];
              return Audio(
                audioUrl: currentSong.audioUrl,
                playbackState: PlaybackState.playing,
                child: Scaffold(
                    body: Stack(
                  children: <Widget>[
                    _BlurBackground(
                      songModel: currentSong,
                    ),
                    Column(
                      children: <Widget>[
                        _PlayerHeader(songModel: currentSong),
                        // SizedBox(height:200.0),
                        _RotationCoverImage(
                          rotating: true,
                          songModel: currentSong,
                        ),
                        _OperationBar(),
                        // _ProgressBar(),
                        _ControllerBar(),
                        Text(currentSong.title),
                        SizedBox(height: 40.0)
                      ],
                    )
                  ],
                )),
              );
            } else {
              return Loading(isFull: true, isLoading: true);
            }
          });
    });
  }
}

class _BlurBackground extends StatelessWidget {
  final SongModel songModel;

  const _BlurBackground({Key key, @required this.songModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/imgs/default.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.black54,
          Colors.black26,
          Colors.black45,
        ])),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
          child: Container(
            color: Colors.black87.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader({this.songModel, Key key}) : super(key: key);
  final SongModel songModel;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '${songModel.title}\n', style: TextStyle(fontSize: 14.0)),
          TextSpan(text: songModel.subTitle, style: TextStyle(fontSize: 12.0))
        ]),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {},
        )
      ],
    );
  }
}

class _RotationCoverImage extends StatefulWidget {
  final bool rotating;
  final SongModel songModel;

  const _RotationCoverImage(
      {Key key, @required this.rotating, @required this.songModel})
      : assert(rotating != null),
        super(key: key);

  @override
  _RotationCoverImageState createState() => _RotationCoverImageState();
}

class _RotationCoverImageState extends State<_RotationCoverImage>
    with SingleTickerProviderStateMixin {
  //album cover rotation
  double rotation = 0.0;

  //album cover rotation animation
  AnimationController controller;

  @override
  void didUpdateWidget(_RotationCoverImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotating) {
      controller.forward(from: controller.value);
    } else {
      controller.stop();
    }
    if (widget.songModel != oldWidget.songModel) {
      controller.value = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 20),
        animationBehavior: AnimationBehavior.normal)
      ..addListener(() {
        setState(() {
          rotation = controller.value *
              2 *
              pi; //lowBound 默认是0.0,upBound默认是1.0，所以生成的是从0到2*pi
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && controller.value == 1) {
          //???难道当controller.value=1时，状态不是completed吗
          controller.forward(from: 0);
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    if (widget.songModel == null || widget.songModel.imgUrl == null) {
      image = AssetImage('lib/assets/imgs/default.jpg');
    } else {
      image = NetworkImage(widget.songModel.imgUrl);
    }
    return Transform.rotate(
      angle: rotation,
      child: Container(
          margin: EdgeInsets.only(top: 80.0),
          width: 250,
          height: 250,
          child: Material(
            elevation: 2.0,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(125),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                // foregroundDecoration: BoxDecoration( //设置这个属性的意义何在？？？
                //     image: DecorationImage(
                //         image: AssetImage('lib/assets/imgs/default.jpg'))),
                width: 250.0,
                height: 250.0,
                padding: EdgeInsets.all(30),
                child: ClipOval(
                  child: Image(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class _OperationBar extends StatelessWidget {
  const _OperationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(),
    );
  }
}

// class _ProgressBar extends StatefulWidget {
//   _ProgressBar({Key key}) : super(key: key);

//   _ProgressBarState createState() => _ProgressBarState();
// }

// class _ProgressBarState extends State<_ProgressBar> {
//   bool isUserTracking = false;
//   double trackPos = 0.0; //播放到的位置

//   String getTimeStamp(int milliseconds) {
//   int seconds = (milliseconds / 1000).truncate();
//   int minutes = (seconds / 60).truncate();

//   String minutesStr = (minutes % 60).toString().padLeft(2, '0');
//   String secondsStr = (seconds % 60).toString().padLeft(2, '0');

//   return "$minutesStr:$secondsStr";
// }

//   @override
//   Widget build(BuildContext context) {
//       bool isUserTracking = false;

//   double trackingPosition = 0;
//     return AudioComponent(
//       playerBuilder: (BuildContext context,AudioPlayer player, Widget child){
//         double playBackProgress = 0.0;
//         String durationText;
//         String positionText;
//         Widget progressIndicator;
//          var duration = player.audioLength.inMilliseconds;
//          var position = player.position.inMilliseconds;
//         if(player.audioLength != null && player.position != null){
//           durationText = getTimeStamp(duration);
//           positionText = getTimeStamp(position);
//           playBackProgress = position/duration;
//         }
//              progressIndicator = Stack(
//         fit: StackFit.passthrough,
//         children: <Widget>[
//           Slider(
//             value: player.position.inMilliseconds.toDouble().clamp(0.0, duration.toDouble()),
//             min: 0.0,
//             max: duration.toDouble(),
//             onChangeStart: (value) {
//               setState(() {
//                 isUserTracking = true;
//                 trackingPosition = value;
//               });
//             },
//             onChanged: (value) {
//               setState(() {
//                 trackingPosition = value;
//               });
//             },
//           ),
//         ],
//       );
//     } else {
//       //a disable slider if media is not available
//       progressIndicator = Slider(value: 0, onChanged: (_) => {});
//     }
//       },
//     );
//   }
// }

class _ControllerBar extends StatelessWidget {
  const _ControllerBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MaterialButton(
          minWidth: 20.0,
          child: Icon(Icons.party_mode),
          onPressed: () {},
        ),
        _PreviousButton(),
        _PlayPauseButton(),
        _NextButton(),
        MaterialButton(
          minWidth: 20.0,
          child: Icon(Icons.favorite),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon = Icons.music_note;
        Color buttonColor = const Color(0xFFFFAFAF);
        Function onPressed;
        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttonColor = Colors.white;
        }

        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: buttonColor,
          splashColor: const Color(0xFFFFAFAF),
          highlightColor: AppColorStyle.lightAccentColor.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Icon(
              icon,
              color: AppColorStyle.darkAccentColor,
              size: 35.0,
            ),
          ),
        );
      },
    );
  }
}

class _PreviousButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return new IconButton(
            splashColor: AppColorStyle.lightAccentColor,
            highlightColor: Colors.transparent,
            icon: new Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 35.0,
            ),
            onPressed: () {
              AudioModel audioModel = Provide.value<AudioModel>(context);
              int index = audioModel.currentIndex;
              if (index > 0) {
                audioModel.setCurrentIndex(index - 1);
              }
            });
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return new IconButton(
            splashColor: AppColorStyle.lightAccentColor,
            highlightColor: Colors.transparent,
            icon: new Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 35.0,
            ),
            onPressed: () {
              AudioModel audioModel = Provide.value<AudioModel>(context);
              int index = audioModel.currentIndex;
              if (index < audioModel.playList.length - 2) {
                audioModel.setCurrentIndex(index + 1);
              }
            });
      },
    );
  }
}

// class _NextButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Text('=================');
//     return new AudioPlaylistComponent(
//       playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
//         return IconButton(
//             splashColor: AppColorStyle.lightAccentColor,
//             highlightColor: Colors.transparent,
//             icon: new Icon(
//               Icons.skip_next,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             onPressed: () {
//               AudioModel _songStore = Provide.value<AudioModel>(context);
//               int _currentIndex = _songStore.currentIndex;
//               if (_currentIndex < _songStore.playList.length) {
//                 getAudioUrl(_songStore.playList, _currentIndex + 1).then((val) {
//                   _songStore.currentSong.audioUrl = val['data'][0]['url'];
//                 });
//               }
//             });
//       },
//     );
//   }
// }
