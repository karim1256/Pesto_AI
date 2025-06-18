import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Widgets/VideoCall.dart';

Timer? _timer;

List<String> SessionsDates = [];

Future<DateTime?> getClosestSessionDate(BuildContext context) async {
  String accountType =
      supabase.auth.currentUser!.userMetadata!["doctoraccount"]
          ? 'doctor_id'
          : 'patient_id';
  Set<String> sessionsDateSet = {};

  try {
    final response = await supabase
        .from('Sessions')
        .select('date')
        .eq(accountType, supabase.auth.currentUser!.id);

    print("-- Success: $response");

    for (var i in response) {
      sessionsDateSet.add(i["date"]);
    }

    SessionsDates = sessionsDateSet.toList();
    print(
      "---------------------------------------------------------Raw Sessions Dates: $SessionsDates",
    );

    // بعدما جبت الداتا، احسب أقرب ميعاد
    return getClosestDateFromList(SessionsDates,context);
  } catch (e) {
    print("-- Error: $e");
    return null;
  }
}

DateTime? closestDatee;

/// دالة تحسب أقرب ميعاد
DateTime? getClosestDateFromList(List<String> dates, BuildContext context) {
  if (dates.isEmpty) return null;

  DateTime now = DateTime.now();

  List<DateTime> parsedDates = dates.map((e) => DateTime.parse(e)).toList();

  parsedDates = parsedDates.where((date) => date.isAfter(now)).toList();

  if (parsedDates.isEmpty) return null;

  parsedDates.sort((a, b) => a.difference(now).compareTo(b.difference(now)));
  print("---------------------------------------${parsedDates.first}");
  print("---------------------------------------${parsedDates.first.month}");
  print("---------------------------------------${parsedDates.first.day}");
  print("---------------------------------------${parsedDates.first.minute}");

  closestDatee = parsedDates.first;
  startTimer(context);
  return null;
}

void startTimer(BuildContext context) {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    final now = DateTime.now();
    if (closestDatee != null && now.isAfter(closestDatee!)) {
      _navigateToPage(context);
      timer.cancel(); // Stop after navigation
    }
  });
}

void _navigateToPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  VideoCallScreen()),
  );
}
 