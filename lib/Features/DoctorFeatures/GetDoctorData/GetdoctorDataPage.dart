import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesStates.dart';

class GetDoctordataPage extends StatelessWidget {
  GetDoctordataPage({super.key});

  final TextEditingController certificatesController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor,
      body: 
      BlocConsumer<DoctorFeaturesCubit, DoctorFeaturesStates>(
        listener: (context, state) {
          if (state is GetDoctorMedicalDataSucceedState) {
            Navigator.pushReplacementNamed(
              context,
              'MainPage',
            ); //'CartifiedAccountPage');
            buildSnackBar(context, "Data saved successfully", Colors.green);
          } else if (state is GetDoctorMedicalDataFailureState) {
            buildSnackBar(context, state.Message, Colors.red);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight(context) * 0.06),
                    Center(
                      child: LoginUPFormat(
                        'Hi Doctor!',
                        'Type Your Information',
                        context,
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.05),

                    // Certificates Field
                    buildTextField(
                      certificatesController,
                      'Certificates',
                      context,
                      bigForm: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Certificates are required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.01),

                    // Experience Field
                    buildTextField(
                      experienceController,
                      'Experience',
                      context,
                      bigForm: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Experience is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),

                    // Upload Button
                    Button(
                      context,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonText(
                            "Upload Your Certificates",
                            context,
                            TextColor: Colors.white,
                          ),
                        ],
                      ),
                      width: screenWidth(context) * 0.86,
                      height: screenHeight(context) * 0.06,
                    ),
                    SizedBox(height: bodyHeight(context) * 0.15),

                    // Submit Button
                    Button(
                      context,
                      state is GetDoctorMedicalDataLoadingState
                          ? CircularProgressIndicator(color: Colors.white)
                          : ButtonText(
                            "Submit",
                            context,
                            TextColor: Colors.white,
                          ),
                      width: screenWidth(context) * 0.86,
                      height: screenHeight(context) * 0.06,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<DoctorFeaturesCubit>().saveDoctorData(
                            certificates: certificatesController.text,
                            experience: experienceController.text,
                          );
                        }
                      },
                    ),
                    SizedBox(height: bodyHeight(context) * 0.02),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
