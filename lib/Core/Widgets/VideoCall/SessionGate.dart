import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late PatientFeaturesCubit cubitt;

  @override
  void initState() {
    super.initState();
    cubitt = BlocProvider.of<PatientFeaturesCubit>(context);
    if (cubitt.closeSession != null) {
      cubitt.startTimer();
    }
  }

  @override
  void dispose() {
    cubitt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(),
      backgroundColor: Colors.white,
      body:
      
      cubit.Connected == false
              ? Center(
                child: Image.asset(
                  'lib/Core/Assets/NoWifi.png',
                  width: screenWidth(context),
                  height: screenHeight(context),
                ),
              )
              :
       SafeArea(
        child: Center(
          child: BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
            listener: (context, state) {
              // if (state is EndMeetingState) {
              //   showPatientMedicalDialog(context, "kemo");
              // }
            },
            builder: (context, state) {
              return
              //  cubit.closeSession == null
              //     ? Loading()
              //     :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/Core/Assets/watch.png',
                          width: screenWidth(context) * 0.2,
                        ),
                        SizedBox(width: screenHeight(context) * 0.18),
                      ],
                    ),

                    cubit.closeSession == null
                        ? SizedBox(height: screenHeight(context) * 0.01)
                        : SizedBox(height: screenHeight(context) * 0),
                    // state is CloseSessionSucceedState &&
                    cubit.closeSession == null
                        ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: screenHeight(context) * 0.12),

                              NotFound(
                                text: "sessions",
                                textcolor: const Color.fromARGB(
                                  255,
                                  16,
                                  16,
                                  16,
                                ),
                                context: context,
                                fontSize: screenWidth(context) * 0.071,
                                iconsize: screenWidth(context) * 0.15,
                              ),
                            ],
                          ),
                        )
                        : Text(
                          cubit.isSessionStarted
                              ? "Session Time"
                              : "Next Session",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth(context) * 0.062,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                    state is CloseSessionLoadingState
                        ? Loading()
                        : state is CloseSessionFailureState
                        ? Error(text: "closes date", context: context)
                        : cubit.closeSession == null
                        ? SizedBox(height: screenHeight(context) * 0.034)
                        : cubit.closeSession != null
                        ? Text(
                          cubit.count,
                          style: TextStyle(
                            color: MainColor,
                            fontSize: screenWidth(context) * 0.11,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : SizedBox(height: 0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/Core/Assets/watch2.png',
                          width: screenWidth(context) * 0.16,
                        ),
                        SizedBox(width: screenWidth(context) * 0.02),
                      ],
                    ),
                    SizedBox(height: screenHeight(context) * 0.039),

                    Image.asset(
                      'lib/Core/Assets/gate.png',
                      width: screenWidth(context) * 0.9,
                    ),

                    SizedBox(height: screenHeight(context) * 0.012),

                    Hero(
                      tag: 'startMeetingButton',
                      child: Material(
                        color: Colors.transparent,
                        child: Button(
                          ContainerColor:
                              cubit.isSessionStarted
                                  ? MainColor
                                  : const Color.fromARGB(255, 244, 243, 243),
                          onPressed:
                              cubit.isSessionStarted
                                  ? () {
                                    Navigator.pushNamed(
                                      context,
                                      'VideoCallScreen',
                                    );
                                  }
                                  : null,
                          context,

                          ButtonText(
                            cubit.isSessionStarted
                                ? "Start Meeting"
                                : "Wating ..",
                            context,
                            TextColor:
                                cubit.isSessionStarted
                                    ? Colors.white
                                    : MainColor,
                            FontSize: screenWidth(context) * 0.048,
                          ),

                          width: screenWidth(context) * 0.6,
                          height: screenHeight(context) * 0.0656,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
