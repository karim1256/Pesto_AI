import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit= BlocProvider.of<Authcubit>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: BackGroundColor,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: screenHeight(context) * 0.1),
                  ralewayText(
                    "You Are ?",
                    context,
                    fontSize: screenWidth(context) * 0.1,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight(context) * 0.15),

                  Button(
                   context,
                          ButtonText( "Pet Owner", context,
                          TextColor: Colors.white
                          
                          )
                    ,
                    width: screenHeight(context) * 0.3,
                    TextColor: Colors.white,
                    onPressed: () {
                      cubit.DoctorAccount = false;
                      Navigator.pushNamed(context, 'SignUp');
                    },
                  ),
                  SizedBox(height: screenHeight(context) * 0.008),

                  ralewayText(
                    "OR",
                    context,
                    fontSize: screenWidth(context) * 0.052,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight(context) * 0.008),

                  Button(
                    context,
                          ButtonText( "Veterinary Doctor", context)

                    ,
                    width: screenHeight(context) * 0.3,
                    ContainerColor: Colors.white,
                    TextColor: MainColor,
                    onPressed: () {
                      cubit.DoctorAccount = true;
                      Navigator.pushNamed(context, 'SignUp');
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                "lib/Core/Assets/Doctor.png",
                width: screenWidth(context) * 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
