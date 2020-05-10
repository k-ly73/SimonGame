import 'package:flutter/material.dart';
import 'simonContainer.dart';
import 'simonColor.dart';
import 'button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:simon/utilities/constants.dart';
import 'dart:math' as Math;
import 'dart:async';

/* 
 ! SIMON SEQUENCE RULES, BUT IT CAN BE CHANGED IF YOU WISH
 * GREEN is defined as 1
 * RED is defined as 2
 * YELLOW is defined as 3
 * BLUE is defined as 4
*/

class Simon extends StatefulWidget {
  static final AudioCache player = AudioCache();
  static void play(String simonColor) {
    player.play('$simonColor.mp3');
  }

  @override
  _SimonState createState() => _SimonState();
}

class _SimonState extends State<Simon> {
  int levelNumber = 0;
  double greenOpacity = 1.0;
  double redOpacity = 1.0;
  double yellowOpacity = 1.0;
  double blueOpacity = 1.0;
  bool _result = false;

  String _gameLabel = '';
  List<int> _simonSequence = [];
  List<int> _userSequence = [];
  Widget _button;

  @override
  void initState() {
    super.initState();
    Simon.player.loadAll(
        ['blue.mp3', 'yellow.mp3', 'green.mp3', 'red.mp3', 'wrong.mp3']);
    getStartStopButton();
  }

  @override
  void dispose() {
    super.dispose();
    Simon.player.clearCache();
  }

  void getStartStopButton() {
    if (levelNumber == 0) {
      _button = Button(
          buttonLabel: 'Start Game',
          onPressed: () {
            setState(() {
              _result = true;
              levelNumber = levelNumber + 1;
              _gameLabel = 'Level $levelNumber';
              _userSequence.clear();
              _simonSequence.add(Math.Random().nextInt(4) + 1);
              playSequence(_simonSequence);
              getStartStopButton();
            });
          }).getButton();
    } else if (levelNumber > 0) {
      _button = Button(
          buttonLabel: 'Stop Game',
          onPressed: () {
            setState(() {
              stopSequence();
              _result = false;
              levelNumber = 0;
              _gameLabel = '';
              _simonSequence.clear();
              _userSequence.clear();
              getStartStopButton();
            });
          }).getButton();
    }
  }

  void changeOpacity(OpacityColor color) {
    switch (color) {
      case OpacityColor.green:
        setState(() {
          greenOpacity = greenOpacity == 0.0 ? 1.0 : 0.0;
        });

        Future.delayed(kDelayedOpacityDuration, () {
          setState(() {
            greenOpacity = greenOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case OpacityColor.red:
        setState(() {
          redOpacity = redOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(kDelayedOpacityDuration, () {
          setState(() {
            redOpacity = redOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case OpacityColor.yellow:
        setState(() {
          yellowOpacity = yellowOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(kDelayedOpacityDuration, () {
          setState(() {
            yellowOpacity = yellowOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case OpacityColor.blue:
        setState(() {
          blueOpacity = blueOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(kDelayedOpacityDuration, () {
          setState(() {
            blueOpacity = blueOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
    }
  }

  void simonPlay(int index, String simonColor, OpacityColor opacityColor) {
    Future.delayed(Duration(milliseconds: index * 500), () {
      Simon.play(simonColor);
      changeOpacity(opacityColor);
    });
  }

  void playSequence(List<int> sequence) {
    for (var i = 0; i < sequence.length; i++) {
      switch (sequence[i]) {
        case 1:
          simonPlay(i, SimonColor.green, OpacityColor.green);
          break;
        case 2:
          simonPlay(i, SimonColor.red, OpacityColor.red);
          break;
        case 3:
          simonPlay(i, SimonColor.yellow, OpacityColor.yellow);
          break;
        case 4:
          simonPlay(i, SimonColor.blue, OpacityColor.blue);
          break;
      }
    }
  }

  void stopSequence() {}

  void nextSequence() {
    setState(() {
      _userSequence.clear();
      _result = true;
      levelNumber++;
      _simonSequence.add(Math.Random().nextInt(4) + 1);
    });

    Future.delayed(Duration(seconds: 1), () {
      playSequence(_simonSequence);
    });
  }

  bool checkSeqeunce() {
    int count = 0;
    for (var sq in _simonSequence) {
      for (var i = count; i < _userSequence.length;) {
        if (sq != _userSequence[i]) {
          return false;
        } else {
          count++;
          break;
        }
      }
      continue;
    }
    return true;
  }

  void endGame() {
    setState(() {
      _result = false;
      levelNumber = 0;
      _gameLabel = 'Game Over';
      _simonSequence.clear();
      _userSequence.clear();
      getStartStopButton();
    });
    Simon.player.play('wrong.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Simon Game'),
        ),
        body: Container(
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${_result ? (levelNumber == 0 ? '' : 'Level $levelNumber') : _gameLabel}',
                style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              kHeightSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: kAnimatedOpacityDuration,
                    opacity: greenOpacity,
                    child: SimonContainer(
                      colour: Colors.green,
                      onPressed: () {
                        _userSequence.add(1);
                        changeOpacity(OpacityColor.green);
                        Simon.play(SimonColor.green);
                        if (_simonSequence.length == _userSequence.length) {
                          setState(() {
                            _result = checkSeqeunce();
                            if (_result)
                              nextSequence();
                            else
                              endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                  kWidthSpacer,
                  AnimatedOpacity(
                    duration: kAnimatedOpacityDuration,
                    opacity: redOpacity,
                    child: SimonContainer(
                      colour: Colors.red,
                      onPressed: () {
                        _userSequence.add(2);
                        changeOpacity(OpacityColor.red);
                        Simon.play(SimonColor.red);
                        if (_simonSequence.length == _userSequence.length) {
                          setState(() {
                            _result = checkSeqeunce();
                            if (_result)
                              nextSequence();
                            else
                              endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              kHeightSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: kAnimatedOpacityDuration,
                    opacity: yellowOpacity,
                    child: SimonContainer(
                      colour: Colors.yellow,
                      onPressed: () {
                        _userSequence.add(3);
                        changeOpacity(OpacityColor.yellow);
                        Simon.play(SimonColor.yellow);
                        if (_simonSequence.length == _userSequence.length) {
                          _result = checkSeqeunce();
                          if (_result)
                            nextSequence();
                          else
                            endGame();
                        }
                      },
                    ).getDecoration(),
                  ),
                  kWidthSpacer,
                  AnimatedOpacity(
                    duration: kAnimatedOpacityDuration,
                    opacity: blueOpacity,
                    child: SimonContainer(
                      colour: Colors.blue,
                      onPressed: () {
                        _userSequence.add(4);
                        changeOpacity(OpacityColor.blue);
                        Simon.play(SimonColor.blue);
                        if (_simonSequence.length == _userSequence.length) {
                          setState(() {
                            _result = checkSeqeunce();
                            if (_result)
                              nextSequence();
                            else
                              endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              kHeightSpacer,
              _button,
              kHeightSpacer,
            ],
          ),
        ),
      ),
    );
  }

}
