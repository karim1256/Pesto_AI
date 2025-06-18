import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';

class CartifiedAccountPage extends StatelessWidget {
  const CartifiedAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight(context) * 0.06),
              Center(
                child: LoginUPFormat(
                  'Thank You!',
                  'Form Submitted Successfully',
                  context,
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.2),
              SizedBox(
                width: screenWidth(context) * 0.84,
                child: ralewayText(
                  'Thanks for your interest in helping Others. Our team will review your form and we will send you an email to activate your account.',
                  context,
                  fontSize: screenWidth(context) * 0.04,
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.2),

              ralewayText(
                'We wish you Success.',
                context,
                fontSize: screenWidth(context) * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
