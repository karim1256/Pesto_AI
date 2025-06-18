
import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Onboard.dart';

class OnboardTwo extends StatelessWidget {
   const OnboardTwo({super.key});
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor,
      body: 
        Onboard(context,
        'The ability to scan and detect facial paralysis cases and their stage using artificial intelligence'
       ,'lib/Core/Assets/OnboardTwoPic.png',
           imageleft: screenWidth(context)*0.086,
          imagesize: screenWidth(context)*0.84,
          imagebottom: screenHeight(context)*0.45,secondContainer: true
        )

      );




    
  }
  }