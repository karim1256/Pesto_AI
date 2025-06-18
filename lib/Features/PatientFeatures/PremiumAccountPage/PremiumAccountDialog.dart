import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';

void showPremiumAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Dismiss on tap outside
    builder: (context) {
      return Stack(
        children: [
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: screenWidth(context) * 0.82, // 85% of screen width
              height: screenHeight(context) * 0.86,
              padding: EdgeInsets.all(screenWidth(context) * 0.05),
              decoration: BoxDecoration(
                color: MainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                // mainAxisSize: MainAxisSize.min, // Adjust height dynamically
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: screenWidth(context) * 0.076,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Text(
                    "Premium Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth(context) * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: screenHeight(context) * 0.02),

                  Text(
                    "Unlock premium access to effortlessly book appointments with your ideal doctor, or choose from a list of currently available doctors! Explore detailed profiles with real patient reviews, ratings, experience, and certifications, ensuring you make the best choice for your healthcare needs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth(context) * 0.035,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: screenHeight(context) * 0.02),

                  MaterialButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, 'PremiumDetails');
                    },
                    child: Button(
                      context,
                      ButtonText("Details", context,),
                      ContainerColor: Colors.white,
                      TextColor: MainColor,
                      height: screenHeight(context) * 0.06,
                    ),
                  ),

                  SizedBox(height: screenHeight(context) * 0.02),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight(context) * -0.0069,
            left: screenWidth(context) * 0.006,
            child: Image.asset(
              'lib/Core/Assets/PremiumAccountPic2.png',
              width: screenWidth(context) * 1.1,
            ),
          ),
        ],
      );
    },
  );
}
