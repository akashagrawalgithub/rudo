import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

enum AuthMethod { email, google, apple, phone }

class AuthConfig {
  final List<AuthMethod> enabledMethods;
  final String? logoUrl;
  final String? welcomeText;
  final String? loginButtonText;
  final String? registerButtonText;

  AuthConfig({
    required this.enabledMethods,
    this.logoUrl,
    this.welcomeText,
    this.loginButtonText,
    this.registerButtonText,
  });

  factory AuthConfig.fromJson(Map<String, dynamic> json) {
    List<AuthMethod> methods = [];
    if (json['methods'] != null) {
      for (var method in json['methods']) {
        switch (method) {
          case 'email':
            methods.add(AuthMethod.email);
            break;
          case 'google':
            methods.add(AuthMethod.google);
            break;
          case 'apple':
            methods.add(AuthMethod.apple);
            break;
          case 'phone':
            methods.add(AuthMethod.phone);
            break;
        }
      }
    }

    return AuthConfig(
      enabledMethods: methods,
      logoUrl: json['logoUrl'],
      welcomeText: json['welcomeText'],
      loginButtonText: json['loginButtonText'],
      registerButtonText: json['registerButtonText'],
    );
  }
}

class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;

  User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  factory User.fromFirebase(firebase_auth.User firebaseUser) {
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }
}
