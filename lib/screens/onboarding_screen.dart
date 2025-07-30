import 'package:design_editor_app/screens/login_screen.dart';
import 'package:design_editor_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Spacer(),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/customize_ui.png'),
                  fit: BoxFit.contain,
                ),
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
            const Spacer(),
            CustomButton(
              onPressed: _isloading
                  ? () {}
                  : () {
                      setState(() => _isloading = true);
                      Future.delayed(const Duration(seconds: 3), () {
                        if (!mounted) return;
                        setState(() => _isloading = false);
                        Navigator.pushAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) =>
                              false, // This removes all previous routes from the stack
                        );
                      });
                    },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _isloading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            'Get Started',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
