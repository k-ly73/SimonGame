import 'package:flutter/material.dart';
import 'simonContainer.dart';
import 'button.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:simon/utilities/constants.dart';
import 'dart:math' as Math;
import 'dart:async';

class Simon extends StatefulWidget {
  static final AudioCache player = AudioCache();
  static void play(String simonColor) {
    player.play('$simonColor.mp3');
  }

  @override
  _SimonState createState() => _SimonState();
}

class SimonColor {
  static const green = 'green';
  static const red = 'red';
  static const yellow = 'yellow';
  static const blue = 'blue';
}

class _SimonState extends State<Simon> {
  int levelNumber = 0;
  int simonIterator = 0;
  int userIterator = 1;
  int userChosen;
  double greenOpacity = 1.0;
  double redOpacity = 1.0;
  double yellowOpacity = 1.0;
  double blueOpacity = 1.0;
  bool result = false;

  String gameLabel = '';
  List<int> simon = [];
  List<int> userSequence = [];
  Widget button;

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
      button = Button(
          buttonLabel: 'Start Game',
          onPressed: () {
            setState(() {
              result = true;
              levelNumber = levelNumber + 1;
              gameLabel = 'Level $levelNumber';
              userSequence.clear();
              simon.add(Math.Random().nextInt(4) + 1);
              playSequence(simon);
              getStartStopButton();
            });
          }).getButton();
    } else if (levelNumber > 0) {
      button = Button(
          buttonLabel: 'Stop Game',
          onPressed: () {
            setState(() {
              result = false;
              levelNumber = 0;
              gameLabel = '';
              simon.clear();
              userSequence.clear();
              getStartStopButton();
            });
          }).getButton();
    }
  }

  void changeOpacity(OpacityColor color) {
    switch (color) {
      case OpacityColor.green:
        setState(() {
          greenOpacity = greenOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            greenOpacity = greenOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case OpacityColor.red:
        setState(() {
          redOpacity = redOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            redOpacity = redOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case OpacityColor.yellow:
        setState(() {
          yellowOpacity = yellowOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            yellowOpacity = yellowOpacity == 0.0 ? 1.0 : 0.0;
          });
        });
        break;
      case OpacityColor.blue:
        setState(() {
          blueOpacity = blueOpacity == 1.0 ? 0.0 : 1.0;
        });

        Future.delayed(Duration(milliseconds: 100), () {
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

  void nextSequence() {
    setState(() {
      userSequence.clear();
      result = true;
      levelNumber++;
      simon.add(Math.Random().nextInt(4) + 1);
    });

    Future.delayed(Duration(seconds: 1), () {
      playSequence(simon);
    });
  }

  void endGame() {
    setState(() {
      result = false;
      levelNumber = 0;
      simonIterator = 0;
      userIterator = 1;
      gameLabel = 'Game Over';
      simon.clear();
      userSequence.clear();
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
          backgroundColor: Colors.purple,
          title: Text('Simon Game'),
        ),
        body: Container(
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${result ? (levelNumber == 0 ? '' : 'Level $levelNumber') : gameLabel}',
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              heightSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: greenOpacity,
                    child: SimonContainer(
                      colour: Colors.green,
                      getNum: Text(
                        '1',
                        textScaleFactor: 2,
                      ),
                      onPressed: () {
                        userChosen = 1;
                        changeOpacity(OpacityColor.green);
                        Simon.play(SimonColor.green);
                        if (simon[simonIterator] == userChosen) {
                          if (simon.length == userIterator) {
                            setState(() {
                              simonIterator = 0;
                              userIterator = 1;
                              nextSequence();
                            });
                          } else {
                            userIterator++;
                            simonIterator++;
                          }
                        } else {
                          setState(() {
                            endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              heightSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: yellowOpacity,
                    child: SimonContainer(
                      colour: Colors.yellow,
                      getNum: Text(
                        '3',
                        textScaleFactor: 2,
                      ),
                      onPressed: () {
                        userSequence.add(3);
                        userChosen = 3;
                        changeOpacity(OpacityColor.yellow);
                        Simon.play(SimonColor.yellow);
                        if (simon[simonIterator] == userChosen) {
                          if (simon.length == userIterator) {
                            setState(() {
                              simonIterator = 0;
                              userIterator = 1;
                              nextSequence();
                            });
                          } else {
                            userIterator++;
                            simonIterator++;
                          }
                        } else {
                          setState(() {
                            endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                  widthSpacer,
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: blueOpacity,
                    child: SimonContainer(
                      colour: Colors.blue,
                      getNum: Text(
                        '4',
                        textScaleFactor: 2,
                      ),
                      onPressed: () {
                        userChosen = 4;
                        changeOpacity(OpacityColor.blue);
                        Simon.play(SimonColor.blue);
                        if (simon[simonIterator] == userChosen) {
                          if (simon.length == userIterator) {
                            setState(() {
                              simonIterator = 0;
                              userIterator = 1;
                              nextSequence();
                            });
                          } else {
                            userIterator++;
                            simonIterator++;
                          }
                        } else {
                          setState(() {
                            endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              heightSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: redOpacity,
                    child: SimonContainer(
                      colour: Colors.red,
                      getNum: Text(
                        '2',
                        textScaleFactor: 2,
                      ),
                      onPressed: () {
                        userChosen = 2;
                        changeOpacity(OpacityColor.red);
                        Simon.play(SimonColor.red);
                        if (simon[simonIterator] == userChosen) {
                          if (simon.length == userIterator) {
                            setState(() {
                              simonIterator = 0;
                              userIterator = 1;
                              nextSequence();
                            });
                          } else {
                            userIterator++;
                            simonIterator++;
                          }
                        } else {
                          setState(() {
                            endGame();
                          });
                        }
                      },
                    ).getDecoration(),
                  ),
                ],
              ),
              heightSpacer,
              button,
              heightSpacer,
            ],
          ),
        ),
      ),
    );
  }
}
