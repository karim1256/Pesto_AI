import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

class DoctorSearch extends StatefulWidget {
  const DoctorSearch({super.key});

  @override
  State<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Color.fromARGB(255, 214, 212, 235),
        body: BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    // width: double.infinity,
                    // height: double.infinity,
                    child: Image.asset(
                      "lib/Core/Assets/Doctor.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight(context) * 0.05),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new),
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.8,
                          height: screenHeight(context) * 0.072,

                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              cubit.SearchDoctor(value);
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: MainColor),
                              hintText: "Search a Doctor",
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height:
                          cubit.Search.isEmpty
                              ? screenHeight(context) * 0.056
                              : screenHeight(context) * 0.04,
                    ),
                    cubit.Search.isEmpty
                        ? NotFound(
                          text: "doctor",
                          context: context,
                          fontSize: screenWidth(context) * 0.08,
                          //  textcolor: const Color.fromARGB(255, 24, 24, 24),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: cubit.Search.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: screenHeight(context) * 0.113,
                                width: screenWidth(context) * 0.9,
                                child: DoctorCard(
                                  name: cubit.Search[index].name,
                                  search: true,
                                  reviewsnum:
                                      cubit.Search[index].raviews.length
                                          .toString(),
                                  rating: cubit.Search[index].rateing,
                                  context: context,
                                  experiance: cubit.Search[index].experience,
                                  certificate: cubit.Search[index].cartificates,
                                  id: cubit.Search[index].id,
                                  image: cubit.Search[index].image,
                                ),
                              );
                            },
                          ),
                        ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
