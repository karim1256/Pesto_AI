import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/Authstates.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<Authcubit>(context);

    return Scaffold(
      backgroundColor: BackGroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocConsumer<Authcubit, AuthStates>(
            listener: (context, state) {
              if (state is RegisterSucceedState) {
                Navigator.pushReplacementNamed(context, 'SignIn');
                buildSnackBar(context, "Activate your account", Colors.green);
              } else if (state is RegisterFailureState) {
                buildSnackBar(context, state.Message, Colors.red);
              }
            },
            builder: (BuildContext context, AuthStates state) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.13,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: bodyHeight(context) * 0.04),
                          LoginUPFormat(
                            'Register Account',
                            "Fill your details or continue with social media",
                            context,
                          ),
                          SizedBox(height: bodyHeight(context) * 0.05),

                          buildTextField(
                            firstNameController,
                            "First Name",
                            context,
                            hinttext: '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First Name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: bodyHeight(context) * 0.012),

                          buildTextField(
                            lastNameController,
                            "Last Name",
                            context,
                            hinttext: '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last Name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: bodyHeight(context) * 0.012),

                          buildTextField(
                            emailController,
                            "Email Address",
                            context,
                            hinttext: '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email Address is required';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: bodyHeight(context) * 0.012),

                          buildTextField(
                            passwordController,
                            "Password",
                            context,
                            hinttext: '',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: bodyHeight(context) * 0.012),

                          buildTextField(
                            confirmPasswordController,
                            "Confirm Password",
                            context,
                            hinttext: '',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password is required';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: bodyHeight(context) * 0.045),

                          Button(
                            context,

                            state is RegisterLoadingState
                                ? Loading(color: Colors.white)
                                : ButtonText(
                                  "Sign Up",
                                  context,
                                  TextColor: Colors.white,
                                ),
                            width: screenWidth(context) * 0.74,
                            height: bodyHeight(context) * 0.07,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                cubit.Register(
                                  firstNameController.text,
                                  lastNameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                          ),
                          SizedBox(height: bodyHeight(context) * 0.03),

                          //   Button(
                          //     context,
                          //  ButtonText("SignUp with Google",context)   ,
                          //     width: screenWidth(context) * 0.74,
                          //     height: bodyHeight(context) * 0.07,
                          //     ContainerColor: Colors.white,
                          //     TextColor: Colors.black,
                          //     fontsize: screenWidth(context) * 0.039,
                          //   ),
                          //   SizedBox(height: bodyHeight(context) * 0.025),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'SignIn');
                            },
                            child: ralewayText(
                              "I have account ?",
                              context,
                              fontSize: screenWidth(context) * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
