// Internal functions
// ignore_for_file: unused_local_variable

import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart' as main;

// idk how to describe this part
import 'package:flutter/foundation.dart';

// Firebase Firestore

// Firebase Analytics
import 'package:shared_preferences/shared_preferences.dart';

// Web problems

import 'misc.dart' as misc;

//
// DATABASE : Supabase (Soupbase)
//

int? atc = 0;
int? att = 0;

void createUserData() async {
  SupabaseClient supabase = main.supabase;
  String? deviceId = await misc.getId();
  String? deviceType = await misc.getDeviceType();
  String? deviceVersion = await misc.getDeviceVersion();

  final res = await supabase.from('userData').insert(
    [
      {
        'deviceId': deviceId!,
        'deviceType': deviceType!,
        'deviceVersion': deviceVersion!,
      }
    ],
  ).execute();
}

void saveDataColour(int cAvg, bool isBw) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('atc', cAvg);
  } on Exception {
    rethrow;
  }
  if (main.willInteract) {
    SupabaseClient supabase = main.supabase;
    String? deviceId = await misc.getId();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('atc', cAvg);

    var res = await supabase.from('userData').update(
      {
        'avgTimeC': cAvg,
      },
    ).match(
      {
        'deviceId': deviceId,
      },
    ).execute();

    if (res.hasError == true && res.data) {
      if (kDebugMode) {
        print(
          'User Data Updated',
        );
      }
    } else {
      if (kDebugMode) {
        print(
          'Error Thrown while updating data' + res.error.toString(),
        );
      }
    }
  }
}

void saveDataText(int tAvg) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('att', tAvg);
  } on Exception {
    rethrow;
  }
  if (main.willInteract) {
    SupabaseClient supabase = main.supabase;
    String? deviceId = await misc.getId();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('att', tAvg);

    var res = await supabase.from('userData').update(
      {
        'avgTimeT': tAvg,
      },
    ).match(
      {
        'deviceId': deviceId,
      },
    ).execute();

    if (res.status == 200) {
      if (kDebugMode) {
        print(
          'User Data Updated',
        );
      }
    } else {
      if (kDebugMode) {
        print(
          'Error Thrown while updating data' + res.error.toString(),
        );
      }
    }
  }
}

Future<int> readColourData() async {
  if (main.willInteract) {
    SupabaseClient supabase = main.supabase;
    try {
      String? deviceId = await misc.getId();
      final res = await supabase
          .from('userData')
          .select('avgTimeC')
          .match({'deviceId': deviceId}).execute();
      if (res.status == 200) {
        Map<String, dynamic> queriedData = res.toJson();
        List<dynamic> queriedIterable = queriedData.values.toList();
        String stringJson = ((queriedIterable[0])[0]).toString();
        String intAsString =
            stringJson.replaceAll('{avgTimeC: ', '').replaceAll('}', '');
        int pureInt = int.parse(intAsString);
        return pureInt;
      } else {
        SharedPreferences? prefs = await SharedPreferences.getInstance();
        return prefs.getInt('atc') ?? 0;
      }
    } on Exception {
      return 0;
    }
  } else {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    return prefs.getInt('atc') ?? 0;
  }
}

Future<int> readTextData() async {
  if (main.willInteract) {
    SupabaseClient supabase = main.supabase;
    try {
      String? deviceId = await misc.getId();
      final res = await supabase
          .from('userData')
          .select('avgTimeT')
          .match({'deviceId': deviceId}).execute();
      if (kDebugMode) {
        print(res.hasError);
      }
      if (res.status == 200) {
        Map<String, dynamic> queriedData = res.toJson();
        List<dynamic> queriedIterable = queriedData.values.toList();
        String stringJson = ((queriedIterable[0])[0]).toString();
        String intAsString =
            stringJson.replaceAll('{avgTimeT: ', '').replaceAll('}', '');
        int pureInt = int.parse(intAsString);
        return pureInt;
      } else {
        SharedPreferences? prefs = await SharedPreferences.getInstance();
        return prefs.getInt('att') ?? 0;
      }
    } on Exception {
      return 0;
    }
  } else {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    return prefs.getInt('att') ?? 0;
  }
}

//
// ANALYTICS : Mixpanel
//

void openAppAnalytics() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'appOpen',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
  var result1 = await main.mixpanel!.track(
    event: '$deviceOs',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void openColourAnalytics() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'colourOpen',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void closeColourAnalytics() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'colourClose',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void openTextAnalytics() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'textOpen',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void closeTextAnalytics() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'textClose',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

//
// ANALYTICS : MAIN GAME
//

void correctAns() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'correctAns',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void wrongAns() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'wrongAns',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

//
// ANALYTICS : FONT GAME
//

void newTextGenerated() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'newText',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

//
// ANALYTICS : COLOUR GAME
//

void blackAndWhiteOn() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'changeBw',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void blackAndWhiteOff() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'changeBw',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}

void newColourGenerated() async {
  if (main.willInteract != true) {
    return;
  }
  String? deviceId = await misc.getId();
  String? deviceOs = await misc.getDeviceOs();
  var result = await main.mixpanel!.track(
    event: 'newColour',
    properties: {'\$os': deviceOs, 'distinct_id': deviceId},
    time: DateTime.now(),
  );
}
