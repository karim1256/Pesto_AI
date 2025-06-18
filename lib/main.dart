import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/LocalNetwork/LocalNetwork.dart';
import 'package:gradutionproject/Core/Widgets/VideoCall.dart';
import 'package:gradutionproject/Core/Widgets/VideoCall/SessionGate.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorVideoCall/DoctoravalibleTime.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorHomePage/DoctorHomePage.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorProfile/DoctorProfileView.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorProfile/EditMedicalInfo.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorProfile/EditProfileInfo.dart';
import 'package:gradutionproject/Features/DoctorFeatures/GetDoctorData/CartifiedAccount.dart';
import 'package:gradutionproject/Features/DoctorFeatures/GetDoctorData/GetdoctorDataPage.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/ChangePassword.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/Forget%20Password.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/LogIn.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/SignUp.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/UserType.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/IdleDoctor/SearchDoctorPage/SearchDoctor.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientData/PatientData.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientProfilePage/EditPatientMedicalInfoPage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientProfilePage/EditPatientProfileInfoPage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientProfilePage/PatientProfilePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientSchedulePage/PatientSchedule.dart';
import 'package:gradutionproject/Features/PatientFeatures/PremiumAccountPage/PaymentDetails.dart';
import 'package:gradutionproject/Features/Welcome/OnboardOne.dart';
import 'package:gradutionproject/Features/Welcome/OnboardThree.dart';
import 'package:gradutionproject/Features/Welcome/OnboardTwo.dart';
import 'package:gradutionproject/Features/Welcome/SplashViewPage.dart';
import 'package:gradutionproject/Features/payment/Payment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Initialize global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheNetwork.cacheInitialization(); // Wait for initialization

  await Supabase.initialize(
    url: "https://fneysqdotzuovzssvvrz.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuZXlzcWRvdHp1b3Z6c3N2dnJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4NTI0MTcsImV4cCI6MjA2MDQyODQxN30.M1AGvsJksyVRQHEnGBSEDVF8uUxqxb3C2s1m_JJ2I_c",
  );
  print("''''''''''''''''''' User Id ${supabase.auth.currentUser?.id}");
  // await ImageSure();
  //EndSession();
  //getCalenderDates();
  //selectAllPatients();
  // GetDoctorData();
  // selectAllPatients();
  // getCalenderDates();
  //  await RateDoctor();
  // await GetPastDoctors();
  //await GetPastPatients();
  // await getBookedSessions();
  await premiumAccount();
  //  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  //   if (data.event == AuthChangeEvent.passwordRecovery) {
  //     // Navigate to password reset screen
  //     navigatorKey.currentState?.pushReplacement(
  //       MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
  //     );
  //   }
  // });
 
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
// var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    // Check if the user has a premium account
  


    // getClosestSessionDate(context);
    bool isUserLoggedIn() {
      final session = Supabase.instance.client.auth.currentSession;

      return session != null;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => Authcubit()..GetPastPatient()
          // ..monitorConnection(),
          // ..monitorConnection()
        ),
        BlocProvider(
          create:
              (BuildContext context) =>
                  PatientFeaturesCubit()
                    ..selectAllDoctors(true)
                    ..GetPatientFavourite()
                    ..selectAllSession()
                    ..getClosestSessionDate()
                    ..startTimer()
                    ..getCalenderDates(),

        ),
        BlocProvider(
          create:
              (BuildContext context) =>
                  DoctorFeaturesCubit()
                    ..getDateById()
                    ..GetDoctorData()
                    ..getCalenderDates()
                    ..getBookedSessions(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Set the navigator key here
        debugShowCheckedModeBanner: false,
        home:
            //PatientHomepage(),
            SplashScreen(),

        // isUserLoggedIn() ?
        // DoctorHomePage() ,
        //: SignInPage(),

        // EditDoctorProfileInfoPage(),
        // EditDoctorMedicalInfoPage(),
        routes: <String, WidgetBuilder>{
          'SignIn': (BuildContext context) => SignInPage(),
          'SignUp': (BuildContext context) => SignUpPage(),
          'OnboardOne': (BuildContext context) => OnboardOne(),
          'UserType': (BuildContext context) => UserType(),
          'ForgetPassword': (BuildContext context) => ForgetPasswordScreen(),
          'OnboardTwo': (BuildContext context) => OnboardTwo(),
          'OnboardThree': (BuildContext context) => OnboardThree(),
          'PremiumDetails': (BuildContext context) => PremiumAccountDetails(),
          'GetDoctordata': (BuildContext context) => GetDoctordataPage(),
          'GetPatientdata': (BuildContext context) => GetPatientdata(),
          // 'Changepassword': (BuildContext context) => Changepassword(),
          'DoctorHomePage': (BuildContext context) => DoctorHomePage(),
          'PatientHomePage': (BuildContext context) => PatientHomepage(),
          'CartifiedAccountPage':
              (BuildContext context) => CartifiedAccountPage(),
          'DoctorSearch': (BuildContext context) => DoctorSearch(),
          'DoctorAvilableTime': (BuildContext context) => Doctoravalibletime(),
          'PatientProfileVieawPage':
              (BuildContext context) => PatientprofileVieawpage(),
          'SessionGate': (BuildContext context) => SessionGate(),
          'VideoCallScreen': (BuildContext context) => VideoCallScreen(),
          'ResponsiveCalendar': (BuildContext context) => ResponsiveCalendar(),
          'DoctorProfile':
              (BuildContext context) => DoctorProfileViewPage(
                experiance:
                    supabase.auth.currentUser!.userMetadata!["experience"],
                certificates:
                    supabase.auth.currentUser!.userMetadata!["certificates"],
                name:
                    supabase.auth.currentUser!.userMetadata!["first_name"] +
                    " " +
                    supabase.auth.currentUser!.userMetadata!["last_name"],
                id: supabase.auth.currentUser!.id,
                reviewsnum:
                    // BlocProvider.of<DoctorFeaturesCubit>(
                    //   context,
                    // ).dr!.rateing.length.toString()??
                    "7",
              ),
          'EditDoctorMedicalInfO':
              (BuildContext context) => EditDoctorMedicalInfoPage(),
          'EditDoctorProfileInfo':
              (BuildContext context) => EditDoctorProfileInfoPage(),
          'MainPage': (BuildContext context) => MainPage(),
          'payment': (BuildContext context) => payment(),
          'EditPatientMedical':
              (BuildContext context) => EditPatientMedicalInfoPage(),
          'EditPatientProfile':
              (BuildContext context) => EditPatientProfileInfoPage(),
          'ChangePassword': (BuildContext context) => ChangePasswordScreen(),
        },
      ),
    );
  }
}

//  "raw_user_meta_data": {
//     "sub": "8abcc5b3-4966-4e19-a4ab-1bfdfc0c512b",
//     "email": "karim.mamdou11@gmail.com",
//     "last_name": "saber",
//     "experience": "ghjklhjkhjkhj",
//     "first_name": "kemo",
//     "certificates": "wsdfghjkjhgsdfghj",
//     "doctoraccount": true,
//     "email_verified": true,
//     "phone_verified": false
//   },
Future<void> premiumAccount() async {
  print("${DateTime.now().toString()} premiumAccount called");
  
  try {
    // 1. Check if user is logged in
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    // 2. Use current date/time for subscription
    final currentDate = DateTime.now().toIso8601String();

    // 3. Update user attributes
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        data: {
          "premium_account": false,
          "date_of_subscribe": "2025-06-10 21:11:33.884048+00",
        },
      ),
    );

    print("Premium account updated successfully: ${res.user?.email}");
    // emit(PremiumAccountSucceedState());
    
  } on AuthException catch (e) {
    print("Auth Error: ${e.message}");
    // emit(PremiumAccountFailureState(e.message));
  } on PostgrestException catch (e) {
    print("Database Error: ${e.message}");
    // emit(PremiumAccountFailureState(e.message));
  } catch (e) {
    print("Unexpected Error: ${e.toString()}");
    // emit(PremiumAccountFailureState('An unexpected error occurred'));
  }
}
//DateTime.parse(dateString)