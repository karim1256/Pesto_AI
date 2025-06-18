import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/Authstates.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<Authcubit>(context);

    return Scaffold(
      backgroundColor: BackGroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth(context) * 0.13,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoginUPFormat(
                    'Hello Again!',
                    "Fill Your Details Or Continue With Social Media",
                    context,
                  ),
                  SizedBox(height: bodyHeight(context) * 0.08),

                  buildTextField(
                    emailController,
                    "Email Address",
                    context,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email Address is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: bodyHeight(context) * 0.01),

                  buildTextField(
                    passwordController,
                    "Password",
                    context,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),

                  // SizedBox(height: bodyHeight(context) * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'ForgetPassword');
                      },
                      child: ralewayText("Forgot Password?", context),
                    ),
                  ),

                  SizedBox(height: bodyHeight(context) * 0.02),
                  BlocConsumer<Authcubit, AuthStates>(
                    listener: (context, state) {
                      if (state is LogInSucceedState) {
                        if (cubit.DoctorAccount!) {
                          Navigator.pushReplacementNamed(
                            context,

                            cubit.userMetadata!['certificates'] == null
                                ? "GetDoctordata"
                                : 'MainPage',
                          );
                        } else {
                          Navigator.pushReplacementNamed(
                            context,

                            cubit.userMetadata!['bread'] == null
                                ? 'GetPatientdata'
                                : 'MainPage',
                          );
                        }

                        buildSnackBar(
                          context,
                          "Login successful",
                          Colors.green,
                        );
                      } else if (state is LogInFailureState) {
                        buildSnackBar(context, state.Message, Colors.red);
                      }
                    },
                    builder: (context, state) {
                      return Button(
                        context,
                        state is LogInLoadingState
                            ? Loading(color: Colors.white)
                            : ButtonText(
                              "Log In",
                              context,
                              TextColor: BackGroundColor,
                            ),
                        width: screenWidth(context) * 0.74,
                        height: bodyHeight(context) * 0.07,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            cubit.LogIn(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: bodyHeight(context) * 0.03),

                  // Button(
                  //   context,
                  //   ButtonText("Sign In with Google", context),
                  //   width: screenWidth(context) * 0.74,
                  //   height: bodyHeight(context) * 0.07,
                  //   ContainerColor: Colors.white,
                  //   TextColor: Colors.black,
                  // ),
                  SizedBox(height: bodyHeight(context) * 0.075),

                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'UserType');
                    },
                    child: ralewayText(
                      "I dont have account ?",
                      context,
                      fontSize: screenWidth(context) * 0.045,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
