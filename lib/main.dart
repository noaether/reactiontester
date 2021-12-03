// ignore_for_file: camel_case_types

import 'dart:math';

import 'colour_reflexes.dart';
import 'text_reflexes.dart';

import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

import 'dart:core';

Color? randomColour1 = Colors.transparent;

Color? randomColour4 = Colors.transparent;
Color? randomColour5 = Colors.transparent;
Color? randomColour6 = Colors.transparent;

List buttonColours = [];
List<int> timeDiffColours = [];
List<int> avgTimeColours = [0];

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(const GameChoices());
}

class GameChoices extends StatelessWidget {
  const GameChoices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // COLOUR REFLEXES
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[600],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
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
                bottom: MediaQuery.of(context).size.width * 0.0445,
                left: MediaQuery.of(context).size.width * 0.01,
                width: MediaQuery.of(context).size.width * 0.45 -
                    MediaQuery.of(context).size.width * 0.02,
                child: ElevatedButton(
                  onPressed: () => (Navigator.of(context)
                      .push(createRoute(const colourReflexes()))),
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        color: Colors.cyan[800],
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
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.45,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[600],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
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
                bottom: MediaQuery.of(context).size.width * 0.0445,
                left: MediaQuery.of(context).size.width * 0.01,
                width: MediaQuery.of(context).size.width * 0.45 -
                    MediaQuery.of(context).size.width * 0.02,
                child: ElevatedButton(
                  onPressed: () => (Navigator.of(context)
                      .push(createRoute(const textReflexes()))),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      color: Colors.cyan[800],
                      child: Text(
                        "Colour Reflexes",
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
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.bounceIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
