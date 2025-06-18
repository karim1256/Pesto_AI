
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/Authstates.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/PatientModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Initialize the Supabase client
//final supabase = Supabase.instance.client;

class Authcubit extends Cubit<AuthStates> {
  Authcubit() : super(InitalAuthState());
  bool? DoctorAccount;

  void Register(
    String name,
    String lastName,
    String email,
    // String phone,
    String password,
  ) async {
    emit(RegisterLoadingState());
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email, // Use the passed email parameter
        password: password, // Use the passed password parameter
        data: {
          'first_name': name, // Use the passed name parameter
          'last_name': lastName,
          'doctoraccount': DoctorAccount,
          if (DoctorAccount == true) ...{
            'certificates': null,
            'experience': null,
          } else ...{
            'pets species': null,
            'bread': null,
            'gender': null,
            'health history': null,
            'age': null,
          },
        },
      );
      final User? user = res.user;
      if (user != null) {
        // Registration successful
        DoctorAccount = null;
        emit(RegisterSucceedState());
        print(
          '-------------------------------------Registration successful for user: ${user.email}-------------------------------',
        );
      } else {
        emit(
          RegisterFailureState(
            'Registration completed but no user data returned',
          ),
        );
        print(
          '----------------------------Registration completed but no user data returned-----------------------------------------',
        );
      }

    } catch (e, stackTrace) {
      // Handle all other errors
      emit(RegisterFailureState('An unexpected error occurred'));
      print(
        '------------------------------------------Unexpected error during registration: $e\n$stackTrace--------------------------',
      );
    }
  }

  Map<String, dynamic>? userMetadata;
  void LogIn(
    String email,
    // String phone,
    String password,
  ) async {
    emit(LogInLoadingState());

    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email, // Use the passed email parameter
        password: password, // Use the passed password parameter
      );

      final User? user = res.user;

      if (user != null) {
        DoctorAccount = res.user!.userMetadata!['doctoraccount'];
        userMetadata = res.user!.userMetadata!;
        emit(LogInSucceedState());
        print(
          '-------------------------------------LogIn successful for user: ${user.email}-------------------------------',
        );

        print(
          '-------------------------------------${res.session}-------------------------------',
        );
        print(
          '-------------------------------------${res.user!.userMetadata!['doctoraccount']}-------------------------------',
        );
        print(
          '-------------------------------------User Meta data$userMetadata----------------------------------------------------',
        );
      } else {
        emit(LogInFailureState('LogIn completed but no user data returned'));
        print(
          '----------------------------LogIn completed but no user data returned-----------------------------------------',
        );
      }
   
    } catch (e, stackTrace) {
      // Handle all other errors
      emit(LogInFailureState('An unexpected error occurred'));
      print(
        '------------------------------------------Unexpected error during LogIn: $e\n$stackTrace--------------------------',
      );
    }
  }

  Future<void> sendMagicLink(String email) async {
    emit(MagicLinkLoadingState());
    try {
      await supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      emit(MagicLinkSentState());
    } on AuthException catch (e) {
      emit(MagicLinkErrorState(e.message));
    } catch (e) {
      emit(MagicLinkErrorState('حدث خطأ غير متوقع'));
    }
  }

  int index = 0;
  void onboardingNavigate() {
    index++;

    emit(OnboardingNavigateState());
  }

  List<Map> Boarding = [
    {
      "image": 'lib/Core/Assets/OnboardOnePic.png',
      "title":
          'The ability to speak and obtain medical advice with highly experienced doctors of your choice.',
    },
    {
      "image": 'lib/Core/Assets/OnboardTwoPic.png',
      "title":
          'The ability to scan and detect facial paralysis cases and their stage using artificial intelligence',
    },
    {
      "image": 'lib/Core/Assets/OnboardThreePic.png',
      "title":
          'The ability to view doctors’ experiences, certificates, and previous evaluations from other patients, which enables you to choose the most suitable doctor easily.',
    },
  ];

  Future<void> SignOut() async {
    emit(LogOutLoadingState());
    try {
      await supabase.auth.signOut();

      emit(LogOutSucceedState());
    } on AuthException catch (e) {
      emit(LogOutFailureState(e.message));
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

  List<PatientModel> pastPatients = [];
  List<String> past = [];
  Set<String> pP = {};
  Future<void> GetPastPatient() async {
    emit(PastPatientsLoadingState());
    past.clear();
    pastPatients.clear();

    await selectAllPatients();

    try {
      final response = await supabase
          .from('Sessions')
          .select('patient_id')
          .eq("doctor_id", supabase.auth.currentUser!.id)
          .eq("is_done", true);

      for (var i in response) {
        pP.add(i["patient_id"]);
      }
      past = pP.toList();

      if (true) {
        for (var i in patients) {
          if (past.contains(i.id)) {
            pastPatients.add(i);
          }
        }
      }

      print("--------------jj-----------$patients");
      print("-------------jj------------$pastPatients");

      emit(PastPatientsSucceedState());
    } catch (e) {
      emit(PastPatientsFailureState(e.toString()));
    }
  }


bool _isConnected = false;
  StreamSubscription? _connectionSubscription;

  // Add this method to your cubit
  void monitorConnection() {
    _connectionSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _isConnected = true;
      //  emit(InternetConnectedState());
      } else {
        _isConnected = false;
       // emit(InternetDisconnectedState());
      }
    } as void Function(List<ConnectivityResult> event)?);
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    return super.close();
  }





 
}



// */  Login Pesponse

// /flutter ( 3657): -------------------------------------LogIn successful for user: karim.mamdoh125@gmail.com-------------------------------
// I/flutter ( 3657): -------------------------------------Instance of 'AuthResponse'-------------------------------
// I/flutter ( 3657): -------------------------------------Session(providerToken: null, providerRefreshToken: null, expiresIn: 3600, tokenType: bearer, user: User(id: a09de97f-a676-4c06-8c3d-53517ad8a456, appMetadata: {provider: email, providers: [email]}, 
//userMetadata: {doctoraccount: true, email: karim.mamdoh125@gmail.com, email_verified: true, fisrname: karim, lastName: mamdouh, phone_verified: false, sub: a09de97f-a676-4c06-8c3d-53517ad8a456}, aud: authenticated, confirmationSentAt: 2025-04-18T20:00:45.667045Z, recoverySentAt: null, emailChangeSentAt: null, newEmail: null, invitedAt: null, actionLink: null, email: karim.mamdoh125@gmail.com, phone: , createdAt: 2025-04-18T20:00:45.633897Z, confirmedAt: 2025-04-18T20:01:09.512935Z, emailConfirmedAt: 2025-04-18T20:01:09.512935Z, phoneConfirmedAt: null, lastSignInAt: 2025-04-18T20:12:30.794438969Z, role: authenticated, updatedAt: 2025-04-18T20:12:30.799553Z, identities: [UserIdentity(id: a09de97f-a676-4c06-8c3d-53517ad8a456, userId: a09de97f-a676-4c06-8c3d-53517ad8a456, identityD
// I/flutter ( 3657): -------------------------------------User(id: a09de97f-a676-4c06-8c3d-53517ad8a456, appMetadata: {provider: email, providers: [email]}, userMetadata: {doctoraccount: true, email: karim.mamdoh125@gmail.com, email_verified: true, fisrname: karim,n  lastName: mamdouh, phone_verified: false, sub: a09de97f-a676-4c06-8c3d-53517ad8a456}, aud: authenticated, confirmationSentAt: 2025-04-18T20:00:45.667045Z, recoverySentAt: null, emailChangeSentAt: null, newEmail: null, invitedAt: null, actionLink: null, email: karim.mamdoh125@gmail.com, phone: , createdAt: 2025-04-18T20:00:45.633897Z, confirmedAt: 2025-04-18T20:01:09.512935Z, emailConfirmedAt: 2025-04-18T20:01:09.512935Z, phoneConfirmedAt: null, lastSignInAt: 2025-04-18T20:12:30.794438969Z, role: authenticated, updatedAt: 2025-04-18T20:12:30.799553Z, identities: [UserIdentity(id: a09de97f-a676-4c06-8c3d-53517ad8a456, userId: a09de97f-a676-4c06-8c3d-53517ad8a456, identityData: {doctoraccount: true, email: karim.mamdoh125@gmail.com, email_verified: true, fisrname: karim,