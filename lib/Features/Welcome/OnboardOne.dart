import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Onboard.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';

class OnboardOne extends StatelessWidget {
  const OnboardOne({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<Authcubit>(context, listen: true);
    return Scaffold(
      backgroundColor: BackGroundColor,
      body: Onboard(
        context,
        cubit.Boarding[cubit.index]['title'],
        cubit.Boarding[cubit.index]['image'],
        imagebottom:
            cubit.index == 0
                ? screenHeight(context) * 0.37
                : cubit.index == 1
                ? screenHeight(context) * 0.42
                : screenHeight(context) * 0.41,
        imagesize:
            cubit.index == 0
                ? screenWidth(context) * 1.3
                : cubit.index == 1
                ? screenWidth(context)
                : screenWidth(context),
        imageleft:
            cubit.index == 0
                ? screenWidth(context) * -0.18
                : cubit.index == 1
                ? screenWidth(context) * -0.04
                : screenWidth(context) * -0.006,
      ),
    );
  }
}
