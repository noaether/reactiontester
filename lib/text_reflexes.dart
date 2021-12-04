// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:core';
import 'dart:math';

Text? randomText1;
Text? randomText4;
Text? randomText5;
Text? randomText6;

List<Text?> buttonFonts = [
  randomText1,
  randomText4,
  randomText5,
  randomText6,
];
List<int> timeDiffText = [];
List<int> avgTimeText = [0];

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class textReflexes extends StatefulWidget {
  const textReflexes({Key? key}) : super(key: key);

  @override
  textReflexesState createState() => textReflexesState();
}

class textReflexesState extends State<textReflexes> {
  late double deviceWidth;
  late double deviceHeight;
  // Variables that might be affected

  List<Text> textList = [
    Text(
      'T',
      style: GoogleFonts.lato(),
    ),
    Text(
      'T',
      style: GoogleFonts.pacifico(),
    ),
    Text(
      'T',
      style: GoogleFonts.oswald(),
    ),
    Text(
      'T',
      style: GoogleFonts.lobster(),
    ),
    Text(
      'T',
      style: GoogleFonts.dancingScript(),
    ),
    Text(
      'T',
      style: GoogleFonts.parisienne(),
    ),
    Text(
      'T',
      style: GoogleFonts.almendraDisplay(),
    ),
    Text(
      'T',
      style: GoogleFonts.pressStart2p(),
    ),
    Text(
      'T',
      style: GoogleFonts.specialElite(),
    ),
    Text(
      'T',
      style: GoogleFonts.luckiestGuy(),
    ),
    Text(
      'T',
      style: GoogleFonts.poiretOne(),
    ),
  ];

  Random random = Random();

  // Function to execute
  void newFont() {
    setState(() {
      buttonFonts.clear();
      randomText1 = textList[random.nextInt(textList.length)];
      randomText4 = textList[random.nextInt(textList.length)];
      randomText5 = textList[random.nextInt(textList.length)];
      randomText6 = textList[random.nextInt(textList.length)];

      while (randomText1 == randomText4) {
        randomText4 = textList[random.nextInt(textList.length)];
      }
      while (randomText1 == randomText5) {
        randomText5 = textList[random.nextInt(textList.length)];
      }
      while (randomText1 == randomText6) {
        randomText6 = textList[random.nextInt(textList.length)];
      }
      while (randomText4 == randomText5) {
        randomText5 = textList[random.nextInt(textList.length)];
      }
      while (randomText4 == randomText6) {
        randomText6 = textList[random.nextInt(textList.length)];
      }
      while (randomText5 == randomText6) {
        randomText6 = textList[random.nextInt(textList.length)];
      }

      if (randomText1 != randomText4 &&
          randomText4 != randomText5 &&
          randomText5 != randomText6) {
        buttonFonts.add(randomText1);
        buttonFonts.add(randomText4);
        buttonFonts.add(randomText5);
        buttonFonts.add(randomText6);
      }

      // ignore: avoidprint
    });
  }

  int randomButton = Random().nextInt(3);
  @override
  Widget build(BuildContext context) {
    int dateInMS = DateTime.now().millisecondsSinceEpoch;
    timeDiffText.add(dateInMS);
    randomButton = Random().nextInt(3);
    if (randomText1 == randomText4 ||
        randomText1 == randomText5 ||
        randomText1 == randomText6) {
      newFont();
    }
    int avgTimeTaken = 1 +
        (avgTimeText.map((m) => m).reduce((a, b) => a + b) / avgTimeText.length)
            .ceil();
    // ignore: avoid_print
    print("Correct button is : " + randomButton.toString());
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Colour Reflexes - Average time taken : $avgTimeTaken ms'),
        backgroundColor: Colors.blue[700],
      ),
      // ignore: prefer_const_constructors
      extendBodyBehindAppBar: true,
      // ignore: avoid_unnecessary_containers, prefer_const_constructors
      body: SafeArea(
          // ignore: prefer_const_constructors
          child: Container(
        // ignore: prefer_const_constructors
        child: textBox(),
        alignment: Alignment.center,
      )),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'bitch',
            onPressed: () {
              if (randomButton == 0) {
                correctAnswer(context);
                newFont();
              } else {
                wrongAnswer(context);
              }
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: randomButton == 0 ? buttonFonts[0] : buttonFonts[1],
          ), // First Button

          FloatingActionButton(
            heroTag: 'asshole',
            onPressed: () {
              if (randomButton == 1) {
                correctAnswer(context);
                newFont();
              } else {
                wrongAnswer(context);
              }
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: randomButton == 1 ? buttonFonts[0] : buttonFonts[2],
          ), // Second Button

          FloatingActionButton(
            heroTag: 'colourblind',
            onPressed: () {
              if (randomButton == 2) {
                correctAnswer(context);
                newFont();
              } else {
                wrongAnswer(context);
              }
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: randomButton == 2 ? buttonFonts[0] : buttonFonts[3],
          ), // Third Button
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class textBox extends StatelessWidget {
  const textBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'The quick brown fox jumps over the lazy dog',
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: buttonFonts[0]!.style!.fontFamily,
                    fontSize: 48,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              alignment: Alignment.center,
            ),
          ],
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}

void correctAnswer(BuildContext context) {
  double deviceHeight = MediaQuery.of(context).size.height;

  int dateInMSAfterAnswer = DateTime.now().millisecondsSinceEpoch;
  timeDiffText.add(dateInMSAfterAnswer);

  int timeTakenText = timeDiffText[1] - timeDiffText[0];
  timeDiffText.clear();
  avgTimeText.add(timeTakenText);
  // ignore: deprecated_member_use
  scaffoldKey.currentState!.hideCurrentSnackBar();
  // ignore: deprecated_member_use
  scaffoldKey.currentState!.showSnackBar(
    SnackBar(
      elevation: deviceHeight / 2, // Doesnt work, bc why not ?
      duration: const Duration(milliseconds: 1069),
      content: Text('Right Answer ! It took you : $timeTakenText ms'),
    ),
  );
  timeDiffText.clear();
}

void wrongAnswer(BuildContext context) {
  double deviceHeight = MediaQuery.of(context).size.height;
  // ignore: deprecated_member_use
  scaffoldKey.currentState!.hideCurrentSnackBar();
  // ignore: deprecated_member_use
  scaffoldKey.currentState!.showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 1069),
    elevation: deviceHeight / 2, // Doesnt work, bc why not ?
    content: const Text('Wrong Answer !'),
  ));
}

void goBack(BuildContext context) {
  Navigator.of(context).pop();
}