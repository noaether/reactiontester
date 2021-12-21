// ignore_for_file: camel_case_types

// Internal files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import './main/main_offline.dart' as main_offline;
import './main/main_online.dart' as main_online;
import './functions/data_collection.dart' as data_collection;
import './functions/firebase_options.dart' as firebase_options;

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// UI
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Analytics
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Storing Data Internally
import 'package:device_info_plus/device_info_plus.dart';

// Reading/Opening Data Externally
import 'package:http/http.dart' as http;

// Web Alternatives
import 'package:universal_platform/universal_platform.dart';

// Core
import 'dart:core';


Key scaffoldKeyOnline = GlobalKey<ScaffoldState>();
Key scaffoldKeyOffline = GlobalKey<ScaffoldState>();

// Variables
final FlexColorScheme light = FlexColorScheme.light(scheme: FlexScheme.shark);
final FlexColorScheme dark = FlexColorScheme.dark(scheme: FlexScheme.brandBlue);

final ThemeData lightTheme = light.toTheme;
final ThemeData darkTheme = dark.toTheme;

String installedVersion = '1.2.2.2-2';
String? webVersion;

bool willInteract = false;

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
  if (UniversalPlatform.isDesktop) {
    // PLATFORM : DESKTOP
    if (kDebugMode) {
      print(
        'Current Platform : Desktop; Will NOT send : FireStore, Crashalytics and Analytics',
      );
    }
    willInteract = false;
  } else {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      // PLATFORM : NOT KNOWN YET
      // NETWORK : CONNECTED
      willInteract = true;
    } else {
      // PLATFORM : NOT KNOWN YET
      // NETWORK : NOT CONNECTED
    }
    if (UniversalPlatform.isAndroid &&
        connectivityResult != ConnectivityResult.none) {
      // PLATFORM : ANDROID WITH INTERNET
      willInteract = true;

      if (kDebugMode) {
        print(
          'Current Platform : Android; Will send : FireStore, Crashalytics and Analytics',
        );
      }
      willInteract = true;
      // SUPPORTS : FireStore, Crashalytics and Analytics
      await Firebase.initializeApp(
        options: firebase_options.DefaultFirebaseOptions.android,
      );
      // CRASHALYTICS :
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      String? userID = await _getId();
      FirebaseCrashlytics.instance.setUserIdentifier(userID!);
      // FIRESTORE :
      FirebaseFirestore.instance.settings = const Settings(
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        persistenceEnabled: true,
      );

      bool wait = await data_collection.openAppAnalytics();
      main_online.localClAvgOnline = await data_collection.readColourData();
      main_online.localTxAvgOnline = await data_collection.readTextData();
      main_offline.localClAvgOffline = await data_collection.readColourData();
      main_offline.localTxAvgOffline = await data_collection.readTextData();
      // ANALYTICS :
      var url = Uri.parse(
        'https://raw.githubusercontent.com/Pocoyo-dev/reactiontester/main/version',
      );
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
      webVersion = response.body;
      FirebaseAnalytics.instance.app.setAutomaticDataCollectionEnabled(true);
      FirebaseAnalytics.instance.app
          .setAutomaticResourceManagementEnabled(true);
    } else if (UniversalPlatform.isIOS &&
        connectivityResult != ConnectivityResult.none) {
      // PLATFORM : IOS WITH INTERNET
      // i dont have a firebase project for ios yet, dis just so i can modify my code in the future
    } else if (UniversalPlatform.isWeb &&
        connectivityResult != ConnectivityResult.none) {
      // PLATFORM : WEB
      willInteract = true;

      if (kDebugMode) {
        print(
          'Current Platform : Web; Will send : FireStore and Analytics; Will not send Crashalytics',
        );
      }
      willInteract = true;
      // SUPPORTS : FireStore and Analytics
      await Firebase.initializeApp(
        options: firebase_options.DefaultFirebaseOptions.web,
      );
      // FIRESTORE :
      // ANALYTICS :
      FirebaseAnalytics.instance.app.setAutomaticDataCollectionEnabled(true);
      FirebaseAnalytics.instance.app
          .setAutomaticResourceManagementEnabled(true);
      data_collection.openAppAnalytics();
    } else {
      // PLATFORM : UNKNOWN
      if (kDebugMode) {
        print(
          'Current Platform : Unknown; Will operate in offline mode, with persistence',
        );
      }
      await Firebase.initializeApp(
        options: firebase_options.DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseFirestore.instance.disableNetwork();
      FirebaseFirestore.instance.settings = const Settings(
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        persistenceEnabled: true,
      );
    }
  }

  int endTime = DateTime.now().millisecondsSinceEpoch;
  int loadTime = endTime - startTime;

  runApp(const materialHomePage());
  if (kDebugMode) {
    print('It took : $loadTime ms to load all async functions');
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
  @override
  Widget build(BuildContext context) {
    if (webVersion != null) {
      return const main_online.MainOnline();
    } else {
      return const main_offline.MainOffline();
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

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (UniversalPlatform.isWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    List<int> webBytes = utf8.encode(
      webInfo.browserName.toString() +
          webInfo.vendor! +
          webInfo.hardwareConcurrency!.toString() +
          webInfo.deviceMemory!.toString() +
          webInfo.userAgent!.toString(),
    );
    Digest webDigest = sha1.convert(webBytes);
    return webDigest.toString();
  } else {
    if (UniversalPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    } else if (UniversalPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else if (UniversalPlatform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId;
    }
  }
}
