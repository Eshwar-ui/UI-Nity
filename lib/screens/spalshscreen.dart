import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding_screen.dart';
import 'main_screen.dart';
import 'login_screen.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2s
    final prefs = await SharedPreferences.getInstance();
    final bool? onboardingSeen = kIsWeb
        ? true
        : prefs.getBool('onboarding_seen');
    if (onboardingSeen != true) {
      await prefs.setBool('onboarding_seen', true);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        createSlideRoute(const OnboardingScreen()),
        (route) => false, // This removes all previous routes from the stack
      );
      return;
    }
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        createSlideRoute(const MainScreen()),
        (route) => false, // This removes all previous routes from the stack
      );
    } else {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        createSlideRoute(const LoginScreen()),
        (route) => false, // This removes all previous routes from the stack
      );
    }
  }

  Route createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const Text(
                  'UI Design Hub',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
