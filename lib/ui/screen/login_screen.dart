import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rudo/bloc/auth/auth_bloc.dart';
import 'package:rudo/bloc/auth/auth_event.dart';
import 'package:rudo/bloc/auth/auth_state.dart';
import 'package:rudo/ui/components/auth_button.dart';
import 'package:rudo/ui/components/auth_divider.dart';
import 'package:rudo/ui/components/auth_text_field.dart';
import 'package:rudo/ui/components/social_auth_button.dart';
import 'package:rudo/ui/screen/signup_screen.dart';
import 'package:rudo/ui/screen/dashboard_screen.dart';
import 'package:rudo/ui/screen/phone_auth_screen.dart';
import 'package:rudo/core/services/auth_config_service.dart';
import 'package:rudo/core/models/auth_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  AuthConfig? _authConfig;

  @override
  void initState() {
    super.initState();
    _loadAuthConfig();
  }

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
          } else if (state is PhoneVerificationInProgress) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => PhoneAuthScreen()));
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
                  'Welcome back',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to your account to continue',
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
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AuthButton(
                      text: 'Sign in',
                      isLoading: state is AuthLoading,
                      onPressed: _signInWithEmail,
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
                        const TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign up",
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
        if (_authConfig?.enableGoogleAuth ?? true)
          SocialAuthButton(
            icon: Image.asset('assets/images/google_logo.png', height: 24),
            text: 'Continue with Google',
            onPressed:
                () => context.read<AuthBloc>().add(SignInWithGoogleRequested()),
          ),
        if (_authConfig?.enableGoogleAuth ?? true) const SizedBox(height: 16),
        if (_authConfig?.enableAppleAuth ?? true)
          SocialAuthButton(
            icon: const Icon(Icons.apple, size: 24),
            text: 'Continue with Apple',
            onPressed:
                () => context.read<AuthBloc>().add(SignInWithAppleRequested()),
          ),
        if (_authConfig?.enableAppleAuth ?? true) const SizedBox(height: 16),
        if (_authConfig?.enablePhoneAuth ?? true)
          SocialAuthButton(
            icon: const Icon(Icons.send, size: 24),
            text: 'Continue with Phone',
            onPressed: _showPhoneLoginDialog,
          ),
      ],
    );
  }

  void _signInWithEmail() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      SignInWithEmailPasswordRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _showPhoneLoginDialog() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PhoneAuthScreen()));
  }

  Future<void> _loadAuthConfig() async {
    if (!mounted) return;
    final configService = AuthConfigService();
    _authConfig = await configService.getAuthConfig();
    if (mounted) {
      setState(() {});
    }
  }
}
