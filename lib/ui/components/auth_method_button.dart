import 'package:flutter/material.dart';
import 'package:rudo/core/models/auth_models.dart';

class AuthMethodButton extends StatelessWidget {
  final AuthMethod method;
  final VoidCallback onPressed;

  const AuthMethodButton({
    Key? key,
    required this.method,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (method) {
      case AuthMethod.email:
        return ElevatedButton.icon(
          icon: const Icon(Icons.email),
          label: const Text('Continue with Email'),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        );
      case AuthMethod.google:
        return ElevatedButton.icon(
          label: const Text('Continue with Google'),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        );
      case AuthMethod.apple:
        return ElevatedButton.icon(
          icon: const Icon(Icons.apple),
          label: const Text('Continue with Apple'),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        );
      case AuthMethod.phone:
        return ElevatedButton.icon(
          icon: const Icon(Icons.phone),
          label: const Text('Continue with Phone'),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        );
    }
  }
}
