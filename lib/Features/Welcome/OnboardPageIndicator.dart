import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';

class PageIndecator extends StatelessWidget {
  bool? firstContainer;
  bool? secondContainer;
  bool? thirdContainer;

  PageIndecator({
    this.firstContainer,
    this.secondContainer,
    this.thirdContainer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget Containers(bool selectedPage) {
      return Container(
        width:
            selectedPage
                ? screenWidth(context) * 0.078
                : screenWidth(context) * 0.033,
        height: screenHeight(context) * 0.02,
        margin: EdgeInsets.only(right: screenWidth(context) * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: BackGroundColor,
        ),
        child: Center(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Containers(firstContainer == null ? false : true),

        Containers(secondContainer == null ? false : true),

        Containers(thirdContainer == null ? false : true),
      ],
    );
  }
}
//OnboardOnePic.png