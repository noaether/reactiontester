// ignore_for_file: camel_case_types

// Internal files
import 'package:cloud_firestore/cloud_firestore.dart';

import 'colour_reflexes.dart';
import 'text_reflexes.dart';
import 'update.dart';
import 'data_collection.dart';
import 'firebase_options.dart';

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

// UI
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Analytics
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Storing Data Internally
import 'package:device_info_plus/device_info_plus.dart';

// Reading/Opening Data Externally
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Core
import 'dart:core';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// Variables
final FlexColorScheme light = FlexColorScheme.light(scheme: FlexScheme.shark);
final FlexColorScheme dark = FlexColorScheme.dark(scheme: FlexScheme.brandBlue);

final ThemeData lightTheme = light.toTheme;
final ThemeData darkTheme = dark.toTheme;

String installedVersion = "1.2.2.2-2";
String? webVersion;

bool willInteract = false;

int? atc;
int? att;

void main() async {
  int startTime = DateTime.now().millisecondsSinceEpoch;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/license.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, persistenceEnabled: true);

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    //
    // NETWORK : NO CONNECTION FOUND
    //
    willInteract = false;
    await FirebaseFirestore.instance.disableNetwork();
    if (kDebugMode) {
      print("No connectivity found; Cannot verify version nor send analytics");
    }
  } else {
    //
    // NETWORK : WIFI/ETHERNET/MOBILE
    //
    if ((Platform.isAndroid == false && kIsWeb == false)) {
      willInteract = false;
      if (kDebugMode) {
        print("Device is Desktop, can't send analytics");
      }
    } else {
      willInteract = true;
      if (kDebugMode) {
        print(
            "Internet connectivity detected; Will verify version and send analytics");
      }
      var url = Uri.parse(
          'https://raw.githubusercontent.com/Pocoyo-dev/reactiontester/main/version');
      final response =
          await http.get(url, headers: {"Accept": "application/json"});
      webVersion = response.body;
      openAppAnalytics();
    }
  }
  int endTime = DateTime.now().millisecondsSinceEpoch;
  int loadTime = endTime - startTime;

  runApp(const materialHomePage());
  if (kDebugMode) {
    print("It took : $loadTime ms to load all async functions");
  }
}

class materialHomePage extends StatelessWidget {
  const materialHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeCards(),
      title: 'ReactionTester',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}

class HomeCards extends StatefulWidget {
  const HomeCards({Key? key}) : super(key: key);

  @override
  _HomeCardsState createState() => _HomeCardsState();
}

class _HomeCardsState extends State<HomeCards> {
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return RawDialogRoute<void>(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return const updateApp();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (webVersion != null) {
      //
      // ONLINE
      //
      getDataColourOnline();
      getDataTextOnline();
      List<int> installedVersionList = [];
      installedVersionList.addAll(utf8.encode(installedVersion));
      List<int> webVersionList = [];
      webVersionList.addAll(utf8.encode(webVersion!));
      webVersionList.removeLast();
      String webVersionText = utf8.decode(webVersionList).toString();
      String installedVersionText =
          utf8.decode(installedVersionList).toString();
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: const Text(
              "ReactionTester",
              textAlign: TextAlign.justify,
            ),
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? FlexColor.sharkLightPrimary
                    : FlexColor.brandBlueDarkPrimary,
            leading: webVersionText != installedVersionText
                ? IconButton(
                    alignment: Alignment.center,
                    tooltip: "Upgrade is available !",
                    onPressed: () {
                      Navigator.of(context).restorablePush(_dialogBuilder);
                    },
                    icon: const Icon(Icons.upgrade),
                  )
                : null),
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
                        openColourAnalytics();
                        Navigator.of(context).push(createRoute(
                          const colourReflexes(),
                        ));
                      },
                      child: IgnorePointer(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'Colour Matching',
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'How fast can you\r\nlink colours together ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: SelectableText(
                                  'Psst. You can swipe to get more info ->',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
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
                            child: SelectableText(
                              'How do I play this game ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: SelectableText(
                              'You will be given one colour \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: atc == null
                                  ? Text(
                                      'You haven\'t played this game yet!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Text(
                                      'Average time taken: $atc ms',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Image(
                              image:
                                  const AssetImage('thumbnails/crflxthb.png'),
                              width: MediaQuery.of(context).size.width - 100,
                              height:
                                  (MediaQuery.of(context).size.width - 100) *
                                      0.47760,
                            ),
                          ),
                        ],
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
                        openTextAnalytics();
                        Navigator.of(context).push(createRoute(
                          const textReflexes(),
                        ));
                      },
                      child: IgnorePointer(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'Font Matching',
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'How fast can you\r\nreunite fonts together ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: SelectableText(
                                  'Psst. You can swipe to get more info ->',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
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
                            child: SelectableText(
                              'How do I play this game ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: SelectableText(
                              'You will be given one sentence \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: att == null
                                  ? Text(
                                      'You haven\'t played this game yet!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Text(
                                      'Average time taken: $att ms',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Image(
                              image:
                                  const AssetImage('thumbnails/trflxthb.png'),
                              width: MediaQuery.of(context).size.width - 100,
                              height:
                                  (MediaQuery.of(context).size.width - 100) *
                                      0.47760,
                            ),
                          ),
                        ],
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
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: "ReactionTester",
                          applicationVersion: installedVersion,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 10,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "About this app",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        _launchURL();
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
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        if (kDebugMode) {
                          print('Text 1 : $installedVersionList');
                        }
                        if (kDebugMode) {
                          print('Text 2 : $webVersionList');
                        }

                        String webVersionText =
                            utf8.decode(webVersionList).toString();
                        String installedVersionText =
                            utf8.decode(installedVersionList).toString();

                        if (webVersionText != installedVersionText) {
                          Navigator.of(context).restorablePush(_dialogBuilder);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 10,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Check for updates",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
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
    } else {
      //
      // OFFLINE
      //
      getDataColourOffline();
      getDataTextOffline();
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "ReactionTester",
            textAlign: TextAlign.justify,
          ),
          backgroundColor:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? FlexColor.sharkLightPrimary
                  : FlexColor.brandBlueDarkPrimary,
        ),
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
                        openColourAnalytics();
                        Navigator.of(context).push(createRoute(
                          const colourReflexes(),
                        ));
                      },
                      child: IgnorePointer(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'Colour Matching',
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'How fast can you\r\nlink colours together ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: SelectableText(
                                  'Psst. You can swipe to get more info ->',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
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
                            child: SelectableText(
                              'How do I play this game ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: SelectableText(
                              'You will be given one colour \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: atc == null
                                  ? Text(
                                      'You haven\'t played this game yet!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Text(
                                      'Average time taken: $atc ms',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Image(
                              image:
                                  const AssetImage('thumbnails/crflxthb.png'),
                              width: MediaQuery.of(context).size.width - 100,
                              height:
                                  (MediaQuery.of(context).size.width - 100) *
                                      0.47760,
                            ),
                          ),
                        ],
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
                        openTextAnalytics();
                        Navigator.of(context).push(createRoute(
                          const textReflexes(),
                        ));
                      },
                      child: IgnorePointer(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'Font Matching',
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fill,
                                child: SelectableText(
                                  'How fast can you\r\nreunite fonts together ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: SelectableText(
                                  'Psst. You can swipe to get more info ->',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: (GoogleFonts.lato()).fontFamily,
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
                            child: SelectableText(
                              'How do I play this game ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: SelectableText(
                              'You will be given one sentence \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: (GoogleFonts.lato()).fontFamily,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: att == null
                                  ? Text(
                                      'You haven\'t played this game yet!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Text(
                                      'Average time taken: $att ms',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            (GoogleFonts.lato()).fontFamily,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Image(
                              image:
                                  const AssetImage('thumbnails/trflxthb.png'),
                              width: MediaQuery.of(context).size.width - 100,
                              height:
                                  (MediaQuery.of(context).size.width - 100) *
                                      0.47760,
                            ),
                          ),
                        ],
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
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: "ReactionTester",
                          applicationVersion: installedVersion,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 10,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "About this app",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: (GoogleFonts.lato()).fontFamily,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        _launchURL();
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

_launchURL() async {
  const url = 'http://pocoyo.rf.gd';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Unable to launch Internet Browser on device ${_getId()} ";
  }
}

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}
