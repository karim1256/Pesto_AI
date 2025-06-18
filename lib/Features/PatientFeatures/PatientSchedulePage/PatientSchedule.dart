import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

class ResponsiveCalendar extends StatefulWidget {
  const ResponsiveCalendar({super.key});

  @override
  _ResponsiveCalendarState createState() => _ResponsiveCalendarState();
}

class _ResponsiveCalendarState extends State<ResponsiveCalendar> {
  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    double height = screenHeight(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),

      backgroundColor: Colors.white,
      body: BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
        listener: (context, state) {
         


          // if (state is UpdatePatientMedicalSucceedState) {
          //   buildSnackBar(
          //     context,
          //     "Profile updated successfully",
          //     Colors.green,
          //   );

          //   cubit.MedicalState=false;

          //   // Navigator.pushReplacement(
          //   //   context,
          //   //   MaterialPageRoute(
          //   //     builder: (context) =>
          //   //         EditPatientMedicalInfoPage(),
          //   //   ),
          //   // );
          // } else if (state is UpdatePatientMedicalFailureState) {
          //   buildSnackBar(context, state.Message, Colors.red);
          // }


        },
        builder: (context, state) {
          var cubit = BlocProvider.of<PatientFeaturesCubit>(context);

          return SingleChildScrollView(
            child: Column(
              children: [
                // buildAppBar(context), // Custom App Bar
                SizedBox(height: height * 0.1),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCalendarWidget(
                          context: context,
                          focusedDays: cubit.calenderList,
                          cubit: cubit,
                        ),

                        cubit.calenderList.isNotEmpty
                            ? buildMeetingDetails(
                              context,
                              cubit.calenderList[cubit.i],
                              cubit.DoctorDetails!.name ,
                            )
                            : buildNoDoctorDetails(context),
                        SizedBox(height: height * 0.01),
                        //  buildNextMeetingInfo(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildNoDoctorDetails(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    height: screenHeight(context) * 0.08,
    width: width * 0.81,
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: MainColor, width: 1.5),
    ),
    child: Center(child: NotFound(text: "Sessions", context: context)),
  );
}
