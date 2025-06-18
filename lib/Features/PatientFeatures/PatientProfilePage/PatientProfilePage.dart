import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/ProfileAppBar.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/DoctorsModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/PatientModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';

class PatientprofileVieawpage extends StatefulWidget {
  final PatientModel? patient;
  const PatientprofileVieawpage({super.key, this.patient});

  @override
  State<PatientprofileVieawpage> createState() =>
      _PatientprofileVieawpageState();
}

class _PatientprofileVieawpageState extends State<PatientprofileVieawpage> {
  bool _showPatientInfo = false;

  @override
  void initState() {
    super.initState();

    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    cubit.setImageUrl(null);
    if (supabase.auth.currentUser!.userMetadata!["doctoraccount"]) {
      widget.patient!.image == null || widget.patient!.image!.isEmpty
          ? cubit.setImageUrl(emptyPic)
          : cubit.setImageUrl(widget.patient!.image);
    } else {
      cubit.fetchImageUrl();
    }
  }

  Widget ProfileEditButtons(BuildContext context, String text, String page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, page);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: MainColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth(context) * 0.2),
        ),
      ),
      child: ralewayText(text, context, fontSize: screenWidth(context) * 0.04),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    final s = supabase.auth.currentUser!.userMetadata;
    final bool doctorAccount = s!["doctoraccount"];

    return Scaffold(
      bottomNavigationBar: doctorAccount ? null : CustomBottomBar(),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAppBar(
                context,
                notAllowed: doctorAccount ? true : false,
                height: 0.1,
                width: 2,
                backbutton: doctorAccount ? true : false,
                toppic: 0.02,
              ),
              SizedBox(height: bodyHeight(context) * 0.09),
              Text(
                doctorAccount
                    ? "${widget.patient!.first_name} ${widget.patient!.last_name}"
                    : "${s["first_name"]} ${s["last_name"]}",
                style: TextStyle(
                  fontSize: screenWidth(context) * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: bodyHeight(context) * 0.025),
        
              // Individual Patient Info Section - Only visible for doctors
              if (doctorAccount && widget.patient != null) ...[
                GestureDetector(
                  onTap:
                      () => setState(() => _showPatientInfo = !_showPatientInfo),
                  child: Container(
                    width: screenWidth(context) * 0.9,
                    height: screenHeight(context) * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MainColor),
                      color:
                          _showPatientInfo
                              ? Color.fromARGB(255, 199, 196, 196)
                              : Colors.white,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Patient Information",
                            style: TextStyle(
                              fontSize: screenWidth(context) * 0.04,
                              fontWeight: FontWeight.bold,
                              color: MainColor,
                            ),
                          ),
                          Icon(
                            _showPatientInfo
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: MainColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showPatientInfo) _buildPatientInfoCard(context),
                //   SizedBox(height: bodyHeight(context) * 0.02),
              ],
        
              doctorAccount == false && widget.patient == null
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileEditButtons(
                        context,
                        "Profile Info",
                        'EditPatientProfile',
                      ),
        
                      SizedBox(width: screenWidth(context) * 0.01),
                      ProfileEditButtons(
                        context,
                        "Medical Info",
                        'EditPatientMedical',
                      ),
                    ],
                  )
                  : SizedBox(height: bodyHeight(context) * 0),
                 SizedBox(height: bodyHeight(context) * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.05,
                ),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cubit.isExpanded.length,
                  itemBuilder: (context, index) {
                    return _buildSessionItem(
                      context,
                      "Session ${index + 1}",
                      index,
                      cubit,
                    );
                  },
                  separatorBuilder:
                      (_, __) => SizedBox(height: screenHeight(context) * 0.008),
                ),
              ),
              SizedBox(height: bodyHeight(context) * 0.032),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.86,
      padding: EdgeInsets.all(screenWidth(context) * 0.04),
      margin: EdgeInsets.only(
        top: screenHeight(context) * 0.006,
        bottom: screenHeight(context) * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(color: MainColor, width: 1.5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Personal Information:", context),
          _textRow(
            "Name:",
            "${widget.patient!.first_name} ${widget.patient!.last_name}",
            context,
          ),
          _textRow("Email:", widget.patient!.email ?? "N/A", context),

          _sectionTitle("Medical Information:", context),
          _textRow("Species:", widget.patient!.species ?? "N/A", context),
          _textRow("Breed:", widget.patient!.breed ?? "N/A", context),
          _textRow("Gender:", widget.patient!.gender ?? "N/A", context),
          _textRow("Age:", widget.patient!.age?.toString() ?? "N/A", context),

          _sectionTitle("Medical History:", context),
          _bulletPoint(
            widget.patient!.history ?? "No history provided",
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(
    BuildContext context,
    String title,
    int index,
    var cubit,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => cubit.expandSession(index),
          child: Container(
            width: screenWidth(context) * 0.9,
            height: screenHeight(context) * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MainColor),
              color:
                  cubit.isExpanded[index]
                      ? Color.fromARGB(255, 199, 196, 196)
                      : Colors.white,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: MainColor,
                    ),
                  ),
                  Icon(
                    cubit.isExpanded[index]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: MainColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (cubit.isExpanded[index]) _expandedSessionCard(context, index),
      ],
    );
  }

  Widget _expandedSessionCard(BuildContext context, index) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    DoctorModel doctor = cubit.GetDoctor(cubit.sessions[index].doctorId);
    return Container(
      width: screenWidth(context) * 0.86,
      padding: EdgeInsets.all(screenWidth(context) * 0.04),
      margin: EdgeInsets.only(
        top: screenHeight(context) * 0.006,
        bottom: screenHeight(context) * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(color: MainColor, width: 1.5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textRow("Doctor Name: ", doctor.name, context, link: " See Profile"),
          _textRow("Date: ", cubit.sessions[index].date, context),
          SizedBox(height: screenHeight(context) * 0.015),
          _sectionTitle("Medical History:", context),
          _bulletPoint(cubit.sessions[index].history, context),
          _sectionTitle("Preliminary Diagnosis:", context),
          _bulletPoint(cubit.sessions[index].diagnosis, context),
          _sectionTitle("Doctor's Recommendations:", context),
          _bulletPoint(cubit.sessions[index].recommendation, context),
        ],
      ),
    );
  }
}

Widget _textRow(
  String label,
  String value,
  BuildContext context, {
  String? link,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: screenHeight(context) * 0.005),
    child: RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: screenWidth(context) * 0.04,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.w500)),
          if (link != null)
            TextSpan(
              text: " $link",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _sectionTitle(String title, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      top: screenHeight(context) * 0.015,
      bottom: screenHeight(context) * 0.005,
    ),
    child: Text(
      title,
      style: TextStyle(
        fontSize: screenWidth(context) * 0.045,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  );
}

Widget _bulletPoint(String text, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      left: screenWidth(context) * 0.04,
      bottom: screenHeight(context) * 0.008,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ", style: TextStyle(fontSize: screenWidth(context) * 0.05)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: screenWidth(context) * 0.04),
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}
