import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rudo/bloc/auth/auth_bloc.dart';
import 'package:rudo/bloc/auth/auth_event.dart';
import 'package:rudo/bloc/auth/auth_state.dart';
import 'package:rudo/ui/components/auth_button.dart';
import 'package:rudo/ui/components/auth_divider.dart';
import 'package:rudo/ui/components/auth_text_field.dart';
import 'package:rudo/ui/components/social_auth_button.dart';
import 'package:rudo/ui/screen/login_screen.dart';
import 'package:rudo/ui/screen/dashboard_screen.dart';
import 'package:rudo/ui/screen/phone_auth_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Create account',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to get started',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Must be at least 8 characters long',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AuthButton(
                      text: 'Create account',
                      isLoading: state is AuthLoading,
                      onPressed: _createAccount,
                    );
                  },
                ),
                const SizedBox(height: 24),
                const AuthDivider(text: 'or continue with'),
                const SizedBox(height: 24),
                _buildSocialLoginButtons(),
                const SizedBox(height: 40),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SocialAuthButton(
          icon: Image.asset('assets/images/google_logo.png', height: 24),
          text: 'Continue with Google',
          onPressed:
              () => context.read<AuthBloc>().add(SignInWithGoogleRequested()),
        ),
        const SizedBox(height: 16),
        SocialAuthButton(
          icon: const Icon(Icons.apple, size: 24),
          text: 'Continue with Apple',
          onPressed:
              () => context.read<AuthBloc>().add(SignInWithAppleRequested()),
        ),
        const SizedBox(height: 16),
        SocialAuthButton(
          icon: const Icon(Icons.send, size: 24),
          text: 'Continue with Phone',
          onPressed: _showPhoneSignupDialog,
        ),
      ],
    );
  }

  void _createAccount() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      RegisterWithEmailPasswordRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _showPhoneSignupDialog() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PhoneAuthScreen()));
  }
}
