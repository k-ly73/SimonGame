import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'components/popup.dart';
import 'components/popup_content.dart';
import 'simonContainer.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:simon/constants.dart';
import 'dart:math' as Math;

class SimonSays extends StatefulWidget {
  static final AudioCache player = AudioCache();
  static void play(String buttonColor) {
    player.play('$buttonColor.mp3');
  }

  @override
  _SimonSaysState createState() => _SimonSaysState();
}

class ButtonColor {
  static const green = 'green';
  static const red = 'red';
  static const yellow = 'yellow';
  static const blue = 'blue';
}

class _SimonSaysState extends State<SimonSays> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
  List<int> simonSeq = [];
  Widget button;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text('Simon Says Game'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Image.network('https://upload.wikimedia.org/wikipedia/en/thumb/3/35/Information_icon.svg/1200px-Information_icon.svg.png'),
                    iconSize: 35,
                    onPressed: (){
                      showPopup(context, _popupInfo());
                    },
                  )
                ]),
            Text(
              '${result ? (levelNumber == 0 ? '' : 'Level $levelNumber') : gameLabel}',
              style: TextStyle(
                  fontFamily: 'cursive',
                  fontSize: 40.0,
                  color: Colors.white,
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
                      SimonSays.play(ButtonColor.green);
                      if (simonSeq.isNotEmpty) {
                        if (simonSeq[simonIterator] == userChosen) {
                          if (simonSeq.length == userIterator) {
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
                      } else {
                        setState(() {
                          displayNullSeq();
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
                      userChosen = 3;
                      changeOpacity(OpacityColor.yellow);
                      SimonSays.play(ButtonColor.yellow);
                      if (simonSeq.isNotEmpty) {
                        if (simonSeq[simonIterator] == userChosen) {
                          if (simonSeq.length == userIterator) {
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
                      } else {
                        setState(() {
                          displayNullSeq();
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
                      SimonSays.play(ButtonColor.blue);
                      if (simonSeq.isNotEmpty) {
                        if (simonSeq[simonIterator] == userChosen) {
                          if (simonSeq.length == userIterator) {
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
                      } else {
                        setState(() {
                          displayNullSeq();
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
                      SimonSays.play(ButtonColor.red);
                      if (simonSeq.isNotEmpty) {
                        if (simonSeq[simonIterator] == userChosen) {
                          if (simonSeq.length == userIterator) {
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
                      } else {
                        setState(() {
                          displayNullSeq();
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
    );
  }


  @override
  void initState() {
    super.initState();
    SimonSays.player.loadAll(
        ['blue.mp3', 'yellow.mp3', 'green.mp3', 'red.mp3', 'wrong.mp3']);
    getStartStopButton();
  }

  @override
  void dispose() {
    super.dispose();
    SimonSays.player.clearCache();
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
              simonSeq.add(Math.Random().nextInt(4) + 1);
              playSimonSequence(simonSeq);
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
              simonSeq.clear();
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
      SimonSays.play(simonColor);
      changeOpacity(opacityColor);
    });
  }

  void playSimonSequence(List<int> sequence) {
    for (var i = 0; i < sequence.length; i++) {
      switch (sequence[i]) {
        case 1:
          simonPlay(i, ButtonColor.green, OpacityColor.green);
          break;
        case 2:
          simonPlay(i, ButtonColor.red, OpacityColor.red);
          break;
        case 3:
          simonPlay(i, ButtonColor.yellow, OpacityColor.yellow);
          break;
        case 4:
          simonPlay(i, ButtonColor.blue, OpacityColor.blue);
          break;
      }
    }
  }

  void nextSequence() {
    setState(() {
      result = true;
      levelNumber++;
      simonSeq.add(Math.Random().nextInt(4) + 1);
    });

    Future.delayed(Duration(seconds: 1), () {
      playSimonSequence(simonSeq);
    });
  }

  void endGame() {
    setState(() {
      result = false;
      levelNumber = 0;
      simonIterator = 0;
      userIterator = 1;
      gameLabel = 'Game Over';
      simonSeq.clear();
      getStartStopButton();
    });
    SimonSays.player.play('wrong.mp3');
  }

  void displayNullSeq() {
    setState(() {
      gameLabel = 'Start the Game First';
    });
  }
  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text('Information'),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupInfo() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Text(
                  "How To Play Simon Says",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: AutoSizeText(
                    "Follow Simon by pressing the correct buttons to match his sequence! "
                    "Finish as many levels as possible"
                    ))
            ]
        )
    );
  }
}
