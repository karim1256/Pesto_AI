import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<Color?> _bgColor;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textPosition;
  late Animation<double> _pulseAnimation;

  bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentSession != null;
  }

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _logoRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _bgColor = ColorTween(
      begin: Colors.white,
      end: BackGroundColor,
    ).animate(_controller);

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn), 
      ),
    );

    _textPosition = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.fastOutSlowIn), 
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().whenComplete(() {
      final user = Supabase.instance.client.auth.currentUser;
      String route;
      
      if (user == null) {
        route = 'OnboardOne';
      } else {
        final meta = user.userMetadata ?? {};
        if (meta["doctoraccount"] == true) {
          route = meta['certificates'] == null ? "GetDoctordata" : 'MainPage';
        } else {
          route = meta['bread'] == null ? 'GetPatientdata' : 'MainPage';
        }
      }
      
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bgColor.value,
          body: Center(
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: _logoRotation.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset(
                        "lib/Core/Assets/Logo.png",
                        width: screenWidth(context) * 0.43,
                      ),
                    ),
                  ),
            //      const SizedBox(height: 20),
                  SlideTransition(
                    position: _textPosition,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: ralewayText(
                        "Petso_AI",
                        context,
                        color: const Color.fromARGB(225, 91, 41, 162),
                        fontSize: screenWidth(context) * 0.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}