import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:core';

void main(List<String> args) {
  runApp(const updateApp());
}

// ignore: camel_case_types
class updateApp extends StatelessWidget {
  const updateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.upgrade),
                title: Text(
                  'Update Available',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: (GoogleFonts.lato()).fontFamily,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('UPDATE NOW'),
                    onPressed: () {
                      _launchURL();
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('IGNORE'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _launchURL() async {
  const url = 'https://github.com/Pocoyo-dev/reactiontester/releases/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    if (kDebugMode) {
      print('Error');
    }
  }
}
