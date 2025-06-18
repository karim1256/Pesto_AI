import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/VideoCall/SessionGate.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorHomePage/DoctorHomePage.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorProfile/DoctorProfileView.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorVideoCall/DoctoravalibleTime.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientProfilePage/PatientProfilePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientSchedulePage/PatientSchedule.dart';


class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    var AuthCubit = BlocProvider.of<Authcubit>(context, listen: true);

    return 
    
    
    cubit.Connected ==false
        ? Container(
            height: 0,
          )
        : 
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          rippleColor: MainColor,
          hoverColor: MainColor,
          gap: 9,
          activeColor: MainColor,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[100]!,
          color: Colors.grey[600],
          tabs: [
            GButton(icon: Icons.home, text: 'Home'),

            GButton(icon: Icons.video_call_rounded, text: 'Video'),

            GButton(icon: Icons.person, text: 'Profile'),

            GButton(
              icon: Icons.calendar_month_rounded,
              text:
                  supabase.auth.currentUser!.userMetadata!["doctoraccount"]

                      ? "AVL Time"
                      : 'Calendar',

                      
            ),
          ],
          selectedIndex: cubit.selectedTab,
          onTabChange: (index) {
            cubit.handleIndexChanged(index);
          },
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    var cubitt = BlocProvider.of<DoctorFeaturesCubit>(context, listen: true);

    List PatientScreens = [
      PatientHomepage(),
      SessionGate(),
      PatientprofileVieawpage(),
      ResponsiveCalendar(),
    ];

    List DoctorScreens = [
      DoctorHomePage(),
      SessionGate(),
      DoctorProfileViewPage(),
      Doctoravalibletime(),
    ];

    return Scaffold(
      body:
          supabase.auth.currentUser!.userMetadata!["doctoraccount"]
              ? DoctorScreens[cubit.selectedTab]
              : PatientScreens[cubit.selectedTab],
    );
  }
}
