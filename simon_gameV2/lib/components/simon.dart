import 'package:flutter/material.dart';
import 'simonContainer.dart';
import 'simonColor.dart';
import 'button.dart';
import 'package:url_launcher/url_launcher.dart';
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

class _SimonState extends State<Simon> {
  int levelNumber = 0;
  double greenOpacity = 1.0;
  double redOpacity = 1.0;
  double yellowOpacity = 1.0;
  double blueOpacity = 1.0;
  bool result = false;

  String gameLabel = '';
  List<int> simonSequence = [];
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
            simonSequence.add(Math.Random().nextInt(4) + 1);
            playSequence(simonSequence);
            getStartStopButton();
          });
        }
      ).getButton();
    } 
    else if (levelNumber > 0) 
    {
      button = Button(
          buttonLabel: 'Stop Game',
          onPressed: () {
            setState(() {
              stopSequence();
              result = false;
              levelNumber = 0;
              gameLabel = '';
              simonSequence.clear();
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

  void stopSequence() {
    
  }

  void nextSequence() {
    setState(() {
      userSequence.clear();
      result = true;
      levelNumber++;
      simonSequence.add(Math.Random().nextInt(4) + 1);
    });

    Future.delayed(Duration(seconds: 1), () {
      playSequence(simonSequence);
    });
  }

  bool checkSeqeunce() {
    int count = 0;
    for (var sq in simonSequence) {
      for (var i = count; i < userSequence.length;) {
        if (sq != userSequence[i]) {
          return false;
        } 
        else 
        {
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
      result = false;
      levelNumber = 0;
      gameLabel = 'Game Over';
      simonSequence.clear();
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
          color: Colors.white12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${result ? (levelNumber == 0 ? '' : 'Level $levelNumber') : gameLabel}',
                style: TextStyle(
                    fontSize: 50.0,
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
                      onPressed: () {
                        userSequence.add(1);
                        changeOpacity(OpacityColor.green);
                        Simon.play(SimonColor.green);
                        if (simonSequence.length == userSequence.length) {
                          setState(() {
                            result = checkSeqeunce();
                            if (result)
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
              heightSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: yellowOpacity,
                    child: SimonContainer(
                      colour: Colors.yellow,
                      onPressed: () {
                        userSequence.add(3);
                        changeOpacity(OpacityColor.yellow);
                        Simon.play(SimonColor.yellow);
                        if (simonSequence.length == userSequence.length) {
                          result = checkSeqeunce();
                          if (result)
                            nextSequence();
                          else
                            endGame();
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
                      onPressed: () {
                        userSequence.add(4);
                        changeOpacity(OpacityColor.blue);
                        Simon.play(SimonColor.blue);
                        if (simonSequence.length == userSequence.length) {
                          setState(() {
                            result = checkSeqeunce();
                            if (result)
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
              heightSpacer,
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: redOpacity,
                    child: SimonContainer(
                      colour: Colors.red,
                      onPressed: () {
                        userSequence.add(2);
                        changeOpacity(OpacityColor.red);
                        Simon.play(SimonColor.red);
                        if (simonSequence.length == userSequence.length) {
                          setState(() {
                            result = checkSeqeunce();
                            if (result) {
                              nextSequence();
                            }
                            else {
                              endGame();
                            }
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
