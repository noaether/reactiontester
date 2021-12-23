// ignore_for_file: camel_case_types

// Internal files
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './main/main_offline.dart' as main_offline;
import './main/main_online.dart' as main_online;
import './functions/misc.dart' as misc;
import 'functions/data_collection_soupmix.dart' as data_collection_soupmix;

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// UI
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Analytics
import 'package:mixpanel_analytics/mixpanel_analytics.dart';
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Storing Data Internally
import 'package:device_info_plus/device_info_plus.dart';

// Reading/Opening Data Externally
import 'package:http/http.dart' as http;

// Web Alternatives
import 'package:universal_platform/universal_platform.dart';

// ParsePlatform

// Core
import 'dart:core';

Key scaffoldKeyOnline = GlobalKey<ScaffoldState>();
Key scaffoldKeyOffline = GlobalKey<ScaffoldState>();

// Variables
final FlexColorScheme light = FlexColorScheme.light(scheme: FlexScheme.shark);
final FlexColorScheme dark = FlexColorScheme.dark(scheme: FlexScheme.brandBlue);

final ThemeData lightTheme = light.toTheme;
final ThemeData darkTheme = dark.toTheme;

late SupabaseClient supabase;
late String? deviceId;
MixpanelAnalytics? mixpanel;

String installedVersion = '1.2.2.2-2';
String? webVersion;

bool willInteract = false;

void main() async {
  await dotenv.load(fileName: '.env');
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

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    // NETWORK : TRUE
    willInteract = true;
  }

  supabase = SupabaseClient(
    dotenv.env['SOUPURL']!,
    dotenv.env['SOUPKEY']!,
  );

  deviceId = await misc.getId();
  data_collection_soupmix.createUserData();

  int endTime = DateTime.now().millisecondsSinceEpoch;
  int loadTime = endTime - startTime;

  main_online.localClAvgOnline = await data_collection_soupmix.readColourData();
  main_online.localTxAvgOnline = await data_collection_soupmix.readTextData();
  main_offline.localClAvgOffline =
      await data_collection_soupmix.readColourData();
  main_offline.localTxAvgOffline = await data_collection_soupmix.readTextData();

  var url = Uri.parse(
    'https://raw.githubusercontent.com/Pocoyo-dev/reactiontester/main/version',
  );
  final response = await http.get(url, headers: {'Accept': 'application/json'});
  webVersion = response.body;

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
  final _user$ = StreamController<String>.broadcast();
  // ignore: unused_field
  Object? _error;
  // ignore: unused_field
  String? _success;

  @override
  void initState() {
    super.initState();

    mixpanel = MixpanelAnalytics(
      token: dotenv.env['MIXKEY']!,
      userId$: _user$.stream,
      verbose: true,
      useIp: true,
      shouldAnonymize: false,
      shaFn: (value) => value,
      onError: (e) => setState(() {
        _error = e;
        _success = null;
      }),
    );

    _user$.add(deviceId!);
  }

  @override
  void dispose() {
    _user$.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data_collection_soupmix.openAppAnalytics();
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

// ignore: unused_element
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
