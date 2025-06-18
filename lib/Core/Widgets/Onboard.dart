import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/Welcome/OnboardPageIndicator.dart';

Widget Onboard(
  BuildContext context,
  String text,
  String image, {
  double? imagesize,
  double? imagebottom,
  double? imageleft,
  double? imageright,
  double? texttop,
  bool? firstContainer,
  bool? secondContainer,
  bool? thirdContainer,
}) {
  var cubit = BlocProvider.of<Authcubit>(context, listen: true);

  return Stack(
    children: [
      // Image positioned at the bottom (under the container)
      Positioned(
        left: imageleft,
        bottom: imagebottom, // Adjusted to appear below container
        child: Image.asset(image, width: imagesize),
      ),

      // The colored container
      Positioned(
        bottom: 0,
        child: Container(
          height: screenHeight(context) * 0.42,
          width: screenWidth(context),
          decoration: BoxDecoration(
            color: MainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
        ),
      ),

      // Text content
      Positioned(
        left: screenWidth(context) * 0.048,
        top: texttop ?? screenHeight(context) * 0.71,
        child: SizedBox(
          width: screenWidth(context) * 0.9,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth(context) * 0.042,
            ),
          ),
        ),
      ),

      // Page indicator
      Positioned(
        top: screenHeight(context) * 0.63,
        right: screenWidth(context) * 0.42,
        child: PageIndecator(
          firstContainer: cubit.index == 0 ? true : null,
          secondContainer: cubit.index == 1 ? true : null,
          thirdContainer: cubit.index == 2 ? true : null,
        ),
      ),

      // Buttons
      Positioned(
        top: screenHeight(context) * 0.86,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              context,
              ContainerColor: Colors.white,
              TextColor: MainColor,
              height: screenHeight(context) * 0.06,
              ButtonText("Get Started", context),
              onPressed: () {
                if (cubit.index == 2) {
                  Navigator.pushReplacementNamed(context, 'SignIn');
                } else {
                  cubit.onboardingNavigate();
                }
              },
            ),
            //  SizedBox(width: screenWidth(context) * -0.1),
            Button(
              context,
              ContainerColor: Colors.white,
              TextColor: MainColor,
              height: screenHeight(context) * 0.06,
              ButtonText("Skip", context),
              onPressed:
                  () => Navigator.pushReplacementNamed(context, 'SignIn'),
            ),
          ],
        ),
      ),
    ],
  );
}
