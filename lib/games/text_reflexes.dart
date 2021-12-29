// ignore_for_file: camel_case_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:core';
import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';

import '../main.dart' as main;
import '../main/main_online.dart' as main_online;
import '../functions/data_collection_soupmix.dart' as data_collection;

Text? randomText1;
Text? randomText4;
Text? randomText5;
Text? randomText6;

int avgTimeTakenText = 0;

List<Text?> buttonFonts = [
  randomText1,
  randomText4,
  randomText5,
  randomText6,
];
List<int> timeDiffText = [];
List<int> avgTimeText = [0];

int startTimeText = 0;
int endTimeText = 0;

final FlexColorScheme light = FlexColorScheme.light(scheme: FlexScheme.shark);
final FlexColorScheme dark = FlexColorScheme.dark(scheme: FlexScheme.brandBlue);

final ThemeData lightTheme = light.toTheme;
final ThemeData darkTheme = dark.toTheme;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    setState(
      () {
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
        data_collection.newTextGenerated();
      },
    );
  }

  int randomButton = Random().nextInt(3);
  @override
  Widget build(BuildContext context) {
    timeDiffText.clear();
    startTimeText = DateTime.now().millisecondsSinceEpoch;
    timeDiffText.add(startTimeText);
    randomButton = Random().nextInt(3);
    if (randomText1 == randomText4 ||
        randomText1 == randomText5 ||
        randomText1 == randomText6) {
      newFont();
    }
    int avgTimeTakenT = 1 +
        (avgTimeText.map((m) => m).reduce((a, b) => a + b) / avgTimeText.length)
            .ceil();
    avgTimeTakenText = avgTimeTakenT;
    if (kDebugMode) {
      print('Correct button is : ' + randomButton.toString());
    }
    int timeTakenText;
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? FlexColor.sharkLightPrimary
                  : FlexColor.brandBlueDarkPrimary,
          leading: BackButton(
            onPressed: () => {
              data_collection.closeTextAnalytics(),
              endTimeText = DateTime.now().millisecondsSinceEpoch,
              timeDiffText.add(endTimeText),
              timeTakenText = timeDiffText[1] - timeDiffText[0],
              timeDiffText.clear(),
              avgTimeText.add(timeTakenText),
              data_collection.saveDataText(avgTimeTakenText),
              main_online.localTxAvgOnline = avgTimeTakenText,
              main.localTxAvgOffline = avgTimeTakenText,
              endTimeText = 0,
              timeTakenText = 0,
              Navigator.of(context).pushAndRemoveUntil(
                createRoute(const main.materialHomePage()),
                (route) => false,
              ),
            },
          ),
          title: Text('Font Matching - Average : $avgTimeTakenT ms'),
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
          ),
        ),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'bitch',
              onPressed: () {
                if (randomButton == 0) {
                  _correctAnswer(context);
                  newFont();
                } else {
                  _wrongAnswer(context);
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
                  _correctAnswer(context);
                  newFont();
                } else {
                  _wrongAnswer(context);
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
                  _correctAnswer(context);
                  newFont();
                } else {
                  _wrongAnswer(context);
                }
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: randomButton == 2 ? buttonFonts[0] : buttonFonts[3],
            ), // Third Button
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
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
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    Text(
                      'The quick brown',
                      style: TextStyle(
                        fontFamily: buttonFonts[0]!.style!.fontFamily,
                        fontSize: 96,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'fox jumps over',
                      style: TextStyle(
                        fontFamily: buttonFonts[0]!.style!.fontFamily,
                        fontSize: 96,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'the lazy dog',
                      style: TextStyle(
                        fontFamily: buttonFonts[0]!.style!.fontFamily,
                        fontSize: 96,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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

void _correctAnswer(BuildContext context) {
  data_collection.correctAns();
  double deviceHeight = MediaQuery.of(context).size.height;

  endTimeText = DateTime.now().millisecondsSinceEpoch;
  timeDiffText.add(endTimeText);

  int timeTakenText = timeDiffText[1] - timeDiffText[0];
  timeDiffText.clear();
  avgTimeText.add(timeTakenText);
  // ignore: deprecated_member_use
  _scaffoldKey.currentState!.hideCurrentSnackBar();
  // ignore: deprecated_member_use
  _scaffoldKey.currentState!.showSnackBar(
    SnackBar(
      elevation: deviceHeight / 2, // Doesnt work, bc why not ?
      duration: const Duration(milliseconds: 1069),
      content: Text('Right Answer ! It took you : $timeTakenText ms'),
    ),
  );
  timeDiffText.clear();
}

void _wrongAnswer(BuildContext context) {
  data_collection.wrongAns();
  double deviceHeight = MediaQuery.of(context).size.height;
  // ignore: deprecated_member_use
  _scaffoldKey.currentState!.hideCurrentSnackBar();
  // ignore: deprecated_member_use
  _scaffoldKey.currentState!.showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1069),
      elevation: deviceHeight / 2, // Doesnt work, bc why not ?
      content: const Text('Wrong Answer !'),
    ),
  );
}

void goBack(BuildContext context) {
  Navigator.of(context).push(createRoute(const main.HomeCards()));
}

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
