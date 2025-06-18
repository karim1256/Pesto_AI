import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesStates.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';

void showDoctorMedicalDialog(BuildContext context, String patientName) {
  final TextEditingController medicalHistoryController =
      TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController recommendationsController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Text(
                          patientName,
                          style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: MainColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                    const SizedBox(height: 24),



                    _buildSectionHeader("Medical History", context),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: medicalHistoryController,
                      hintText: "Enter patient's medical history...",
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? "Required field" : null,
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // Preliminary Diagnosis Section
                    _buildSectionHeader("Preliminary Diagnosis", context),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: diagnosisController,
                      hintText: "Enter your diagnosis...",
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? "Required field" : null,
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // Doctor's Recommendations Section
                    _buildSectionHeader("Doctor's Recommendations", context),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      controller: recommendationsController,
                      hintText: "Enter your recommendations...",
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? "Required field" : null,
                      context: context,
                    ),
                    const SizedBox(height: 30),

                    // Action Buttons - Remove Expanded and use Fixed width
                    const SizedBox(width: 16),
                    Flexible(
                      child: BlocConsumer<
                        DoctorFeaturesCubit,
                        DoctorFeaturesStates
                      >(
                        listener: (context, state) {
                          if (state is SessionsResultSucceedState) {
                            buildSnackBar(
                              context,
                              "Succes to save Diagnosis",
                              MainColor,
                            );
                            Navigator.pop(context);
                          } else if (state is SessionsResultFailureState) {
                            buildSnackBar(
                              context,
                              "Field to save Diagnosis",
                              Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          var cubit = BlocProvider.of<DoctorFeaturesCubit>(
                            context,
                          );
                          var cubitt = BlocProvider.of<PatientFeaturesCubit>(
                            context,
                          );
                          return Button(
                            context,

                            state is SessionsResultLoadingState
                                ? Loading(color: Colors.white)
                                : ButtonText(
                                  "Submit",
                                  context,
                                  TextColor: Colors.white,
                                ),
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                cubit.EndSession(
                                  histort: medicalHistoryController.text,
                                  diagnosis: diagnosisController.text,
                                  recomendation: recommendationsController.text,
                                  date: cubit.Diagnisisdate!,
                                );
                                await cubit.getCalenderDates();

                                // cubit.Diagnisisdate = cubitt.closeSession;

                                // Navigator.pop(context);
                              }
                            },
                            ContainerColor: MainColor,
                            TextColor: Colors.white,
                            radius: 12,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildSectionHeader(String title, BuildContext context) {
  return Text(
    title,
    style: GoogleFonts.raleway(
      fontSize: screenWidth(context) * 0.04,
      fontWeight: FontWeight.w700,
      color: MainColor,
    ),
  );
}

Widget _buildTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLines: 3,
    minLines: 2,
    validator: validator,
    style: GoogleFonts.raleway(fontSize: screenWidth(context) * 0.035),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.raleway(
        color: Colors.grey[500],
        fontSize: screenWidth(context) * 0.035,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color.fromARGB(255, 74, 73, 73)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: MainColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.all(16),
      filled: true,
      fillColor: const Color.fromARGB(255, 224, 224, 224),
    ),
  );
}
