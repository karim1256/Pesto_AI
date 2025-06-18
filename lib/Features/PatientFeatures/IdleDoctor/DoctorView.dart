import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorProfile/DoctorProfileView.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/IdleDoctor/BookAppointment.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PremiumAccountPage/PremiumAccountDialog.dart';

class Doctorview extends StatelessWidget {
  String name;
  String reviewsnum;
  List rating;
  String id;
  bool? view;
  String experiance;
  String certificates;
  String image;
  Doctorview(
    this.name,
    this.reviewsnum,
    this.rating,
    this.id,
    this.view,
    this.experiance,
    this.certificates,
    this.image, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const emptyPic =
        "https://fneysqdotzuovzssvvrz.supabase.co/storage/v1/object/public/profile/doctors-profile/Empty.jpg";

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.amber,
            child: Image.network(
              image.isEmpty ? emptyPic : image.trim(),
              fit: BoxFit.cover,
            ),
          ),
          DoctorViewButtons(
            context,
            name,
            reviewsnum,
            rating,
            id,
            view,
            experiance,
            certificates,
            image,
          ),
        ],
      ),
    );
  }
}

DoctorViewButtons(
  BuildContext context,
  String name,
  String reviews,
  List rating,
  String id,
  bool? view,
  String experiance,
  String certificates,
  String image,
) {
  var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
  return Stack(
    children: [
      Positioned(
        left: screenWidth(context) * 0.03,
        top: screenHeight(context) * 0.5,
        child: DoctorCard(
          image: image,
          name: name,
          reviewsnum: reviews,
          rating: rating,
          context: context,
          view: true,
          experiance: experiance,
          certificate: certificates,
          id: id,
        ),
      ),
      Positioned(
        top: screenHeight(context) * 0.6,

        left: screenWidth(context) * 0.065,

        child: Button(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder:
                    (BuildContext context) => DoctorProfileViewPage(
                      name: name,
                      reviewsnum: reviews,
                      rateing: rating,
                      id: id,
                      experiance: experiance,
                      certificates: certificates,
                      image: image,
                    ),
              ),
            );
          },
          context,
          ButtonText("View Profile", context, TextColor: Colors.white),
          height: screenWidth(context) * 0.10,
          fontsize: screenWidth(context) * 0.035,
          width: screenWidth(context) * 0.35,
        ),
      ),
      Positioned(
        top: screenHeight(context) * 0.6,
        left: screenWidth(context) * 0.42,
        child: Button(
          onPressed: () {
            if (supabase.auth.currentUser!.userMetadata!["premium_account"]) {
              cubit.getDateById(id);

              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder:
                      (BuildContext context) => AppointmentBookingScreen(
                        name: name,
                        reviewsnum: reviews,
                        rating: rating,
                        id: id,
                        experiance: experiance,
                        certificates: certificates,
                        image: image,
                      ),
                ),
              );
            } else {
              Navigator.pop(context);
        showPremiumAccountDialog(context);

            }

            //  Navigator.pushNamed(context, "AppointmentBookingScreen");

            //  print(  supabase.auth.currentUser!.userMetadata!["doctoraccount"]);
          },
          context,
          ButtonText(
            "Book Appointment",
            context,
            TextColor: Colors.white,
            FontSize: screenWidth(context) * 0.04,
          ),
          fontsize: screenWidth(context) * 0.034,
          height: screenWidth(context) * 0.10,
          width: screenWidth(context) * 0.44,
        ),
      ),
    ],
  );
}

// #0      PatientFeaturesCubit.getDateById.<anonymous closure> (package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart:355:37)
