import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/DoctorsModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/PatientModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/SessionModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientFeaturesCubit extends Cubit<PatientFeaturesStates> {
  PatientFeaturesCubit() : super(InitalPatientFeaturesState());

  void GetPatientMedicalData({
    required String species,
    required String gender,
    required String breed,
    required String history,
    required int age,
  }) async {
    emit(GetPatientMedicalDataLoadingState());
    await insertPatientToBackend(
      species: species,
      gender: gender,
      breed: breed,
      history: history,
      age: age,
    );
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'pets_species': species,
            "bread": breed,
            "gender": gender,
            "health_history": history,
            "age": age,
            "premium_account": false,
            "date_of_subscribe": null,
          },
        ),
      );
      final User? user = res.user;

      if (user != null) {
        emit(GetPatientMedicalDataSucceedState());
      } else {
        emit(
          GetPatientMedicalDataFailureState(
            'LogIn completed but no user data returned',
          ),
        );
      }
    } catch (e) {
      emit(GetPatientMedicalDataFailureState('An unexpected error occurred'));
    }
  }

  Future<void> insertPatientToBackend({
    required String species,
    required String gender,
    required String breed,
    required String history,
    required int age,
  }) async {
    final supabase = Supabase.instance.client;

    final Patient = {
      'id': supabase.auth.currentUser!.id,
      'email': supabase.auth.currentUser!.email,
      'species': species,
      "breed": breed,
      "gender": gender,
      "history": history,
      "age": age,
      'first_name': supabase.auth.currentUser?.userMetadata!['first_name'],
      'last_name': supabase.auth.currentUser?.userMetadata!['last_name'],
    };

    try {
      await supabase.from('Patients').insert(Patient);
    } catch (e) {
      // Handle error silently
    }
  }

  List<DoctorModel> doctors = [];
  Future<void> selectAllDoctors(bool clear) async {
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (supabase.auth.currentUser!.userMetadata!["premium_account"]) {
      isDateOlderThanOneMonth(
        DateTime.parse(
          supabase.auth.currentUser!.userMetadata!["date_of_subscribe"],
        ),
      );
    }
    clear ? doctors.clear() : null;
    emit(GetDoctorDataLoadingState());
    await GetPatientFavourite();
    try {
      final response = await Supabase.instance.client.from("Doctors").select();
      Set<DoctorModel> dr = {};
      for (var item in response) {
        dr.add(DoctorModel.fromJson(item));
      }
      doctors = dr.toList();
      await GetPastDoctors();
      emit(GetDoctorDataSucceedState());
    } catch (e) {
      emit(GetDoctorDataFailureState(e.toString()));
      rethrow;
    }
  }

  late List<DoctorModel> Search = doctors;
  void SearchDoctor(String input) {
    Search =
        doctors
            .where((i) => i.name.toLowerCase().contains(input.toLowerCase()))
            .toList();

    if (Search.isEmpty && input.isNotEmpty) {
      emit(SearchfaildState());
    } else if (Search.isNotEmpty && input.isNotEmpty) {
      emit(SearchSucceedState());
    } else {
      Search = doctors;
      emit(SearchInitialState());
    }
  }

  List Is_Favourite = [];
  Future<void> GetPatientFavourite() async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('Patients')
              .select('favourite_doctors')
              .eq('id', supabase.auth.currentUser!.id)
              .single();
      Is_Favourite = response['favourite_doctors'] as List;
    } catch (e) {
      // Handle error silently
    }
  }

  AddOrDeleteFavourite(String id) async {
    final supabase = Supabase.instance.client;
    if (Is_Favourite.contains(id)) {
      Is_Favourite.remove(id);
    } else {
      Is_Favourite.add(id);
    }
    emit(LocalFavouriteUpdateState());

    try {
      await supabase
          .from('Patients')
          .update({'favourite_doctors': Is_Favourite})
          .eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      if (Is_Favourite.contains(id)) {
        Is_Favourite.remove(id);
      } else {
        Is_Favourite.add(id);
      }
      emit(FavouriteUpdateFailureState('Error While updating favourite'));
    }
  }

  bool readmoreExpariance = false;
  void readMorereadmoreExpariance() {
    readmoreExpariance = !readmoreExpariance;
    emit(ReadMoreExparianceState());
  }

  bool readmoreCartificates = false;
  void readMorereadCartificates() {
    readmoreCartificates = !readmoreCartificates;
    emit(ReadMoreCartificatesState());
  }

  List<bool> isExpanded = [];
  List<bool> generateFalseList(int count) {
    isExpanded = List<bool>.filled(count, false);
    return List<bool>.generate(count, (index) => false);
  }

  void expandSession(int index) {
    isExpanded[index] = !isExpanded[index];
    emit(ExpandSessionState());
  }

  List<SessionModel> sessions = [];
  PatientModel? patient;
  Future<void> selectAllSession() async {
    try {
      final response = await Supabase.instance.client
          .from("Sessions")
          .select()
          .filter(
            "patient_id",
            'eq',
            patient == null ? supabase.auth.currentUser!.id : patient!.id,
          )
          .eq("is_done", true);
      generateFalseList(response.length);
      sessions = response.map((item) => SessionModel.fromJson(item)).toList();
      emit(GetSessionsSucceedState());
      print("Sessions: $sessions");
    } catch (e) {
      print("Error sessions: $e");
      emit(GetSessionsfaildState(e.toString()));
    }
  }

  DoctorModel GetDoctor(String? id) {
    return doctors.where((element) => element.id == id).first;
  }

  bool ProfileState = false;
  bool MedicalState = false;

  void EditPatientMedicalInfoLogic(
    String initialValue,
    String? NewValue,
    bool isMedical,
  ) {
    if (initialValue == NewValue) {
      if (isMedical) {
        MedicalState = false;
        emit(ConstMedicalState());
      } else {
        ProfileState = false;
        emit(ConstProfileState());
      }
    } else {
      if (isMedical) {
        MedicalState = true;
        emit(changedMedicalState());
      } else {
        ProfileState = true;
        emit(changedProfileState());
      }
    }
  }

  Future<void> UpdatePatientProfileForAll(
    String firstName,
    String lastName,
  ) async {
    emit(UpdatePatientProfileLoadingState());
    final supabase = Supabase.instance.client;

    final Patient = {
      'id': supabase.auth.currentUser!.id,
      'first_name': firstName,
      'last_name': lastName,
    };

    try {
      await supabase
          .from('Patients')
          .update(Patient)
          .eq('id', supabase.auth.currentUser!.id);
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(data: {'first_name': firstName, 'last_name': lastName}),
      );
      final User? user = res.user;
      emit(UpdatePatientProfileSucceedState());
      ProfileState = false;
    } catch (e) {
      emit(UpdatePatientProfileFailureState(e.toString()));
    }
  }

  Future<void> UpdatePatientMedicalForAll(
    String species,
    String gender,
    String breed,
    String history,
    int age,
  ) async {
    emit(UpdatePatientMedicalLoadingState());
    final supabase = Supabase.instance.client;

    final Patient = {
      'id': supabase.auth.currentUser!.id,
      'species': species,
      "breed": breed,
      "gender": gender,
      "history": history,
      "age": age,
    };

    try {
      await supabase
          .from('Patients')
          .update(Patient)
          .eq('id', supabase.auth.currentUser!.id);
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'pets species': species,
            "bread": breed,
            "gender": gender,
            "health history": history,
            "age": age,
          },
        ),
      );
      final User? user = res.user;
      emit(UpdatePatientMedicalSucceedState());
    } catch (e) {
      emit(UpdatePatientMedicalFailureState(e.toString()));
    }
  }

  Set<String> AvLDrDates = {};
  StreamSubscription? _doctorAvailabilitySubscription;
  StreamSubscription? _sessionsSubscription;

  void disposeSubscriptions() {
    _doctorAvailabilitySubscription?.cancel();
    _sessionsSubscription?.cancel();
  }

  Future<void> getDateById(String id) async {
    emit(PatientGetBookingLoadingState());

    // Cancel previous subscription if exists
    _doctorAvailabilitySubscription?.cancel();

    try {
      // Set up real-time subscription for doctor's availability
      _doctorAvailabilitySubscription = supabase
          .from('Doctors')
          .stream(primaryKey: ['id'])
          .eq('id', id)
          .listen(
            (data) async {
              if (data.isNotEmpty) {
                selectedDateIndex = 0;
                final response = data[0];
                final List rawList = response['available_time'] ?? [];
                AvLDrDates = rawList.map((item) => item.toString()).toSet();
                await getSessionsById(id);
              }
            },
            onError: (e) {
              emit(PatientGetBookingFailureState(e.toString()));
            },
          );

      // Initial fetch
      final initialResponse =
          await supabase
              .from('Doctors')
              .select('available_time')
              .eq('id', id)
              .single();

      final List<String> rawList = initialResponse['available_time'];
      AvLDrDates = rawList.map((item) => item.toString()).toSet();
      await getSessionsById(id);
    } catch (e) {
      emit(PatientGetBookingFailureState(e.toString()));
    }
  }

  List<String> SessionsDates = [];
  List<String> PatientAvlDatas = [];

  Future<void> getSessionsById(String id) async {
    Set<String> SessionsDate = {};

    // Cancel previous subscription if exists
    _sessionsSubscription?.cancel();

    try {
      // Set up real-time subscription for sessions
      _sessionsSubscription = supabase
          .from('Sessions')
          .stream(primaryKey: ['id'])
          .eq('doctor_id', id)
          //  .eq('is_done', false)
          .listen(
            (response) {
              selectedDateIndex = 0;

              SessionsDate.clear();
              for (var i in response) {
                SessionsDate.add(i["date"]);
              }
              SessionsDates = SessionsDate.toList();
              updateAvailableDates();
            },
            onError: (e) {
              emit(PatientGetBookingFailureState(e.toString()));
            },
          );

      // Initial fetch
      final initialResponse = await supabase
          .from('Sessions')
          .select('date')
          .eq('doctor_id', id)
          .eq('is_done', false);

      for (var i in initialResponse) {
        SessionsDate.add(i["date"]);
      }

      SessionsDates = SessionsDate.toList();
      updateAvailableDates();
    } catch (e) {
      emit(PatientGetBookingFailureState(e.toString()));
    }
  }

  void updateAvailableDates() {
    print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;$PatientAvlDatas");
    selectedDateIndex = 0;
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);

    PatientAvlDatas =
        AvLDrDates.toSet().difference(SessionsDates.toSet()).where((dateStr) {
          try {
            final dateTime = DateTime.parse(dateStr);
            return dateTime.isAfter(
              now.subtract(Duration(minutes: 1)),
            ); // Keep dates in future
          } catch (e) {
            return false; // Remove invalid dates
          }
        }).toList();
    Set<String> p = PatientAvlDatas.toSet();
    PatientAvlDatas = p.toList();
    print("0000000000000000000000000$PatientAvlDatas");
    splitDateTimeParts(PatientAvlDatas);
  }

  List<String> years = [];
  List<String> months = [];
  List<String> days = [];
  List<String> hours = [];
  List<String> minutes = [];
  List<String> seconds = [];
  void splitDateTimeParts(List<String> dateTimeStrings) {
    years.clear();
    months.clear();
    days.clear();
    hours.clear();
    minutes.clear();
    seconds.clear();

    for (var dateTime in PatientAvlDatas) {
      if (dateTime.length >= 19) {
        try {
          // Validate date format
          DateTime.parse(dateTime);
          years.add(dateTime.substring(0, 4));
          months.add(dateTime.substring(5, 7));
          days.add(dateTime.substring(8, 10));
          hours.add(dateTime.substring(11, 13));
          minutes.add(dateTime.substring(14, 16));
          seconds.add(dateTime.substring(17, 19));
        } catch (e) {
          // Skip invalid date formats
          continue;
        }
      }
    }
    prepareSlots();
  }

  final List<String> afternoonSlots = [];
  final List<String> eveningSlots = [];

  void prepareSlots() {
    afternoonSlots.clear();
    eveningSlots.clear();
    Map<String, List<String>> groupedSlots = {};
    final now = DateTime.now();

    for (int i = 0; i < years.length; i++) {
      try {
        String year = years[i].toString();
        String month = months[i].toString().padLeft(2, '0');
        String day = days[i].toString().padLeft(2, '0');
        String hour = hours[i].toString().padLeft(2, '0');
        String minute = minutes[i].toString().padLeft(2, '0');
        String second = seconds[i].toString().padLeft(2, '0');

        String key = '$year-$month-$day';
        String timeString = '$hour:$minute:$second';

        // Check if the slot is in the future
        final slotDateTime = DateTime.parse('$key $timeString');
        if (slotDateTime.isBefore(now)) {
          continue; // Skip past slots
        }

        if (!groupedSlots.containsKey(key)) {
          groupedSlots[key] = [];
        }
        groupedSlots[key]!.add(timeString);
      } catch (e) {
        // Skip invalid date/time combinations
        continue;
      }
    }

    groupedSlots.forEach((key, times) {
      for (var time in times) {
        int hour = int.parse(time.split(":")[0]);
        if (hour < 17) {
          afternoonSlots.add('$key $time');
        } else {
          eveningSlots.add('$key $time');
        }
      }
    });

    emit(PatientGetBookingSucceedState());
  }

  int? selectedDateIndex = 0;
  int? selectedTimeIndex;
  void choiceDate(int index) {
    selectedDateIndex = index;
    selectedTimeIndex = null;
    emit(ChoiceDateState());
  }

  void choiceTime(int index) {
    selectedTimeIndex = index;
    emit(ChoiceTimeState());
  }

  Future<void> BookMedicalSession({
    required String doctorId,
    required String patientId,
    required String? history,
    required String? diagnosis,
    required String? recommendation,
    required String date,
  }) async {
    emit(PatientBookingLoadingState());
    try {
      await Supabase.instance.client.from('Sessions').insert({
        'doctor_id': doctorId,
        'patient_id': patientId,
        'history': history,
        'diagnosis': diagnosis,
        'recommendation': recommendation,
        'date': date,
      }).select();
      emit(PatientBookingSucceedState());
    } catch (e) {
      emit(PatientBookingFailureState(e.toString()));
    }
  }

  bool Nav = false;
  void Navigate() {
    Nav = !Nav;
    emit(NavigateState());
  }

  int selectedTab = 0;
  void handleIndexChanged(int i) {
    selectedTab = i;
    emit(NavigateState());
  }

  DateTime? closeSession;
  StreamSubscription? _sessionSubscription;

  Future<void> getClosestSessionDate() async {
    emit(CloseSessionLoadingState());

    // Cancel previous subscription if it exists
    _sessionSubscription?.cancel();

    final accountType =
        supabase.auth.currentUser?.userMetadata?["doctoraccount"] == true
            ? 'doctor_id'
            : 'patient_id';

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Initial fetch
      final response = await supabase
          .from('Sessions')
          .select('date')
          .eq(accountType, userId);

      updateCloseSession(response);

      // Set up realtime subscription
      _sessionSubscription = supabase
          .from('Sessions')
          .stream(primaryKey: ['id'])
          .eq(accountType, userId)
          .listen((List<Map<String, dynamic>> data) async {
            updateCloseSession(data);
          });

      emit(CloseSessionSucceedState());
    } catch (e) {
      emit(CloseSessionFailureState(e.toString()));
    }
  }

  Future<void> updateCloseSession(List<dynamic> response) async {
    //var cubit = BlocProvider.of<PatientFeaturesCubit>(Context, listen: false);

    supabase.auth.currentUser?.userMetadata!["doctoraccount"]
        ? await DoctorFeaturesCubit().getCalenderDates()
        : await getCalenderDates();
    print("-----------------------------------------------upate dates");
    final sessionsDates = response.map((e) => e['date'] as String).toList();
    closeSession = getClosestDateFromList(sessionsDates);

    emit(CloseSessionSucceedState()); // Re-emit state to update UI
  }

  getClosestDateFromList(List<String> dates, {bool? list}) {
    if (dates.isEmpty) return;

    final now = DateTime.now();
    final parsedDates =
        dates
            .map((e) => DateTime.parse(e))
            .where((date) => date.isAfter(now))
            .toList();

    if (parsedDates.isEmpty) return;

    parsedDates.sort((a, b) => a.difference(now).compareTo(b.difference(now)));
    return list == null ? parsedDates.first : parsedDates;
  }

  String count = "";
  Timer? _timer;
  bool isSessionStarted = false;
  void startTimer() {
    isSessionStarted = false;
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      if (!isSessionStarted && closeSession != null) {
        final diff = closeSession!.difference(now);

        if (diff.isNegative || diff.inSeconds <= 0) {
          isSessionStarted = true;
          _timer?.cancel();
          emit(UpdateCountState());

          isSessionStarted = true;
          startOneHourTimer();
          return;
        } else {
          count = _formatDuration(diff);
        }

        emit(UpdateCountState());
      }
    });
  }

  void startOneHourTimer() {
    DateTime endTime = DateTime.now().add(Duration(minutes: 1));

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final now = DateTime.now();
      final diff = endTime.difference(now);

      if (diff.isNegative || diff.inSeconds <= 0) {
        _timer?.cancel();
        isSessionStarted = false;
        await getClosestSessionDate();
        startTimer();
        emit(EndMeetingState());
      } else {
        count = _formatDuration(diff);
        emit(UpdateCountState());
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void dispose() {
    _timer?.cancel();
  }

  bool MeetingButton = false;
  void setMeetingButtonState(bool value) {
    MeetingButton = value;
    emit(UpdateMeetingButtonState());
  }

  List<DoctorModel> CalendersDoctors = [];
  List<String> Doctor = [];
  List<String> closeSessions = [];
  List<DateTime> calenderList = [];
  Future<void> getCalenderDates() async {
    final accountType =
        supabase.auth.currentUser?.userMetadata?["doctoraccount"] == true
            ? 'doctor_id'
            : 'patient_id';

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // doctors.clear();
    await selectAllDoctors(false);
    Set<DoctorModel> d = doctors.toSet();
    try {
      final response = await supabase
          .from('Sessions')
          .select('date,doctor_id')
          .eq(accountType, userId)
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
            Doctor.add(e["doctor_id"]);
          }
        }
      }
      CalendersDoctors.clear();
      for (var i in Doctor) {
        for (var e in d) {
          if (i == e.id) {
            CalendersDoctors.add(e);
          }
        }
      }
      calenderList.clear();
      for (var i in closestDates) {
        calenderList.add(DateTime.parse(i));
      }
      DoctorDetails = CalendersDoctors.first;
      emit(GetCalenderDatesSucceedState());
    } catch (e) {
      // Handle error silently
    }
  }

  List<String>? getCalenderDateList(List<String> dates, {bool? list}) {
    if (dates.isEmpty) return null;

    final now = DateTime.now();
    final parsedDates =
        dates
            .map((e) => DateTime.tryParse(e))
            .whereType<DateTime>()
            .where((date) => date.isAfter(now))
            .toList();

    if (parsedDates.isEmpty) return null;

    parsedDates.sort((a, b) => a.difference(now).compareTo(b.difference(now)));

    return list == null
        ? [parsedDates.first.toIso8601String()]
        : parsedDates.map((d) => d.toIso8601String()).toList();
  }

  DoctorModel? DoctorDetails;
  int i = 0;
  SetDetails() {
    DoctorDetails = CalendersDoctors[i + 1];
    emit(UpdateDoctorDetailsState());
  }

  List raviews = [];
  List rateing = [];
  Future<void> RateDoctor(String raview, double rate) async {
    emit(AddRateingLoadingState());

    try {
      final responsee = await supabase
          .from('Doctors')
          .select("raviews,rateing")
          .eq("id", CalendersDoctors.first.id);

      rateing = responsee[0]["rateing"] as List;
      raviews = responsee[0]["raviews"] as List;

      rateing.add(rate);
      raviews.add(raview);

      await supabase
          .from('Doctors')
          .update({"rateing": rateing, "raviews": raviews})
          .eq("id", CalendersDoctors.first.id);

      emit(AddRateingSucceedState());
    } catch (e) {
      emit(AddRateingFailureState(e.toString()));
    }
  }

  bool load = false;
  bool seccuss = false;
  bool faild = false;
  List<String> PastDoctorsId = [];
  List<DoctorModel> PastDoctors = [];
  Future<void> GetPastDoctors() async {
    load = true;
    emit(AddRateingSucceedState());

    PastDoctors.clear();
    PastDoctorsId.clear();

    try {
      final response = await supabase
          .from('Sessions')
          .select('doctor_id')
          .eq("patient_id", supabase.auth.currentUser!.id)
          .eq("is_done", true);

      for (var r in response) {
        PastDoctorsId.add(r["doctor_id"]);
      }

      Set<DoctorModel> dr = {};
      for (var d in doctors) {
        if (PastDoctorsId.contains(d.id)) {
          dr.add(d);
        }
      }
      PastDoctors = dr.toList();
      load = false;
      seccuss = true;
      emit(AddRateingSucceedState());
    } catch (e) {
      load = false;
      faild = true;
      emit(AddRateingSucceedState());

      // Handle error silently
    }
  }

  XFile? pickedImage;
  String? imageUrl;

  setImageUrl(String? url) {
    imageUrl = url;
    emit(ImageFatchedState());
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = image;
      emit(ImagePickedState());
      await ImageSure(image);
    }
  }

  Future<void> viewImage(String imageUrl, BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (_) =>
              Dialog(child: InteractiveViewer(child: Image.network(imageUrl))),
    );
  }

  Future<void> deleteImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final metadata = user.userMetadata ?? {};
    final isDoctor = metadata["doctoraccount"] == true;
    final tableName = isDoctor ? "Doctors" : "Patients";

    final response = await Supabase.instance.client
        .from(tableName)
        .select("image")
        .eq("id", user.id);

    if (response.isNotEmpty && response[0]["image"] != null) {
      final image = response[0]["image"];
      final imagePath = Uri.decodeFull(
        Uri.parse(image).pathSegments
            .skipWhile((value) => value != "profile")
            .skip(1)
            .join("/"),
      );

      try {
        await Supabase.instance.client.storage.from("profile").remove([
          imagePath,
        ]);
        await Supabase.instance.client
            .from(tableName)
            .update({"image": null})
            .eq("id", user.id);

        pickedImage = null;
        imageUrl = null;
        emit(ImageDeletedState());
      } catch (e) {
        // Handle error silently
      }
    }
  }

  Future<void> ImageSure(XFile? imageFile) async {
    if (imageFile == null) return;

    String oldImage = "";
    final tableName =
        supabase.auth.currentUser!.userMetadata!["doctoraccount"]
            ? "Doctors"
            : "Patients";

    final response = await Supabase.instance.client
        .from(tableName)
        .select("image")
        .eq("id", supabase.auth.currentUser!.id);

    if (response.isNotEmpty && response[0]["image"] != null) {
      oldImage = response[0]["image"];
      final imagePath = Uri.decodeFull(
        Uri.parse(oldImage).pathSegments
            .skipWhile((value) => value != "profile")
            .skip(1)
            .join("/"),
      );

      try {
        await Supabase.instance.client.storage.from("profile").remove([
          imagePath,
        ]);
      } catch (e) {
        // Handle error silently
      }
    }

    final folderName =
        tableName == "Doctors" ? "doctors-profile" : "patients-profile";
    final fileName = '$folderName/${DateTime.now().toIso8601String()}.jpg';

    final bytes = await imageFile.readAsBytes();
    if (bytes.isEmpty) return;

    try {
      await Supabase.instance.client.storage
          .from("profile")
          .uploadBinary(fileName, bytes);
      final newImageUrl = Supabase.instance.client.storage
          .from("profile")
          .getPublicUrl(fileName);
      await saveImageUrlToDatabase(newImageUrl);
      imageUrl = newImageUrl;
      emit(ImageUploadedState());
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> saveImageUrlToDatabase(String imageUrl) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final metadata = user.userMetadata ?? {};
    final isDoctor = metadata["doctoraccount"] == true;
    final tableName = isDoctor ? "Doctors" : "Patients";

    try {
      await Supabase.instance.client
          .from(tableName)
          .update({"image": imageUrl})
          .eq("id", user.id);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchImageUrl() async {
    final s = supabase.auth.currentUser?.userMetadata;
    final user = supabase.auth.currentUser;

    if (s != null && user != null) {
      final table = s["doctoraccount"] == true ? "Doctors" : "Patients";
      final result = await Supabase.instance.client
          .from(table)
          .select("image")
          .eq("id", user.id);

      if (result.isNotEmpty && result[0]["image"] != null) {
        imageUrl = result[0]["image"];
      } else {
        imageUrl = null;
      }
      emit(ImageFatchedState());
    }
  }

  void premiumAccount(bool premiumaccount) async {
    emit(PremiumAccountLoadingState());
    print(DateTime.now().toString());
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          data: {
            "premium_account": premiumaccount,
            "date_of_subscribe": DateTime.now().toString(),
          },
        ),
      );

      emit(PremiumAccountSucceedState());
    } catch (e) {
      emit(PremiumAccountFailureState('An unexpected error occurred'));
    }
  }

  // Function to check if a date is older than one month

  void isDateOlderThanOneMonth(DateTime inputDate) {
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    inputDate.isBefore(oneMonthAgo) ? premiumAccount(false) : null;
  }

  Future<void> pickImageAndPredict() async {
    final picker = ImagePicker();
    bool isPicking = false; // Add a flag to track if picking is in progress

    try {
      if (isPicking) return; // If already picking, exit
      isPicking = true;

      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await postImageForPrediction(imageFile);
      } else {
        print('00000000000000000 No image selected.');
      }
    } catch (e) {
      print('000000000000000000000Error picking image: $e');
    } finally {
      isPicking = false;
    }
  }

  //'http://192.168.1.5:5000/api/v1/predict'

  Map<String, dynamic> result = {};
  Future<void> postImageForPrediction(File imageFile) async {
    emit(ModelLoadingState());
    print('00000000000000000000000000start');

    var uri = Uri.parse('http://172.20.10.3:5000/api/v1/predict');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        result = jsonResponse["prediction"];
        print(result);
        emit(ModelSucceedState());
        print(
          '00000000000000000000000000Prediction class: ${jsonResponse["prediction"]["class"]}',
        );
        print(
          '00000000000000000Confidence: ${jsonResponse["prediction"]["confidence"]}',
        );
      } else {
        emit(
          ModelFailureState(
            'Request failed with status: ${response.statusCode}',
          ),
        );
        print(
          '000000000000000000000000000Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      emit(ModelFailureState(e.toString()));
      print('000000000000000000000000Error occurred: $e');
    }
  }

  Timer? _paymentTimer;
  String paymentCount = ""; // Initialize with default value

  void startPaymentTimer() {
    // Always cancel any existing timer first
    _paymentTimer?.cancel();

    // Safely get user data
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.userMetadata == null) {
      paymentCount = "No user";
      emit(UpdatePaymentCountState());
      return;
    }

    // Safely get subscription date
    final subscribeDate = user.userMetadata!["date_of_subscribe"];
    if (subscribeDate == null) {
      paymentCount = "No date";
      emit(UpdatePaymentCountState());
      return;
    }

    DateTime subscriptionEnd;
    try {
      // Parse the date - this depends on how it's stored in Supabase
      subscriptionEnd = DateTime.parse(
        subscribeDate.toString(),
      ).add(Duration(days: 30));
    } catch (e) {
      paymentCount = "Invalid date";
      emit(UpdatePaymentCountState());
      return;
    }

    // Start the timer
    _paymentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remaining = subscriptionEnd.difference(now);

      if (remaining.isNegative || remaining.inSeconds <= 0) {
        timer.cancel();
        paymentCount = "Expired";
        //  emit(SubscriptionExpiredState());
      } else {
        paymentCount = formatDuration(remaining);
        emit(UpdatePaymentCountState());
      }
    });

    // Initial update
    final initialRemaining = subscriptionEnd.difference(DateTime.now());
    paymentCount = _formatDuration(initialRemaining);
    emit(UpdatePaymentCountState());
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$days:$hours:$minutes:$seconds';
  }

  // @override
  // void dispose() {
  //   _paymentTimer?.cancel();
  //   super.dispose();
  // }
  bool Connected = true;
  void isConnected(bool value, BuildContext context) {
    Connected = value;
    handleIndexChanged(0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage())
    );
    emit(wifiUpdatedState());
  }
}
