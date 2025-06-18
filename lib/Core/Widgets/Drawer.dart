import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/ProfileAppBar.dart';
import 'package:gradutionproject/Features/LogIn/SignUp/AuthCubit/AuthCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double width = screenWidth(context);
    double height = screenHeight(context);
    double drawerWidth = width * 0.82; // 75% of screen width
    var s = supabase.auth.currentUser!.userMetadata!;
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Drawer(
        width: drawerWidth,
        child: Container(
          color: MainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.07,
                ),
                decoration: BoxDecoration(
                  color: MainColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Image
                    Stack(
                      children: [
                        ProfilePic(context),

                        Positioned(
                          bottom: 4,
                          right: width * 0.0567,
                          child: CircleAvatar(
                            radius: width * 0.032,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      "${s["first_name"]} ${s["last_name"]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.057,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              // Drawer Menu Items
              Expanded(
                child: Column(
                  children: [
                    _drawerItem(
                      Icons.person,
                      "Profile",
                      onTap: () {
                        Scaffold.of(context).closeDrawer();

                        cubit.handleIndexChanged(2);
                      },
                    ),
                    //     _drawerItem(Icons.favorite, "Favorite"),


                  supabase.auth.currentUser!.userMetadata!["doctoraccount"]
                        ?SizedBox(
                          height: 0,):
                        
                         _drawerItem(
                            Icons.star,
                            "Premium Account",
                            onTap: () {
                              Scaffold.of(context).closeDrawer();
                              Navigator.pushNamed(context, 'PremiumDetails');
                            },
                          ),
                       
                    _drawerItem(
                      Icons.payment,
                      "Payments",
                      onTap: () {
                        supabase.auth.currentUser!.userMetadata!["premium_account"]
                            ? cubit.startPaymentTimer()
                            :null;
                        Scaffold.of(context).closeDrawer();
                        Navigator.pushNamed(context, 'PremiumDetails');
                      },
                    ),
                    _drawerItem(Icons.settings, "Settings"),
                  ],
                ),
              ),

              Divider(color: Colors.white54, thickness: 1),

              // Sign Out Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: _drawerItem(
                  Icons.logout,
                  "Sign Out",
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    BlocProvider.of<Authcubit>(context).SignOut();
                    Navigator.pushReplacementNamed(context, 'SignIn');
                  },
                ),
              ),

              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer Item Widget
  Widget _drawerItem(IconData icon, String title, {void Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: onTap,
    );
  }
}
