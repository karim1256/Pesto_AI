import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/ProfileAppBar.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/IdleDoctor/BookAppointment.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PremiumAccountPage/PremiumAccountDialog.dart';

class DoctorProfileViewPage extends StatefulWidget {
  final String? name;
  final String? reviewsnum;
  final List? rateing;
  final String? id;
  final bool? view;
  final String? experiance;
  final String? certificates;
  final String? image;

  const DoctorProfileViewPage({
    super.key,
    this.name,
    this.id,
    this.reviewsnum,
    this.rateing,
    this.view,
    this.image,
    this.experiance,
    this.certificates,
  });

  @override
  State<DoctorProfileViewPage> createState() => _DoctorProfileViewPageState();
}

class _DoctorProfileViewPageState extends State<DoctorProfileViewPage> {
  @override
  void initState() {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    // var cubitt = BlocProvider.of<DoctorFeaturesCubit>(context);

    cubit.setImageUrl(null);
    bool s = supabase.auth.currentUser!.userMetadata!["doctoraccount"];

    super.initState();
    // cubit.setImageUrl(null);
    if (s != true) {
      widget.image == null || widget.image!.isEmpty
          ? cubit.setImageUrl(emptyPic)
          : cubit.setImageUrl(widget.image!.trim());
    } else {
      cubit.fetchImageUrl();
    }
  }

  @override
  // void dispose() {
  //       var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
  //   cubit.setImageUrl(null);
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    bool s = supabase.auth.currentUser!.userMetadata!["doctoraccount"];
    dynamic d = supabase.auth.currentUser!.userMetadata;

    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    var cubitt = BlocProvider.of<DoctorFeaturesCubit>(context);

    return Scaffold(
      bottomNavigationBar: s == false ? null : CustomBottomBar(),
      backgroundColor: Colors.white,
      body:
          cubitt.dr == null
              ? Loading()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAppBar(
                      context,
                      notAllowed: s == false ? true : false,
                      height: 0.09,
                      width: 2,
                    ),
                    SizedBox(height: bodyHeight(context) * 0.132),
                    Text(
                      "Dr.${s ? d["first_name"] + " " + d["last_name"] : widget.name}",
                      style: TextStyle(
                        fontSize: screenWidth(context) * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Veterinary Medicine",
                      style: TextStyle(
                        fontSize: screenWidth(context) * 0.04,
                        color: Colors.grey,
                      ),
                    ),

                    buildStarRating(CalcuRating(cubitt.dr!.rateing), context,MainAxisAlignment.center),

                    TextButton(
                      onPressed: () {},
                      child: ralewayText(
                        "${cubitt.dr!.raviews.length} Reviews",
                        context,
                        fontSize: screenWidth(context) * 0.035,
                      ),
                    ),
                    // SizedBox(height: screenHeight(context) * 0.0001),
                    // ralewayText(
                    //   "Your appointment with Sunil is after 2 hours",
                    //   context,
                    //   fontSize: screenWidth(context) * 0.04,
                    //   color: Colors.black,
                    // ),
                    SizedBox(height: bodyHeight(context) * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (supabase
                                .auth
                                .currentUser!
                                .userMetadata!['doctoraccount'] ==
                            true) ...[
                          EditProfileButton(
                            context,
                            'EditDoctorMedicalInfO',
                            "Medical Info",
                          ),
                          SizedBox(width: screenWidth(context) * 0.018),
                          EditProfileButton(
                            context,
                            'EditDoctorProfileInfo',
                            "Personal Info",
                          ),
                        ] else ...[
                          EditProfileButton(
                            context,
                            'EditDoctorMedicalI000nfO',
                            "Book Apointment",
                            onpressed: () {
                              if (supabase
                                  .auth
                                  .currentUser!
                                  .userMetadata!["premium_account"]) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder:
                                        (BuildContext context) =>
                                            AppointmentBookingScreen(
                                              name: widget.name,
                                              reviewsnum: widget.reviewsnum,
                                              rating: widget.rateing,
                                              id: widget.id,
                                              experiance: widget.experiance!,
                                              certificates:
                                                  widget.certificates!,
                                            ),
                                  ),
                                );
                              }else {
                                showPremiumAccountDialog(context);
                              }
                            },
                          ),
                        ],
                      ],
                    ),

                    //   SizedBox(height: bodyHeight(context) * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth(context) * 0.05,
                        vertical: screenWidth(context) * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Experience",
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: MainColor,
                              ),
                            ),
                          ),

                          Text(
                            s ? d["experience"] : widget.experiance,
                            maxLines: cubit.readmoreExpariance ? 10 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenWidth(context) * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.readMorereadmoreExpariance();
                            },
                            child: Text(
                              cubit.readmoreExpariance
                                  ? "read less"
                                  : "read more",
                              style: TextStyle(
                                color: MainColor,
                                fontSize: screenWidth(context) * 0.042,
                              ),
                            ),
                          ),
                          SizedBox(height: bodyHeight(context) * 0.01),
                          Text(
                            "Certificate",
                            style: TextStyle(
                              fontSize: screenWidth(context) * 0.05,
                              fontWeight: FontWeight.bold,
                              color: MainColor,
                            ),
                          ),
                          Text(
                            s ? d["certificates"] : widget.certificates,
                            maxLines: cubit.readmoreCartificates ? 10 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenWidth(context) * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.readMorereadCartificates();
                            },
                            child: Text(
                              cubit.readmoreCartificates
                                  ? "read less"
                                  : "read more",

                              style: TextStyle(
                                color: MainColor,
                                fontSize: screenWidth(context) * 0.042,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
