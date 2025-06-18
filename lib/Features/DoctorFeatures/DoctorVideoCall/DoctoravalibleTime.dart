import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorVideoCall/AppointmentBooking.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';

class Doctoravalibletime extends StatelessWidget {
  const Doctoravalibletime({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<DoctorFeaturesCubit>(context, listen: true);
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ralewayText(
                      "Schedule",
                      context,
                      fontSize: screenWidth(context) * 0.1,
                    ),
                    ralewayText(
                      'Choose your available time ',
                      context,
                      fontSize: screenWidth(context) * 0.05,
                    ),
                    SizedBox(height: screenWidth(context) * 0.048),
                  ],
                ),
                Container(
                  width: screenWidth(context),
                  height: screenHeight(context) * 0.68,
                  padding: EdgeInsets.only(
                    bottom: screenHeight(context) * 0.07,
                  ),
                  decoration: BoxDecoration(
                    color: MainColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  alignment: Alignment.topCenter,
                  child:
                          // Loading(color: Colors.white)
                           appointmentBookingContent(
                            context,
                            button: "Avl Appointment",
                          ),
                          
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
