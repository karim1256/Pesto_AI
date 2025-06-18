import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

void showRatingDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  double rating = 3;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(12),
                    //   child: Image.network(
                    //     'https://via.placeholder.com/100', // استبدلها بالصورة الحقيقية
                    //     width: 80,
                    //     height: 80,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "patient",
                          style: TextStyle(
                            color: MainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "DR. john smith",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 24,
                          unratedColor: Colors.grey[300],
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 1.0,
                          ),
                          itemBuilder:
                              (context, _) =>
                                  Icon(Icons.star, color: MainColor),
                          onRatingUpdate: (rating) {
                            rating = rating;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a comment';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "good work",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child:
                      BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
                        listener: (context, state) {
                          if (state is AddRateingSucceedState) {
                            buildSnackBar(
                              context,
                              "Succes to save Diagnosis",
                              MainColor,
                            );
                            Navigator.pop(context);
                          } else if (state is AddRateingFailureState) {
                            buildSnackBar(
                              context,
                              "Field to save Diagnosis",
                              Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          var cubitt = BlocProvider.of<DoctorFeaturesCubit>(
                            context,
                          );
                          var cubit = BlocProvider.of<PatientFeaturesCubit>(
                            context,
                          );
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                cubit.RateDoctor(controller.text, rating);

                                print("Rating: $rating");
                                print("Comment: ${controller.text}");

                                Navigator.pop(context);
                                await cubit.getCalenderDates();
                              }
                            },
                            child: Text("Submit"),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
