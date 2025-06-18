import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/IdleDoctor/BookingWidget.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentBookingScreen extends StatelessWidget {
  final String? name;
  final String? reviewsnum;
  final List? rating;
  final String? id;
  final bool? view;
  final String experiance;
  final String certificates;
  final String? image;

  const AppointmentBookingScreen({
    super.key,
    this.name,
    this.reviewsnum,
    this.rating,
    this.id,
    this.view,
    required this.experiance,
    required this.certificates,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      
       cubit.Connected == false
              ? Center(
                child: Image.asset(
                  'lib/Core/Assets/NoWifi.png',
                  width: screenWidth(context),
                  height: screenHeight(context),
                ),
              )
              :
      
       SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Row(
                  children: [
                    SizedBox(width: screenWidth(context) * 0.05),
                    backButton(context),
                  ],
                ),
                BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
                  listener: (context, state) {
                    if (state is PatientBookingSucceedState) {
                      cubit.getDateById(id!);
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      width: screenWidth(context),
                      height: screenHeight(context) * 0.82,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight(context) * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: MainColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child:
                          state is PatientGetBookingLoadingState
                              ? Loading(color: Colors.white)
                              : AppointmentBookingPage(),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: screenHeight(context) * 0.061,
              left: screenWidth(context) * 0.10,
              child: DoctorCard(
                pop: true,
                name: name!,
                reviewsnum: reviewsnum!,
                rating: rating!,
                context: context,
                experiance: experiance,
                certificate: certificates,
                id: id!,
                image: image,
              ),
            ),
            Positioned(
              bottom: screenHeight(context) * 0.1,
              left: screenWidth(context) * 0.15,
              child: Button(
                onPressed:
                    cubit.selectedDateIndex == null ||
                            cubit.selectedTimeIndex == null
                        ? null
            //             () {
            //               print("]]]]]]]]]]]]]]]]]]]]]]]]]${cubit.selectedDateIndex}");
            //  print("]]]]]]]]]]]]]]]]]]]]]]]]]${cubit.selectedTimeIndex}");

            //             }
                        :
                         () {

           print("Boooooookkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");

                          var selectedSlot = getSelectedSlot(context);
                          if (selectedSlot != null) {
                            cubit.BookMedicalSession(
                              doctorId: id!,
                              patientId:
                                  Supabase
                                      .instance
                                      .client
                                      .auth
                                      .currentSession!
                                      .user
                                      .id,
                              history: null,
                              diagnosis: null,
                              recommendation: null,
                              date: selectedSlot,
                            );
                            print('Booking for: $selectedSlot');
                          }
                        },
                context,
                state is PatientBookingLoadingState
                    ? Loading(color: MainColor)
                    : ButtonText("Confirm Booking", context),
                width: screenWidth(context) * 0.6,
                height: 48,
                radius: 15,
                fontsize: 18,
                ContainerColor: Colors.white,
                TextColor: MainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
