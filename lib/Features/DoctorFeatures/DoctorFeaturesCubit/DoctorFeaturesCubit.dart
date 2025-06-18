import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesStates.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/DoctorsModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/PatientModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class DoctorFeaturesCubit extends Cubit<DoctorFeaturesStates> {
  DoctorFeaturesCubit() : super(InitalDoctorFeaturesState());
  final supabase = Supabase.instance.client;

  Future<void> saveDoctorData({
    required String certificates,
    required String experience,
  }) async {
    emit(GetDoctorMedicalDataLoadingState());

    try {
      final UserResponse response = await supabase.auth.updateUser(
        UserAttributes(
          data: {'certificates': certificates, 'experience': experience},
        ),
      );

      if (response.user != null) {
        emit(GetDoctorMedicalDataSucceedState());
      } else {
        emit(GetDoctorMedicalDataFailureState('Failed to save doctor data'));
      }
    } catch (e) {
      emit(GetDoctorMedicalDataFailureState(e.toString()));
    }
  }

  StreamSubscription? _availableTimeSubscription;
  Set<String> date = {};

  void getDateById() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // إلغاء الاشتراك السابق (لو موجود)
    _availableTimeSubscription?.cancel();

    emit(GetAvalTimeLoadingState());

    _availableTimeSubscription = supabase
        .from('Doctors')
        .stream(
          primaryKey: ['id'],
        ) // تأكد أن "id" هو الـ primary key في جدول Doctors
        .eq('id', userId)
        .listen(
          (List<Map<String, dynamic>> data) {
            if (data.isNotEmpty) {
              final rawList = data.first['available_time'] as List<dynamic>;
              date = rawList.map((item) => item.toString()).toSet();
              emit(GetAvalTimeSucceedState());
            }
          },
          onError: (error) {
            emit(GetAvalTimeLoadingState());
          },
        );
  }

  Future<void> UpdateDataById(bool Add, value) async {
    emit(UpdateAvalTimeLoadingState());
    if (Add) {
      date.add(value);
    } else {
      date.removeWhere((i) => i == value);
    }

    try {
      await supabase
          .from('Doctors')
          .update({'available_time': date.toList()})
          .eq('id', supabase.auth.currentUser!.id);

      //    await getDateById();
      emit(UpdateAvalTimeSucceedState());
    } catch (e) {
      if (Add) {
        date.removeWhere((i) => i == value);
      } else {
        date.add(value);
      }
      emit(UpdateAvalTimeFailureState(e.toString()));
    }
  }

  int selectedDateIndex = 1;
  choiceDate(int value) {
    selectedDateIndex = value;
    emit(ChooceDateState());
  }

  int? selectedTimeIndex = 2;
  String timeString = "1:00 PM";
  choiceTime(int value, String time) {
    selectedTimeIndex = value;
    timeString = time;
    emit(ChooceTimeState());
  }

  Future<void> UpdateDoctorMedicalForAll(
    String experience,
    String cartificates,
  ) async {
    emit(UpdateDoctorMedicalLoadingState());
    final supabase = Supabase.instance.client;

    final doctor = {'experience': experience, "cartificates": cartificates};

    try {
      await supabase
          .from('Doctors')
          .update(doctor)
          .eq('id', supabase.auth.currentUser!.id);
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          data: {"experience": experience, "certificates": cartificates},
        ),
      );
      final User? user = res.user;
      emit(UpdateDoctorMedicalSucceedState());
    } catch (e) {
      emit(UpdateDoctorMedicalFailureState(e.toString()));
    }
  }

  DoctorModel? dr;
  Future<void> GetDoctorData() async {
    final supabase = Supabase.instance.client;
    emit(drDataLoadingState());
    try {
      final response = await supabase
          .from('Doctors')
          .select()
          .eq('id', supabase.auth.currentUser!.id);
      dr = DoctorModel.fromJson(response[0]);
      emit(drDataSucceedState());
    } catch (e) {
      emit(drDataFailureState(e.toString()));
      // Handle error silently
    }
  }

  List<PatientModel> patients = [];
  Set<PatientModel> patientsSet = {};
  Future<void> selectAllPatients() async {
    patients.clear();
    patientsSet.clear();
    try {
      final response = await Supabase.instance.client.from("Patients").select();

      print("--------- ALL jj---------------------: $response");
      patientsSet = response.map((item) => PatientModel.fromJson(item)).toSet();
      patients = patientsSet.toList();
      print("--------- ALL 2 jj---------------------: $patients");

      for (var p in patients) {
        print(" ALLPatient ID: ${p.id}");
        print("ALL Patient Name: ${p.first_name} ${p.last_name}");
      }
    } catch (e) {}
  }

  List<PatientModel> CalendersPatients = [];
  List<String> PatientsId = [];
  List<String> closeSessions = [];
  List<DateTime> calenderList = [];
  PatientModel? firstPatient;
  Future<void> getCalenderDates() async {
    emit(schadgleLoadingState());
    final userId = supabase.auth.currentUser?.id;
    patients.clear();
    await selectAllPatients();
    try {
      final response = await supabase
          .from('Sessions')
          .select('date,patient_id')
          .eq('doctor_id', userId!)
          .eq("is_done", false);
      closeSessions.clear();
      for (var r in response) {
        final dateStr = r["date"].toString();
        closeSessions.add(dateStr);
      }
      final closestDates = getCalenderDateList(closeSessions, list: true);
      List<String> cleanedDates =
          closestDates!.map((dateStr) {
            return DateTime.parse(dateStr).toString().split('.').first;
          }).toList();

      for (var i in cleanedDates) {
        for (var e in response) {
          if (i == e["date"]) {
            PatientsId.add(e["patient_id"]);
          }
        }
      }
      CalendersPatients.clear();
      for (var i in PatientsId) {
        for (var e in patients) {
          if (i == e.id) {
            CalendersPatients.add(e);
          }
        }
      }
      calenderList.clear();
      for (var i in closestDates) {
        calenderList.add(DateTime.parse(i));
      }

      firstPatient = CalendersPatients.first;
      emit(schadgleSucceedState());
    } catch (e) {
      emit(schadgleFailureState(e.toString()));
    }
  }

  List<String>? getCalenderDateList(List<String> dates, {bool? list}) {
    if (dates.isEmpty) {
      print('No dates provided');
      return null;
    }

    final now = DateTime.now();
    print('Current time: $now');

    final parsedDates =
        dates
            .map((e) {
              // Clean the date string first
              String cleaned = e.trim();
              print('Parsing date string: "$cleaned"');

              // Try parsing with different formats if needed
              DateTime? parsed = DateTime.tryParse(cleaned);
              if (parsed == null) {
                // Try alternative formats if the default parsing fails
                try {
                  // Example alternative format - adjust according to your actual date strings
                  parsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(cleaned);
                } catch (e) {
                  print('Failed to parse date: $cleaned');
                  return null;
                }
              }
              return parsed;
            })
            .whereType<DateTime>()
            .where((date) {
              bool isFuture = date.isAfter(now);
              print('Date: $date, isFuture: $isFuture');
              return isFuture;
            })
            .toList();

    if (parsedDates.isEmpty) {
      print('No valid future dates found');
      return null;
    }

    parsedDates.sort((a, b) => a.difference(now).compareTo(b.difference(now)));
    print('Sorted dates: $parsedDates');

    return list == null
        ? [parsedDates.first.toIso8601String()]
        : parsedDates.map((d) => d.toIso8601String()).toList();
  }

  int i = 0;
  SetDetails() {
    firstPatient = CalendersPatients[i];
    emit(UpdateMeetingDetailsgState());
  }

  DateTime? Diagnisisdate;
  Future<void> EndSession({
    required String histort,
    required String diagnosis,
    required String recomendation,
    required DateTime date,
  }) async {
    emit(SessionsResultLoadingState());
    try {
      await supabase
          .from('Sessions')
          .update({
            "history": histort,
            "diagnosis": diagnosis,
            "recommendation": recomendation,
            "is_done": true,
          })
          .eq("doctor_id", supabase.auth.currentUser!.id)
          .eq("date", DateFormat('yyyy-MM-dd HH:mm:00').format(date));
      emit(SessionsResultSucceedState());
    } catch (e) {
      emit(SessionsResultFailureState(e.toString()));
    }
  }

  // List<PatientModel> pastDoctors = [];
  // List<String> past = [];
  // Set<String> pP = {};
  // bool isError = false;
  // bool isEmpty = false;

  // Future<void> GetPastPatients() async {
  //   emit(PastPatientsLoadingState());
  //   past.clear();
  //   pastDoctors.clear();

  //   await selectAllPatients();
  //   try {
  //     final response = await supabase
  //         .from('Sessions')
  //         .select('patient_id')
  //         .eq("doctor_id", supabase.auth.currentUser!.id)
  //         .eq("is_done", true);

  //     for (var i in response) {
  //       pP.add(i["patient_id"]);
  //     }
  //     past = pP.toList();

  //     if (true) {
  //       for (var i in patients) {
  //         if (past.contains(i.id)) {
  //           pastDoctors.add(i);
  //         }
  //       }

  //       if (pastDoctors.isEmpty) {
  //         isEmpty = true;
  //       } else {
  //         isEmpty = false;
  //       }
  //     }

  //     emit(PastPatientsSucceedState());
  //   } catch (e) {
  //     isError = true;
  //     emit(PastPatientsFailureState(e.toString()));
  //   }
  // }

  List alreadBooked = [];
  Future<void> getBookedSessions() async {
    emit(alreadyBookedLoadingState());
    final userId = supabase.auth.currentUser?.id;

    alreadBooked.clear();

    try {
      supabase
          .from('Sessions')
          .stream(
            primaryKey: ['id'],
          ) // تأكد أن "id" هو الـ primary key في جدولك
          .eq('doctor_id', userId!)
          .listen((List<Map<String, dynamic>> updatedSessions) {
            print(
              "Updated Sessions: ${getClosestDateFromList(updatedSessions.map((e) => e['date']).toList(), list: true)}",
            );
            print("99999999999$updatedSessions");
            alreadBooked =
                getClosestDateFromList(
                          updatedSessions.map((e) => e['date']).toList(),
                          list: true,
                        ) ==
                        null
                    ? []
                    : getClosestDateFromList(
                          updatedSessions.map((e) => e['date']).toList(),
                          list: true,
                        )
                        as List;
            getCalenderDates();

            emit(alreadyBookedLoadingState());
          });
      emit(alreadyBookedLoadingState());
    } catch (e) {
      emit(alreadyBookedFailureState(e.toString()));
      print("❌ Error fetching sessions: ${e.toString()}");
    }
  }

  dynamic getClosestDateFromList(List dates, {bool? list}) {
    if (dates.isEmpty) return null;

    final now = DateTime.now();
    final parsedDates =
        dates
            .map((e) => DateTime.parse(e))
            .where((date) => date.isAfter(now))
            .toList();

    if (parsedDates.isEmpty) return null;

    parsedDates.sort((a, b) => a.difference(now).compareTo(b.difference(now)));

    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    if (list == true) {
      return parsedDates
          .map((d) => formatter.format(d))
          .toList(); // ✅ List<String>
    } else {
      return formatter.format(parsedDates.first); // ✅ String
    }
  }
}
