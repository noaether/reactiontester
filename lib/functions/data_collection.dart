// Internal functions
import '../main.dart' as main;

// idk how to describe this part
import 'package:flutter/foundation.dart';

// Firebase Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Web problems
import 'package:universal_platform/universal_platform.dart';

import 'misc.dart' as misc;

//
// ANALYTICS : MAIN
//

int? atc = 0;
int? att = 0;

Future<bool> openAppAnalytics() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
    return false;
  } else {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    String? deviceId = await misc.getId();
    String? deviceType = await misc.getDeviceType();
    String? deviceVersion = await misc.getDeviceVersion();

    FirebaseFirestore.instance.collection('userData').doc(deviceId).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (kDebugMode) {
            print('User is already registred in DB');
          }
        } else {
          userData.doc(deviceId).set({
            'avgTimeC': 0,
            'avgTimeT': 0,
            'deviceID': deviceId,
            'deviceType': deviceType,
            'deviceVersion': deviceVersion,
          }).then(
            (value) {
              return true;
            },
          ).catchError((error) {
            return false;
          });
        }
      },
    );
    await FirebaseAnalytics.instance.logAppOpen();
    return true;
  }
}

void openColourAnalytics() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'open_colour',
    );
  }
}

void closeColourAnalytics() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'close_colour',
    );
  }
}

void openTextAnalytics() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'open_text',
    );
  }
}

void closeTextAnalytics() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'text_close',
    );
  }
}

//
// ANALYTICS : MAIN GAME
//

void correctAns() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'correct_ans',
    );
  }
}

void wrongAns() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'wrong_ans',
    );
  }
}

//
// ANALYTICS : FONT GAME
//

void newTextGenerated() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'new_text',
    );
  }
}

//
// ANALYTICS : COLOUR GAME
//

void blackAndWhiteOn() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'toggle_bw_on',
    );
  }
}

void blackAndWhiteOff() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  }
  {
    await FirebaseAnalytics.instance.logEvent(
      name: 'toggle_bw_off',
    );
  }
}

void newColourGenerated() async {
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'new_colour',
    );
  }
}

//
// DATA : WRITE TO FIRESTORE
//

void saveDataColour(int cAvg, bool isBw) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('atc', cAvg);
  } on Exception {
    rethrow;
  }
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
  } else {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    String? deviceId = await misc.getId();

    userData.doc(deviceId).update({
      'avgTimeC': cAvg,
      'isBlackAndWhite': isBw,
    }).then(
      (value) {
        if (kDebugMode) {
          print('User Data Updated');
        }
      },
    ).catchError((error) {
      if (kDebugMode) {
        print("Couldn't update user data: " + error);
      }
    });
  }
}

void saveDataText(int tAvg) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('att', tAvg);
  if ((UniversalPlatform.isWindows) || main.willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
  } else {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    String? deviceId = await misc.getId();

    userData.doc(deviceId).update({
      'avgTimeT': tAvg,
    }).then(
      (value) {
        if (kDebugMode) {
          print('User Data Updated');
        }
      },
    ).catchError(
      (error) {
        if (kDebugMode) {
          print("Couldn't update user data: " + error);
        }
      },
    );
  }
}

//
// DATA : READ FIRESTORE
//

Future<int> readColourData() async {
  if (UniversalPlatform.isWindows || main.willInteract == false) {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    return prefs.getInt('atc')!;
  } else if (UniversalPlatform.isAndroid) {
    String? deviceId = await misc.getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData'); // Get collection
    var queryData = await userData.doc(deviceId).get(); // Get user document
    Map<dynamic, dynamic>? data =
        queryData.data() as Map<dynamic, dynamic>; // Get user data
    int? queriedData = data['avgTimeC']; // Get specific data
    if (queriedData != null && queriedData != 0) {
      return queriedData;
    } else {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      return prefs.getInt('atc') ?? 0;
    }
  } else if (UniversalPlatform.isWeb) {
    String? deviceId = await misc.getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');
    var queryData = await userData.doc(deviceId).get();
    Map<dynamic, dynamic>? data = queryData.data() as Map<dynamic, dynamic>;
    int? queriedData = data['avgTimeC'];
    return queriedData!;
  } else {
    throw NoDataException();
  }
}

Future<int> readTextData() async {
  if (UniversalPlatform.isWindows || main.willInteract == false) {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    return prefs.getInt('att')!;
  } else if (UniversalPlatform.isAndroid) {
    String? deviceId = await misc.getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData'); // Get collection
    var queryData = await userData.doc(deviceId).get(); // Get user document
    Map<dynamic, dynamic>? data =
        queryData.data() as Map<dynamic, dynamic>; // Get user data
    int? queriedData = data['avgTimeT']; // Get specific data
    if (queriedData != null && queriedData != 0) {
      return queriedData;
    } else {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      return prefs.getInt('att') ?? 0;
    }
  } else if (UniversalPlatform.isWeb) {
    String? deviceId = await misc.getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');
    var queryData = await userData.doc(deviceId).get();
    Map<dynamic, dynamic>? data = queryData.data() as Map<dynamic, dynamic>;
    int? queriedData = data['avgTimeT'];
    return queriedData!;
  } else {
    throw NoDataException();
  }
}

class NoDataException implements Exception {}
