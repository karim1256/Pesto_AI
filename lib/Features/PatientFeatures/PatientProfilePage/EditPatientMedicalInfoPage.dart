import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/ProfileAppBar.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

class EditPatientMedicalInfoPage extends StatelessWidget {
  EditPatientMedicalInfoPage({super.key});
  final TextEditingController petSpeciesController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController healthHistoryController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
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
              ProfileAppBar(
                context,
                notAllowed: s == false ? false : true,
                height: 0.09,
                width: 2,
                toppic: 0.02,
                backbutton: true,
              ),
              SizedBox(height: bodyHeight(context) * 0.129),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildTextField(
                      petSpeciesController,
                      "Pet Species",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      //////////////////////////////////////
                      initValue:
                          supabase
                              .auth
                              .currentUser
                              ?.userMetadata!['pets species'] ??
                          '',
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase
                                  .auth
                                  .currentUser
                                  ?.userMetadata!['pets species'] ??
                              '',
                          petSpeciesController.text,
                          true,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),
                    buildTextField(
                      breedController,
                      "Bread",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      initValue:
                          supabase.auth.currentUser?.userMetadata!['bread'] ??
                          '',
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase.auth.currentUser?.userMetadata!['bread'] ??
                              '',
                          breedController.text,
                          true,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),

                    buildTextField(
                      genderController,
                      "Gender",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      initValue:
                          supabase.auth.currentUser?.userMetadata!['gender'] ??
                          '',
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase.auth.currentUser?.userMetadata!['gender'] ??
                              '',
                          genderController.text,
                          true,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),
                    buildTextField(
                      healthHistoryController,
                      "Health Histort",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      ////////////////////////////////////////////////////
                      initValue:
                          supabase
                              .auth
                              .currentUser
                              ?.userMetadata!['health history'] ??
                          '',
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase
                                  .auth
                                  .currentUser
                                  ?.userMetadata!['health history'] ??
                              '',
                          healthHistoryController.text,
                          true,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),
                    buildTextField(
                      ageController,
                      "Age",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      ////////////////////////////////////////////////////
                      initValue:
                          supabase.auth.currentUser?.userMetadata!['age']
                              .toString() ??
                          '',
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase.auth.currentUser?.userMetadata!['age'] ?? '',
                          ageController.text,
                          true,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.04),

                    BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
                      listener: (context, state) {
                        if (state is UpdatePatientMedicalSucceedState) {
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
                        } else if (state is UpdatePatientMedicalFailureState) {
                          buildSnackBar(context, state.Message, Colors.red);
                        }
                      },
                      builder: (context, state) {
                        var cubit = BlocProvider.of<PatientFeaturesCubit>(
                          context,
                        );

                        return Button(
                          context,

                          state is UpdatePatientMedicalLoadingState
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
                              cubit.MedicalState
                                  ? MainColor
                                  : Color(0xffECECF0),
                          onPressed:
                              cubit.MedicalState
                                  ? () {
                                    cubit.UpdatePatientMedicalForAll(
                                      petSpeciesController.text,
                                      genderController.text,
                                      breedController.text,
                                      healthHistoryController.text,
                                      int.tryParse(ageController.text)!,
                                    );
                                  }
                                  : null, // Disable button if no changes
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
