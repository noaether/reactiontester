import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Internal functions
import 'package:reactiontester/main.dart';

// idk how to describe this part
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

// Firebase Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Hashing for unique device ids

//
// ANALYTICS : MAIN
//

void openAppAnalytics() async {
  if ((Platform.isWindows) || willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    String? deviceId = await _getId();
    String? deviceType = await _getDeviceType();
    String? deviceVersion = await _getDeviceVersion();

    FirebaseFirestore.instance.collection('userData').doc(deviceId).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (kDebugMode) {
            print('User is already registred in DB');
          }
        } else {
          userData.doc(deviceId).set({
            'deviceID': deviceId,
            'deviceType': deviceType,
            'deviceVersion': deviceVersion,
          }).then(
            (value) {
              if (kDebugMode) {
                print('New user added to DB');
              }
            },
          ).catchError((error) {
            if (kDebugMode) {
              print("Couldn't update user data: " + error);
            }
          });
        }
      },
    );
    await FirebaseAnalytics.instance.logAppOpen();
  }
}

void openColourAnalytics() async {
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  if ((Platform.isWindows) || willInteract == false) {
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
  saveInternalColour(cAvg);
  if ((Platform.isWindows) || willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
  } else {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    String? deviceId = await _getId();

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
  saveInternalText(tAvg);
  if ((Platform.isWindows) || willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
  } else {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    String? deviceId = await _getId();

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

Future<int?> readColourData() async {
  if ((Platform.isWindows) || willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
    return null;
  } else {
    String? deviceId = await _getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    var queryData = await userData.doc(deviceId).get();
    if (queryData.data() == null) {
      throw Error();
    }
    Map<String, dynamic> data = queryData.data() as Map<String, dynamic>;
    if (data['avgTimeC'] == null) {
      throw Error();
    } else {
      return data['avgTimeC'];
    }
  }
}

class DataNotFoundException {}

Future<int?> readTextData() async {
  if ((Platform.isWindows) || willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
    return null;
  } else {
    String? deviceId = await _getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    var queryData = await userData.doc(deviceId).get();
    if (queryData.data() == null) {
      throw Error();
    }
    Map<String, dynamic> data = queryData.data() as Map<String, dynamic>;
    if (data['avgTimeT'] == null) {
      throw Error();
      // SharedPreferences? prefs = await SharedPreferences.getInstance();
      // return prefs.getInt('att');
    } else {
      return data['avgTimeT'];
    }
  }
}
//
// DATA : INTERNAL
//

void getData() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  atc = prefs.getInt('atc');
  att = prefs.getInt('att');
}

void getDataColourOffline() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  atc = prefs.getInt('atc');
}

void getDataTextOffline() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  atc = prefs.getInt('atc');
}

void getDataColourOnline() async {
  atc = await readColourData();
}

void getDataTextOnline() async {
  att = await readTextData();
}

void saveInternalColour(int avgTimeToAdd) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('atc', avgTimeToAdd);
  if (kDebugMode) {
    print('Average time : ${prefs.getInt('atc')}');
  }
}

void saveInternalText(int avgTimeToAdd) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('att', avgTimeToAdd);
  if (kDebugMode) {
    print('Average time : ${prefs.getInt('att')}');
  }
}

//
// DATA : DEVICE DATA GETTER
//

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
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
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId;
    }
  }
}

Future<String?> _getDeviceType() async {
  var deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    return webInfo.browserName.toString();
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.prettyName;
    }
  }
}

Future<String?> _getDeviceVersion() async {
  var deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    return webInfo.appVersion.toString();
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      AndroidBuildVersion ec = androidInfo.version;
      return 'Android ${ec.release}; SDK ${androidInfo.version.sdkInt}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.version;
    }
  }
}
