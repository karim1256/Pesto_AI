import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/ProfileAppBar.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesStates.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';

class EditDoctorMedicalInfoPage extends StatelessWidget {
  EditDoctorMedicalInfoPage({super.key});
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController certificatesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool s = supabase.auth.currentUser!.userMetadata!["doctoraccount"];

    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  ProfileAppBar(
                    context,
                    notAllowed: s == false ? true : false,
                    height: 0.09,
                    width: 2,
                    toppic: 0.02,
                    backbutton: true,
                  ),
                  SizedBox(height: bodyHeight(context) * 0.132),

                  buildTextField(
                    experienceController,
                    "Experiance",
                    context,
                    FormColor: Color(0xffECECF0),
                    init: true,
                    //////////////////////////////////////
                    initValue:
                        supabase
                            .auth
                            .currentUser
                            ?.userMetadata!['experience'] ??
                        '',
                    onChanged: (value) {
                      cubit.EditPatientMedicalInfoLogic(
                        supabase
                                .auth
                                .currentUser
                                ?.userMetadata!['experience'] ??
                            '',
                        experienceController.text,
                        true,
                      );
                      return null;
                    },
                    bigForm: true,
                  ),
                  SizedBox(height: screenHeight(context) * 0.02),
                  buildTextField(
                    certificatesController,
                    "Certificates",
                    context,
                    FormColor: Color(0xffECECF0),
                    init: true,
                    initValue:
                        supabase
                            .auth
                            .currentUser
                            ?.userMetadata!['certificates'] ??
                        '',
                    onChanged: (value) {
                      cubit.EditPatientMedicalInfoLogic(
                        supabase
                                .auth
                                .currentUser
                                ?.userMetadata!['certificates'] ??
                            '',
                        certificatesController.text,
                        true,
                      );
                      return null;
                    },
                    bigForm: true,
                  ),
                  SizedBox(height: screenHeight(context) * 0.2),

                  BlocConsumer<DoctorFeaturesCubit, DoctorFeaturesStates>(
                    listener: (context, state) {
                      if (state is UpdateDoctorMedicalSucceedState) {
                        buildSnackBar(
                          context,
                          "Profile updated successfully",
                          Colors.green,
                        );

                        cubit.MedicalState = false;

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         EditPatientMedicalInfoPage(),
                        //   ),
                        // );
                      } else if (state is UpdateDoctorMedicalFailureState) {
                        buildSnackBar(context, state.Message, Colors.red);
                      }
                    },
                    builder: (context, state) {
                      var cubit = BlocProvider.of<PatientFeaturesCubit>(
                        context,
                        listen: true,
                      );
                      var cubitt = BlocProvider.of<DoctorFeaturesCubit>(
                        context,
                      );

                      return Button(
                        context,

                        state is UpdateDoctorMedicalLoadingState
                            ? Loading(color: Colors.white)
                            : // Button text
                            ButtonText(
                              "Save",
                              context,
                              TextColor: Colors.white,
                            ),

                        // Disabled button text
                        width: screenWidth(context) * 0.8,
                        height: screenHeight(context) * 0.06,
                        ContainerColor:
                            cubit.MedicalState ? MainColor : Color(0xffECECF0),
                        onPressed:
                            cubit.MedicalState
                                ? () {
                                  cubitt.UpdateDoctorMedicalForAll(
                                    experienceController.text,
                                    certificatesController.text,
                                  );
                                }
                                : null, // Disable button if no changes
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
