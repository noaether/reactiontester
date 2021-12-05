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
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 65, 95, 1),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // COLOUR REFLEXES
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.95,
                width: MediaQuery.of(context).size.width * 0.475,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(127, 0, 255, 1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        ' ',
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'What is Colour Reflexes ?',
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                          color: Colors.black,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'It is a game.',
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                          color: Colors.black,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.width * 0.0345,
                left: MediaQuery.of(context).size.width * 0.0225,
                width: MediaQuery.of(context).size.width * 0.45 -
                    MediaQuery.of(context).size.width * 0.02,
                child: ElevatedButton(
                  onPressed: () => (Navigator.of(context).push(
                    createRoute(
                      const colourReflexes(),
                    ),
                  )),
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        child: Text(
                          "Colour Reflexes",
                          style: TextStyle(
                            fontFamily: (GoogleFonts.poppins()).fontFamily,
                          ),
                        ),
                      )),
                ),
              )
            ],
          ),

          // SEPARATOR

          const SizedBox(
            height: double.infinity,
            width: 2,
          ),

          // TEXT REFLEXES
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.95,
                width: MediaQuery.of(context).size.width * 0.475,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(127, 0, 255, 1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        ' ',
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        'What is Text Reflexes ?',
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                          color: Colors.black,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'It is a game.',
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                          color: Colors.black,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.width * 0.0345,
                left: MediaQuery.of(context).size.width * 0.0225,
                width: MediaQuery.of(context).size.width * 0.45 -
                    MediaQuery.of(context).size.width * 0.02,
                child: ElevatedButton(
                  onPressed: () => (Navigator.of(context).push(
                    createRoute(
                      const textReflexes(),
                    ),
                  )),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      child: Text(
                        "Text Reflexes",
                        style: TextStyle(
                          fontFamily: (GoogleFonts.poppins()).fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 2000),
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
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
