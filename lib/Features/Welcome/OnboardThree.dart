
import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Onboard.dart';

class OnboardThree extends StatelessWidget {
   const OnboardThree({super.key});
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor,
      body: 
        Onboard(context,
        'The ability to view doctors’ experiences, certificates, and previous evaluations from other patients, which enables you to choose the most suitable doctor easily.'
       ,'lib/Core/Assets/OnboardThreePic.png',
           imageleft: screenWidth(context)*0.05,
          imagesize: screenWidth(context)*0.87,
          imagebottom: screenHeight(context)*0.45,
          texttop: screenHeight(context)*0.67,thirdContainer: true
        )

      );




    
  }
  }