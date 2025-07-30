// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';
import 'profile_completion_screen.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_logger.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showResend = false;
  String _lastEmail = '';
  late AnimationController _animationController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _ctaPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _mapAuthError(String errorMsg) {
    final msg = errorMsg.toLowerCase();
    if (msg.contains('weak_password') ||
        msg.contains('password should be at least') ||
        msg.contains('6 characters')) {
      return 'Password must be at least 6 characters.';
    } else if (msg.contains('email_exists') ||
        msg.contains('user already exists') ||
        msg.contains('email address already exists')) {
      return 'An account with this email already exists.';
    } else if (msg.contains('invalid login credentials') ||
        msg.contains('invalid email or password')) {
      return 'Invalid email or password.';
    } else if (msg.contains('email not confirmed')) {
      return 'Please confirm your email before logging in.';
    } else if (msg.contains('invalid email')) {
      return 'Please enter a valid email address.';
    } else if (msg.contains('user not found')) {
      return 'No account found for this email.';
    } else if (msg.contains('rate limit') ||
        msg.contains('too many requests')) {
      return 'Too many attempts. Please try again later.';
    }
    return errorMsg;
  }

  void _submit(AuthService authService) async {
    if (!_formKey.currentState!.validate()) return;
    // Set email and password from controllers
    email = _emailController.text.trim();
    password = _passwordController.text;
    setState(() => error = '');
    try {
      if (isLogin) {
        appLogger.i('Attempting login for $email');
        await authService.signInWithEmail(email, password);
        if (!mounted) return;

        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          appLogger.i('Login successful for user: ${user.email}');
          // Fetch user profile from Supabase
          final List profileResult = await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', user.id)
              .limit(1);
          if (!mounted) return;

          final profile = profileResult.isNotEmpty ? profileResult.first : null;
          final hasName =
              profile != null &&
              (profile['name']?.toString().trim().isNotEmpty ?? false);
          final hasPhoto =
              profile != null &&
              (profile['photo']?.toString().isNotEmpty ?? false);
          if (!hasName || !hasPhoto) {
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileCompletionScreen(
                  userId: user.id,
                  email: user.email ?? '',
                ),
              ),
              (route) =>
                  false, // This removes all previous routes from the stack
            );
            return;
          }
        }
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false, // This removes all previous routes from the stack
        );
      } else {
        appLogger.i('Attempting signup for $email');
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );
        if (!mounted) return;
        setState(() {
          isLogin = true;
          error = 'Signup successful! Please log in.';
        });
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      final errorMsg = e.toString();
      appLogger.e(
        'Login/Profile error',
        error: errorMsg,
        stackTrace: stackTrace,
      );
      if (errorMsg.toLowerCase().contains('email not confirmed')) {
        setState(() {
          _showResend = true;
          _lastEmail = _emailController.text.trim();
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email Not Confirmed'),
            content: const Text(
              'Please check your email and confirm your account before logging in.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        final userFriendlyMsg = _mapAuthError(errorMsg);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(userFriendlyMsg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isWeb = kIsWeb;
    final illustrationWidget = Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Image.asset('assets/logos/app_logo.png', height: 64),
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(
            'assets/undraw_authentication_tbfc.svg',
            fit: BoxFit.contain,
            width: double.infinity,
            height: 300, // or any reasonable value
          ),
        ],
      ),
    );
    final formWidget = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return AnimatedSlide(
          offset: _slideAnim.value,
          duration: Duration.zero,
          child: AnimatedOpacity(
            opacity: _fadeAnim.value,
            duration: Duration.zero,
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            // Tab-like toggle with animation
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    left: isLogin ? 0 : MediaQuery.of(context).size.width / 2,
                    top: 0,
                    bottom: 0,
                    right: isLogin ? MediaQuery.of(context).size.width / 2 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!isLogin) {
                              setState(() => isLogin = true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isLogin
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: isLogin ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isLogin) {
                              setState(() => isLogin = false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isLogin
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: !isLogin ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    isEnabled: !authService.isLoading,
                    minlines: 1,
                    validator: (val) {
                      if (val == null || val.isEmpty || !val.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  CustomPasswordField(
                    hintText: 'Password',
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: _obscureText,
                    isEnabled: !authService.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        if (email.isEmpty || !email.contains('@')) {
                          setState(() {
                            error =
                                'Please enter a valid email to reset password.';
                          });
                          return;
                        }
                        setState(() {
                          error = '';
                        });
                        final result = await authService.sendPasswordResetEmail(
                          email,
                        );
                        if (result != null) {
                          setState(() {
                            error = result;
                          });
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password reset email sent. Please check your inbox.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (error.isNotEmpty)
                    AnimatedOpacity(
                      opacity: error.isNotEmpty ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _ctaPressed = true),
                    onTapUp: (_) => setState(() => _ctaPressed = false),
                    onTapCancel: () => setState(() => _ctaPressed = false),
                    onTap: authService.isLoading
                        ? () {}
                        : () => _submit(authService),
                    child: AnimatedScale(
                      scale: _ctaPressed ? 0.96 : 1.0,
                      duration: const Duration(milliseconds: 120),
                      child: CustomCTA(
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.primary,
                        text: isLogin ? 'Login' : 'Sign Up',
                        onPressed: authService.isLoading
                            ? () {}
                            : () => _submit(authService),
                        borderRadius: 8,
                        isLoading: authService.isLoading,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: authService.isLoading
                        ? null
                        : () {
                            setState(() {
                              isLogin = !isLogin;
                              error = '';
                            });
                          },
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (_showResend && _lastEmail.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await Supabase.instance.client.auth.resend(
                            type: OtpType.email,
                            email: _lastEmail,
                          );
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Verification Email Sent'),
                              content: Text(
                                'A new verification email has been sent to $_lastEmail.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to resend email: ${e.toString()}',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Resend Verification Email'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: isWeb
          ? LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Image.asset(
                                  'assets/logos/app_logo.png',
                                  height: 64,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SvgPicture.asset(
                                'assets/undraw_authentication_tbfc.svg',
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: 300,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return AnimatedSlide(
                              offset: _slideAnim.value,
                              duration: Duration.zero,
                              child: AnimatedOpacity(
                                opacity: _fadeAnim.value,
                                duration: Duration.zero,
                                child: child,
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                // Tab-like toggle with animation
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedPositioned(
                                        left: isLogin
                                            ? 0
                                            : MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2,
                                        top: 0,
                                        bottom: 0,
                                        right: isLogin
                                            ? MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2
                                            : 0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (!isLogin) {
                                                  setState(
                                                    () => isLogin = true,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isLogin
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    color: isLogin
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isLogin) {
                                                  setState(
                                                    () => isLogin = false,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: !isLogin
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    color: !isLogin
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      CustomTextField(
                                        hintText: 'Email',
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        isEnabled: !authService.isLoading,
                                        minlines: 1,
                                        validator: (val) {
                                          if (val == null ||
                                              val.isEmpty ||
                                              !val.contains('@')) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      CustomPasswordField(
                                        hintText: 'Password',
                                        controller: _passwordController,
                                        keyboardType: TextInputType.text,
                                        obscureText: _obscureText,
                                        isEnabled: !authService.isLoading,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                        validator: (val) {
                                          if (val == null || val.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () async {
                                            final email = _emailController.text
                                                .trim();
                                            if (email.isEmpty ||
                                                !email.contains('@')) {
                                              setState(() {
                                                error =
                                                    'Please enter a valid email to reset password.';
                                              });
                                              return;
                                            }
                                            setState(() {
                                              error = '';
                                            });
                                            final result = await authService
                                                .sendPasswordResetEmail(email);
                                            if (result != null) {
                                              setState(() {
                                                error = result;
                                              });
                                            } else {
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Password reset email sent. Please check your inbox.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      if (error.isNotEmpty)
                                        AnimatedOpacity(
                                          opacity: error.isNotEmpty ? 1.0 : 0.0,
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: Text(
                                              error,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                      GestureDetector(
                                        onTapDown: (_) =>
                                            setState(() => _ctaPressed = true),
                                        onTapUp: (_) =>
                                            setState(() => _ctaPressed = false),
                                        onTapCancel: () =>
                                            setState(() => _ctaPressed = false),
                                        onTap: authService.isLoading
                                            ? () {}
                                            : () => _submit(authService),
                                        child: AnimatedScale(
                                          scale: _ctaPressed ? 0.96 : 1.0,
                                          duration: const Duration(
                                            milliseconds: 120,
                                          ),
                                          child: CustomCTA(
                                            textColor: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            text: isLogin ? 'Login' : 'Sign Up',
                                            onPressed: authService.isLoading
                                                ? () {}
                                                : () => _submit(authService),
                                            borderRadius: 8,
                                            isLoading: authService.isLoading,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextButton(
                                        onPressed: authService.isLoading
                                            ? null
                                            : () {
                                                setState(() {
                                                  isLogin = !isLogin;
                                                  error = '';
                                                });
                                              },
                                        child: Text(
                                          isLogin
                                              ? "Don't have an account? Sign Up"
                                              : "Already have an account? Login",
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      if (_showResend &&
                                          _lastEmail.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              await Supabase
                                                  .instance
                                                  .client
                                                  .auth
                                                  .resend(
                                                    type: OtpType.email,
                                                    email: _lastEmail,
                                                  );
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text(
                                                    'Verification Email Sent',
                                                  ),
                                                  content: Text(
                                                    'A new verification email has been sent to $_lastEmail.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to resend email: ${e.toString()}',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Resend Verification Email',
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0,
                                bottom: 8.0,
                              ),
                              child: Image.asset(
                                'assets/logos/app_logo.png',
                                height: 64,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: SvgPicture.asset(
                                'assets/undraw_authentication_tbfc.svg',
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return AnimatedSlide(
                              offset: _slideAnim.value,
                              duration: Duration.zero,
                              child: AnimatedOpacity(
                                opacity: _fadeAnim.value,
                                duration: Duration.zero,
                                child: child,
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                // Tab-like toggle with animation
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedPositioned(
                                        left: isLogin
                                            ? 0
                                            : MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2,
                                        top: 0,
                                        bottom: 0,
                                        right: isLogin
                                            ? MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2
                                            : 0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (!isLogin) {
                                                  setState(
                                                    () => isLogin = true,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isLogin
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    color: isLogin
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isLogin) {
                                                  setState(
                                                    () => isLogin = false,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: !isLogin
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    color: !isLogin
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      CustomTextField(
                                        hintText: 'Email',
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        isEnabled: !authService.isLoading,
                                        minlines: 1,
                                        validator: (val) {
                                          if (val == null ||
                                              val.isEmpty ||
                                              !val.contains('@')) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      CustomPasswordField(
                                        hintText: 'Password',
                                        controller: _passwordController,
                                        keyboardType: TextInputType.text,
                                        obscureText: _obscureText,
                                        isEnabled: !authService.isLoading,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                        validator: (val) {
                                          if (val == null || val.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () async {
                                            final email = _emailController.text
                                                .trim();
                                            if (email.isEmpty ||
                                                !email.contains('@')) {
                                              setState(() {
                                                error =
                                                    'Please enter a valid email to reset password.';
                                              });
                                              return;
                                            }
                                            setState(() {
                                              error = '';
                                            });
                                            final result = await authService
                                                .sendPasswordResetEmail(email);
                                            if (result != null) {
                                              setState(() {
                                                error = result;
                                              });
                                            } else {
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Password reset email sent. Please check your inbox.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      if (error.isNotEmpty)
                                        AnimatedOpacity(
                                          opacity: error.isNotEmpty ? 1.0 : 0.0,
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: Text(
                                              error,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                      GestureDetector(
                                        onTapDown: (_) =>
                                            setState(() => _ctaPressed = true),
                                        onTapUp: (_) =>
                                            setState(() => _ctaPressed = false),
                                        onTapCancel: () =>
                                            setState(() => _ctaPressed = false),
                                        onTap: authService.isLoading
                                            ? () {}
                                            : () => _submit(authService),
                                        child: AnimatedScale(
                                          scale: _ctaPressed ? 0.96 : 1.0,
                                          duration: const Duration(
                                            milliseconds: 120,
                                          ),
                                          child: CustomCTA(
                                            textColor: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            text: isLogin ? 'Login' : 'Sign Up',
                                            onPressed: authService.isLoading
                                                ? () {}
                                                : () => _submit(authService),
                                            borderRadius: 8,
                                            isLoading: authService.isLoading,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextButton(
                                        onPressed: authService.isLoading
                                            ? null
                                            : () {
                                                setState(() {
                                                  isLogin = !isLogin;
                                                  error = '';
                                                });
                                              },
                                        child: Text(
                                          isLogin
                                              ? "Don't have an account? Sign Up"
                                              : "Already have an account? Login",
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      if (_showResend &&
                                          _lastEmail.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              await Supabase
                                                  .instance
                                                  .client
                                                  .auth
                                                  .resend(
                                                    type: OtpType.email,
                                                    email: _lastEmail,
                                                  );
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text(
                                                    'Verification Email Sent',
                                                  ),
                                                  content: Text(
                                                    'A new verification email has been sent to $_lastEmail.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to resend email: ${e.toString()}',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Resend Verification Email',
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 8.0,
                          ),
                          child: Image.asset(
                            'assets/logos/app_logo.png',
                            height: 64,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SvgPicture.asset(
                            'assets/undraw_authentication_tbfc.svg',
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return AnimatedSlide(
                        offset: _slideAnim.value,
                        duration: Duration.zero,
                        child: AnimatedOpacity(
                          opacity: _fadeAnim.value,
                          duration: Duration.zero,
                          child: child,
                        ),
                      );
                    },
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // ... form content ...
                            const SizedBox(height: 16),
                            // Tab-like toggle with animation
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    left: isLogin
                                        ? 0
                                        : MediaQuery.of(context).size.width / 2,
                                    top: 0,
                                    bottom: 0,
                                    right: isLogin
                                        ? MediaQuery.of(context).size.width / 2
                                        : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!isLogin) {
                                              setState(() => isLogin = true);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isLogin
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                color: isLogin
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (isLogin) {
                                              setState(() => isLogin = false);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: !isLogin
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                color: !isLogin
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  CustomTextField(
                                    hintText: 'Email',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    isEnabled: !authService.isLoading,
                                    minlines: 1,
                                    validator: (val) {
                                      if (val == null ||
                                          val.isEmpty ||
                                          !val.contains('@')) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomPasswordField(
                                    hintText: 'Password',
                                    controller: _passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: _obscureText,
                                    isEnabled: !authService.isLoading,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    validator: (val) {
                                      if (val == null || val.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () async {
                                        final email = _emailController.text
                                            .trim();
                                        if (email.isEmpty ||
                                            !email.contains('@')) {
                                          setState(() {
                                            error =
                                                'Please enter a valid email to reset password.';
                                          });
                                          return;
                                        }
                                        setState(() {
                                          error = '';
                                        });
                                        final result = await authService
                                            .sendPasswordResetEmail(email);
                                        if (result != null) {
                                          setState(() {
                                            error = result;
                                          });
                                        } else {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Password reset email sent. Please check your inbox.',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  if (error.isNotEmpty)
                                    AnimatedOpacity(
                                      opacity: error.isNotEmpty ? 1.0 : 0.0,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Text(
                                          error,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                  GestureDetector(
                                    onTapDown: (_) =>
                                        setState(() => _ctaPressed = true),
                                    onTapUp: (_) =>
                                        setState(() => _ctaPressed = false),
                                    onTapCancel: () =>
                                        setState(() => _ctaPressed = false),
                                    onTap: authService.isLoading
                                        ? () {}
                                        : () => _submit(authService),
                                    child: AnimatedScale(
                                      scale: _ctaPressed ? 0.96 : 1.0,
                                      duration: const Duration(
                                        milliseconds: 120,
                                      ),
                                      child: CustomCTA(
                                        textColor: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        text: isLogin ? 'Login' : 'Sign Up',
                                        onPressed: authService.isLoading
                                            ? () {}
                                            : () => _submit(authService),
                                        borderRadius: 8,
                                        isLoading: authService.isLoading,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: authService.isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              isLogin = !isLogin;
                                              error = '';
                                            });
                                          },
                                    child: Text(
                                      isLogin
                                          ? "Don't have an account? Sign Up"
                                          : "Already have an account? Login",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (_showResend && _lastEmail.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await Supabase.instance.client.auth
                                              .resend(
                                                type: OtpType.email,
                                                email: _lastEmail,
                                              );
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Verification Email Sent',
                                              ),
                                              content: Text(
                                                'A new verification email has been sent to $_lastEmail.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to resend email: ${e.toString()}',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Resend Verification Email',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
