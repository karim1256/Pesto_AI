import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Drawer.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  Timer? _timer;
  StreamSubscription? _subscription;
  @override
  void initState() {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          setState(() {
            cubit.isConnected(true, context);
            print(
              "-------------------------------Conected ${cubit.Connected}-------------------------------",
            );
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            cubit.isConnected(false, context);

            print(
              "-------------------------------Not Conected   ${cubit.Connected}-------------------------------",
            );
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<DoctorFeaturesCubit>(context, listen: true);
    var cubitt = BlocProvider.of<Authcubit>(context, listen: true);
    var cubittt = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);

    //    var cubitt = BlocProvider.of<PatientFeaturesCubit>(context,listen: true);
    Widget PastPatients() {
      print(
        "--------------------------past-${cubitt.pastPatients.length}---------------------------",
      );

      return SizedBox(
        height: bodyHeight(context) * 0.14,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cubitt.pastPatients.length,
          itemBuilder: (context, index) {
            return PatientCard(
              name:
                  "${cubitt.pastPatients[index].first_name} ${cubitt.pastPatients[index].last_name}",
              image: cubitt.pastPatients[index].image!,
              pm: cubitt.pastPatients[index],
            );
          },
        ),
      );
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: CustomBottomBar(),
      body:
          cubittt.Connected == false
              ? Center(
                child: Image.asset(
                  'lib/Core/Assets/NoWifi.png',
                  width: screenWidth(context),
                  height: screenHeight(context),
                ),
              )
              : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.04,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: bodyHeight(context) * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Welcome back",
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.052,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 142, 142, 142),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  onPressed: () async {
                                    await BlocProvider.of<PatientFeaturesCubit>(
                                      context,
                                    ).fetchImageUrl();

                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: CircleAvatar(
                                    radius: screenWidth(context) * 0.052,
                                    backgroundImage: AssetImage(
                                      'lib/Core/Assets/drawer.png',
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          "${supabase.auth.currentUser!.userMetadata!["first_name"]} !",
                          style: TextStyle(
                            fontSize: screenWidth(context) * 0.054,
                            fontWeight: FontWeight.bold,
                            color: MainColor,
                          ),
                        ),
                        SizedBox(height: bodyHeight(context) * 0.035),
                        Center(
                          child: buildCalendarWidget(
                            context: context,
                            focusedDays: cubit.calenderList,
                            cubit: cubit,
                          ),
                        ),

                        cubit.calenderList.isNotEmpty &&
                                cubit.firstPatient != null
                            ? Center(
                              child: buildMeetingDetails(
                                context,

                                cubit.calenderList.isEmpty
                                    ? null
                                    : cubit.calenderList[cubit.i],

                                "${cubit.firstPatient!.first_name!} ${cubit.firstPatient!.last_name!}",
                              ),
                            )
                            : SizedBox(height: bodyHeight(context) * 0.0),

                        //      buildNextMeetingInfo(context),
                        SizedBox(height: bodyHeight(context) * 0.03),

                        // Text(
                        //   "Past Patients",
                        //   style: TextStyle(
                        //     fontSize: screenWidth(context) * 0.045,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),

                        // BlocConsumer<Authcubit, AuthStates>(
                        //   listener: (context, state) {
                        //     // This will print every state change
                        //     debugPrint('Current State: $state');

                        //     // You can also add specific actions for certain states
                        //     // if (state is PastPatientsSucceedState) {
                        //     //   debugPrint('Past Patients Loaded: ${cubit.pastDoctors.length} items');
                        //     // } else if (state is PastPatientsFailureState) {
                        //     //   debugPrint('Error loading past patients: ${state.Message}');
                        //     // }
                        //   },
                        //   builder: (context, state) {
                        //     // This will also print the state during rebuilds
                        //     debugPrint('Rebuilding with state: $state');
                        //     // if (cubitt.isConnected) {
                        //     if (state is PastPatientsLoadingState) {
                        //       return SizedBox(
                        //         height: bodyHeight(context) * 0.14,
                        //         child: Loading(),
                        //       );
                        //     } else if (state is PastPatientsSucceedState &&
                        //         cubitt.pastPatients.isEmpty) {
                        //       return SizedBox(
                        //         height: bodyHeight(context) * 0.14,

                        //         child: NotFound(
                        //           text: "Past Patients",
                        //           context: context,
                        //         ),
                        //       );
                        //     } else if (state is PastPatientsFailureState) {
                        //       return SizedBox(
                        //         height: bodyHeight(context) * 0.14,
                        //         child: Error(context: context),
                        //       );
                        //     } else {
                        //       return PastPatients();
                        //     }
                        //     // }
                        //     //  else {
                        //     //  return
                        //     //   Image.asset(
                        //     //     "lib/Core/Assets/NoWifi.png",
                        //     //     width: screenWidth(context)*0.1 ,
                        //     //   );
                        //     // }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
