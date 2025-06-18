import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/HomePage.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';

class PremiumAccountDetails extends StatelessWidget {
  const PremiumAccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min, // Adjust height dynamically
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: screenWidth(context) * 0.07,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // SizedBox(height: screenHeight(context) * 0.05),
                SizedBox(
                  width: screenWidth(context) * 0.9,

                  child: ralewayText(
                    "Premium Account",

                    context,
                    fontSize: screenWidth(context) * 0.09,
                    fontWeight: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                ),

                
                //SizedBox(height: screenHeight(context) * 0.05),
                Text(
                    supabase.auth.currentUser!.userMetadata!["premium_account"]?
                  cubit.paymentCount:"",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth(context) * 0.08,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight(context) * 0.03),

                SizedBox(
                  width: screenWidth(context) * 0.6,

                  child: ralewayText(
                    '500 EGP/month',
                    color: Colors.black,
                    context,
                    fontSize: screenWidth(context) * 0.06,
                  ),
                ),

                //  SizedBox(height: screenHeight(context) * 0.01),
                SizedBox(
                  width: screenWidth(context) * 0.92,
                  child: Text(
                    "Unlock premium access to effortlessly book appointments with your ideal doctor.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth(context) * 0.05,
                      color: MainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight(context) * 0.02),

                // Details Button
                Button(
                  onPressed: () {
                      
                    supabase.auth.currentUser!.userMetadata!["premium_account"]?
                    buildSnackBar(context,"You already subscribe", MainColor)
                    :
                    Navigator.pushNamed(context, 'payment');
                  },
                  context,
                  ButtonText(
                    "Subscribe",
                    context,
                    TextColor: Colors.white,
                    FontSize: screenWidth(context) * 0.05,
                  ),
                  ContainerColor: MainColor,

                  TextColor: Colors.white,
                  height: screenHeight(context) * 0.07,
                  width: screenHeight(context) * 0.25,
                ),

                SizedBox(height: screenHeight(context) * 0.02),
              ],
            ),
          ),
          SizedBox(width: double.infinity),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'lib/Core/Assets/PremiumAccountPic2.png',

              width: screenWidth(context) * 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
