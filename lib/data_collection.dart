import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

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

openAppAnalytics() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    } else {
      await FirebaseAnalytics.instance.logAppOpen();
    }
  }
}

openColourAnalytics() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    } else {
      await FirebaseAnalytics.instance.logEvent(
        name: 'open_colour',
      );
    }
  }
}

closeColourAnalytics() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'close_colour',
    );
  }
}

openTextAnalytics() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'open_text',
    );
  }
}

closeTextAnalytics() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
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

correctAns() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'correct_ans',
    );
  }
}

wrongAns() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
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

newTextGenerated() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
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

blackAndWhiteOn() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send analytics");
    }
  } else {
    await FirebaseAnalytics.instance.logEvent(
      name: 'toggle_bw_on',
    );
  }
}

blackAndWhiteOff() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
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

newColourGenerated() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
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

saveDataColour(int cAvg, bool isBw) async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    } else {
      CollectionReference userData =
          FirebaseFirestore.instance.collection('userData');

      String? deviceId = await _getId();
      String? deviceType = await _getDeviceType();
      String? deviceVersion = await _getDeviceVersion();

      userData.doc(deviceId).set({
        'avgTimeC': cAvg,
        'isBlackAndWhite': isBw,
        'deviceID': deviceId,
        'deviceType': deviceType,
        'deviceVersion': deviceVersion,
      }).then(
        (value) {
          if (kDebugMode) {
            print("User Data Updated");
          }
        },
      ).catchError((error) {
        if (kDebugMode) {
          print("Couldn't update user data: " + error);
        }
      });
    }
  }
}

saveDataText(int tAvg) async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    } else {
      CollectionReference userData =
          FirebaseFirestore.instance.collection('userData');

      String? deviceId = await _getId();
      String? deviceType = await _getDeviceType();
      String? deviceVersion = await _getDeviceVersion();

      userData.doc(deviceId).set({
        'avgTimeT': tAvg,
        'deviceID': deviceId,
        'deviceType': deviceType,
        'deviceVersion': deviceVersion,
      }).then(
        (value) {
          if (kDebugMode) {
            print("User Data Updated");
          }
        },
      ).catchError((error) {
        if (kDebugMode) {
          print("Couldn't update user data: " + error);
        }
      });
    }
  }
}

//
// DATA : READ FIRESTORE
//

Future<int?> readColourData() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
    return null;
  } else {
    String? deviceId = await _getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    var queryData = await userData.doc(deviceId).get();
    Map<String, dynamic> data = queryData.data() as Map<String, dynamic>;
    return data['avgTimeC'];
  }
}

Future<int?> readTextData() async {
  if ((Platform.isAndroid == false && kIsWeb == false) ||
      willInteract == false) {
    if (kDebugMode) {
      print("Device is Desktop, can't send data");
    }
    return null;
  } else {
    String? deviceId = await _getId();
    CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');

    var queryData = await userData.doc(deviceId).get();
    Map<String, dynamic> data = queryData.data() as Map<String, dynamic>;
    return data['avgTimeT'];
  }
}
//
// DATA : INTERNAL
//

getData() async {
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
  att = await readColourData();
}

saveColourData(int avgTimeToAdd) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('atc', avgTimeToAdd);
  if (kDebugMode) {
    print('Average time : ${prefs.getInt('atc')}');
  }
}

saveTextData(int avgTimeToAdd) async {
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

Future<String?> _getDeviceVersion() async {
  var deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    return webInfo.appVersion.toString();
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
