// ignore_for_file: camel_case_types

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'colour_reflexes.dart';
import 'text_reflexes.dart';

import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

import 'dart:core';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/licenses.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const GameChoices());
}

class GameChoices extends StatelessWidget {
  const GameChoices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeCards());
  }
}

class HomeCards extends StatefulWidget {
  HomeCards({Key? key}) : super(key: key);

  @override
  _HomeCardsState createState() => _HomeCardsState();
}

class _HomeCardsState extends State<HomeCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    // First page
                    onTap: () {
                      Navigator.of(context)
                          .push(createRoute(const colourReflexes()));
                    },
                    child: IgnorePointer(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                'Colour Matching',
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                'How fast can you\r\nlink colours together ?',
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Psst. You can swipe to get more info ->',
                                softWrap: true,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //
                  //
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'How do I play this game ?',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
                              color: Colors.black,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'You will be given one colour \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.width * 0.47760,
                    child: Image(
                      image: const AssetImage('thumbnails/crflxthb.png'),
                      width: MediaQuery.of(context).size.width - 50,
                      height: MediaQuery.of(context).size.width * 0.47760,
                    ),
                  )
                ],
              ),
            ),
          ),
          //
          //
          //
          Expanded(
            flex: 3,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    // First page
                    onTap: () {
                      Navigator.of(context)
                          .push(createRoute(const textReflexes()));
                    },
                    child: IgnorePointer(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                'Font Matching',
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                'How fast can you\r\nreunite fonts together ?',
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Psst. You can swipe to get more info ->',
                                softWrap: true,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //
                  //
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'How do I play this game ?',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
                              color: Colors.black,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'You will be given one sentence \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.width * 0.47760,
                    child: Image(
                      image: const AssetImage('thumbnails/trflxthb.png'),
                      width: MediaQuery.of(context).size.width - 50,
                      height: MediaQuery.of(context).size.width * 0.47760,
                    ),
                  )
                ],
              ),
            ),
          ),
          //
          //
          //
          Expanded(
            flex: 1,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            print('About Me interaction');
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "About this app",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: (GoogleFonts.lato()).fontFamily,
                                  color: Colors.black,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print('About Me interaction');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 10,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "About this app's developper",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: (GoogleFonts.lato()).fontFamily,
                            color: Colors.black,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<AssetImage> loadImageAsset(
    String folder, String assetname, String fileType) async {
  return AssetImage('$folder/$assetname.$fileType');
}

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 2000),
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
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
