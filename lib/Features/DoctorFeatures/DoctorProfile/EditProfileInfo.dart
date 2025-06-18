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

class EditDoctorProfileInfoPage extends StatelessWidget {
  const EditDoctorProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    bool s = supabase.auth.currentUser!.userMetadata!["doctoraccount"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildTextField(
                      firstNameController,
                      "First Name",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      initValue:
                          supabase
                              .auth
                              .currentUser
                              ?.userMetadata!['first_name'] ??
                          "",
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase
                              .auth
                              .currentUser
                              ?.userMetadata!['first_name'],
                          firstNameController.text,
                          false,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),
                    buildTextField(
                      lastNameController,
                      "Last Name",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      initValue:
                          supabase
                              .auth
                              .currentUser
                              ?.userMetadata!["last_name"] ??
                          "",
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase.auth.currentUser?.userMetadata!["last_name"],
                          lastNameController.text,
                          false,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),
                    buildTextField(
                      emailController,
                      "Email",
                      context,
                      FormColor: Color(0xffECECF0),
                      init: true,
                      initValue: supabase.auth.currentUser!.email,
                      onChanged: (value) {
                        cubit.EditPatientMedicalInfoLogic(
                          supabase.auth.currentUser!.email!,
                          emailController.text,
                          false,
                        );
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.08),

                    BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
                      listener: (context, state) {
                        if (state is UpdatePatientProfileSucceedState) {
                          buildSnackBar(
                            context,
                            "Profile updated successfully",
                            Colors.green,
                          );
                        } else if (state is UpdatePatientProfileFailureState) {
                          buildSnackBar(context, state.Message, Colors.red);
                        }
                      },
                      builder: (context, state) {
                        var cubit = BlocProvider.of<PatientFeaturesCubit>(
                          context,
                        );

                        return Button(
                          context,

                          state is UpdatePatientProfileLoadingState
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
                              cubit.ProfileState
                                  ? MainColor
                                  : Color(0xffECECF0),
                          onPressed:
                              cubit.ProfileState
                                  ? () {
                                    cubit.UpdatePatientProfileForAll(
                                      firstNameController.text,
                                      lastNameController.text,
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
