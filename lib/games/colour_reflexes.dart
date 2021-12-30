// ignore_for_file: camel_case_types

import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:core';
import 'dart:math';

import '../main.dart' as main;
import '../main/main_online.dart' as main_online;
import '../functions/data_collection_soupmix.dart' as data_collection;

Color? randomColour1 = Colors.transparent;

Color? randomColour4 = Colors.transparent;
Color? randomColour5 = Colors.transparent;
Color? randomColour6 = Colors.transparent;

int avgTimeTakenColour = 0;

List buttonColours = [
  randomColour1,
  randomColour4,
  randomColour5,
  randomColour6,
];
List<int> timeDiffColours = [];
List<int> avgTimeColours = [0];

int startTimeColour = 0;
int endTimeColour = 0;

final FlexColorScheme light = FlexColorScheme.light(scheme: FlexScheme.shark);
final FlexColorScheme dark = FlexColorScheme.dark(scheme: FlexScheme.brandBlue);

final ThemeData lightTheme = light.toTheme;
final ThemeData darkTheme = dark.toTheme;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class colourReflexes extends StatefulWidget {
  const colourReflexes({Key? key}) : super(key: key);

  @override
  colourReflexesState createState() => colourReflexesState();
}

class colourReflexesState extends State<colourReflexes> {
  late double deviceWidth;
  late double deviceHeight;

  void start() {
    buttonColours.add(randomColour1);
    buttonColours.add(randomColour4);
    buttonColours.add(randomColour5);
    buttonColours.add(randomColour6);
  }
  // Variables that might be affected

  List<Color?> colorList = [
    Colors.yellow,
    Colors.teal,
    Colors.red,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.lime,
    Colors.lightGreen,
    Colors.lightBlue[200],
    Colors.indigo,
    Colors.green,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.blue,
    Colors.amber,
    Colors.black,
    const Color.fromARGB(255, 105, 105, 105), // Grey but hex is #696969
    const Color.fromARGB(255, 66, 4, 32), // Magenta but hex is #b00b69
    const Color.fromARGB(255, 176, 11, 105), // Dark Purple but hex is #420420
  ];

  Random random = Random();

  // Function to execute
  void newColour() {
    setState(
      () {
        buttonColours.clear();
        randomColour1 = colorList[random.nextInt(colorList.length)];
        randomColour4 = colorList[random.nextInt(colorList.length)];
        randomColour5 = colorList[random.nextInt(colorList.length)];
        randomColour6 = colorList[random.nextInt(colorList.length)];

        while (randomColour1 == randomColour4) {
          randomColour4 = colorList[random.nextInt(colorList.length)];
        }
        while (randomColour1 == randomColour5) {
          randomColour5 = colorList[random.nextInt(colorList.length)];
        }
        while (randomColour1 == randomColour6) {
          randomColour6 = colorList[random.nextInt(colorList.length)];
        }
        while (randomColour4 == randomColour5) {
          randomColour5 = colorList[random.nextInt(colorList.length)];
        }
        while (randomColour4 == randomColour6) {
          randomColour6 = colorList[random.nextInt(colorList.length)];
        }
        while (randomColour5 == randomColour6) {
          randomColour6 = colorList[random.nextInt(colorList.length)];
        }

        if (randomColour1 != randomColour4 &&
            randomColour4 != randomColour5 &&
            randomColour5 != randomColour6) {
          buttonColours.add(randomColour1);
          buttonColours.add(randomColour4);
          buttonColours.add(randomColour5);
          buttonColours.add(randomColour6);
        }
        data_collection.newColourGenerated();
      },
    );
  }

  int randomButton = Random().nextInt(3);
  bool isbw = false;

  @override
  Widget build(BuildContext context) {
    int startTimeColour = DateTime.now().millisecondsSinceEpoch;
    timeDiffColours.add(startTimeColour);
    randomButton = Random().nextInt(3);
    if (randomColour1 == randomColour4 ||
        randomColour1 == randomColour5 ||
        randomColour1 == randomColour6) {
      newColour();
    }
    int avgTimeTakenC = 1 +
        (avgTimeColours.map((m) => m).reduce((a, b) => a + b) /
                avgTimeColours.length)
            .ceil();
    avgTimeTakenColour = avgTimeTakenC;
    if (kDebugMode) {
      print('Correct button is : ' + randomButton.toString());
    }
    int timeTakenColour;

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
              data_collection.closeColourAnalytics(),
              endTimeColour = DateTime.now().millisecondsSinceEpoch,
              timeDiffColours.add(endTimeColour),
              timeTakenColour = timeDiffColours[1] - timeDiffColours[0],
              timeDiffColours.clear(),
              avgTimeColours.add(timeTakenColour),
              data_collection.saveDataColour(avgTimeTakenColour, isbw),
              main_online.localClAvgOnline = avgTimeTakenColour,
              main.localClAvgOffline = avgTimeTakenColour,
              endTimeColour = 0,
              timeTakenColour = 0,
              Navigator.of(context).pushAndRemoveUntil(
                createRoute(const main.materialHomePage()),
                (route) => false,
              )
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.monochrome_photos),
              tooltip: 'Toggle b/w',
              onPressed: () {
                if (isbw == false) {
                  data_collection.blackAndWhiteOn();
                  colorList.clear();
                  colorList.addAll(
                    [
                      Colors.grey[50],
                      Colors.grey[100],
                      Colors.grey[200],
                      Colors.grey[300],
                      Colors.grey[400],
                      Colors.grey,
                      Colors.grey[600],
                      Colors.grey[700],
                      Colors.grey[800],
                      Colors.grey[850],
                      Colors.grey[900],
                      Colors.black,
                    ],
                  );
                  isbw = true;
                  newColour();
                } else {
                  data_collection.blackAndWhiteOff();
                  colorList.clear();
                  colorList.addAll(
                    [
                      Colors.yellow,
                      Colors.teal,
                      Colors.red,
                      Colors.purple,
                      Colors.pink,
                      Colors.orange,
                      Colors.lime,
                      Colors.lightGreen,
                      Colors.lightBlue[200],
                      Colors.indigo,
                      Colors.green,
                      Colors.deepPurple,
                      Colors.deepOrange,
                      Colors.brown,
                      Colors.blueGrey,
                      Colors.blue,
                      Colors.amber,
                      Colors.black,
                      const Color.fromARGB(
                        255,
                        105,
                        105,
                        105,
                      ), // Grey but hex is #696969
                      const Color.fromARGB(
                        255,
                        66,
                        4,
                        32,
                      ), // Magenta but hex is #b00b69
                      const Color.fromARGB(255, 176, 11, 105),
                    ],
                  );
                  isbw = false;
                  newColour();
                }
              },
            ),
          ],
          title: Text('Colour Matching - Average : $avgTimeTakenC ms'),
        ),
        // ignore: prefer_const_constructors
        extendBodyBehindAppBar: true,
        // ignore: avoid_unnecessary_containers, prefer_const_constructors
        body: SafeArea(
          // ignore: prefer_const_constructors
          child: colourBox(),
        ),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                if (randomButton == 0) {
                  _correctAnswer(context);
                  newColour();
                } else {
                  _wrongAnswer(context);
                }
              },
              tooltip: 'Button 1',
              backgroundColor:
                  randomButton == 0 ? buttonColours[0] : buttonColours[1],
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ), // First Button

            FloatingActionButton(
              onPressed: () {
                if (randomButton == 1) {
                  _correctAnswer(context);
                  newColour();
                } else {
                  _wrongAnswer(context);
                }
              },
              tooltip: 'Button 2',
              backgroundColor:
                  randomButton == 1 ? buttonColours[0] : buttonColours[2],
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ), // Second Button

            FloatingActionButton(
              onPressed: () {
                if (randomButton == 2) {
                  _correctAnswer(context);
                  newColour();
                } else {
                  _wrongAnswer(context);
                }
              },
              tooltip: 'Button 3',
              backgroundColor:
                  randomButton == 2 ? buttonColours[0] : buttonColours[3],
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ), // Third Button
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class colourBox extends StatelessWidget {
  const colourBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: buttonColours[0],
            alignment: Alignment.center,
          ),
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

  int dateInMSAfterAnswer = DateTime.now().millisecondsSinceEpoch;
  timeDiffColours.add(dateInMSAfterAnswer);

  int timeTaken = timeDiffColours[1] - timeDiffColours[0];
  avgTimeColours.add(timeTaken);
  // ignore: deprecated_member_use
  _scaffoldKey.currentState!.hideCurrentSnackBar();
  // ignore: deprecated_member_use
  _scaffoldKey.currentState!.showSnackBar(
    SnackBar(
      elevation: deviceHeight / 2, // Doesnt work, bc why not ?
      duration: const Duration(milliseconds: 1069),
      content: Text('Right Answer ! It took you : $timeTaken ms'),
    ),
  );
  timeDiffColours.clear();
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
