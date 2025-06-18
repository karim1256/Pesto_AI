import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

class GetPatientdata extends StatelessWidget {
  GetPatientdata({super.key});

  final TextEditingController speciesController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController healthHistoryController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor,
      body:
       BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
        listener: (context, state) {
          if (state is GetPatientMedicalDataSucceedState) {
            Navigator.pushReplacementNamed(context, 'MainPage');
            buildSnackBar(context, "Data saved successfully", Colors.green);
          } else if (state is GetPatientMedicalDataFailureState) {
            buildSnackBar(context, state.Message, Colors.red);
          }
        },
        builder: (context, state) {
          var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 0.13,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: bodyHeight(context) * 0.069),
                      LoginUPFormat(
                        'Hi There!',
                        "Type Your Pet Medical information",
                        context,
                      ),
                      SizedBox(height: bodyHeight(context) * 0.05),

                      buildTextField(
                        speciesController,
                        "Pets Species",
                        context,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Species is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: bodyHeight(context) * 0.02),

                      buildTextField(
                        breedController,
                        "Breed",
                        context,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Breed is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: bodyHeight(context) * 0.02),

                      buildTextField(
                        genderController,
                        "Gender",
                        context,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gender is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: bodyHeight(context) * 0.02),

                      buildTextField(
                        healthHistoryController,
                        "Health History",
                        context,
                      ),
                      SizedBox(height: bodyHeight(context) * 0.02),

                      buildTextField(
                        ageController,
                        "Age",
                        context,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: bodyHeight(context) * 0.05),

                      Button(
                        context,
                        state is GetPatientMedicalDataLoadingState
                            ? CircularProgressIndicator(color: Colors.white)
                            : ButtonText(
                              "Save",
                              context,
                              TextColor: Colors.white,
                            ),
                        width: screenWidth(context) * 0.74,
                        height: bodyHeight(context) * 0.07,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                                
                                cubit.GetPatientMedicalData(
                                  species: speciesController.text,
                                  breed: breedController.text,
                                  gender: genderController.text,
                                  history: healthHistoryController.text,
                                  age: int.parse(ageController.text),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
