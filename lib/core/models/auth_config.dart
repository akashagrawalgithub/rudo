class AuthConfig {
  final bool enableGoogleAuth;
  final bool enableAppleAuth;
  final bool enablePhoneAuth;
  final bool enableEmailAuth;
  final String? phoneAuthTestNumber;

  AuthConfig({
    this.enableGoogleAuth = true,
    this.enableAppleAuth = true,
    this.enablePhoneAuth = true,
    this.enableEmailAuth = true,
    this.phoneAuthTestNumber,
  });

  factory AuthConfig.fromJson(Map<String, dynamic> json) {
    return AuthConfig(
      enableGoogleAuth: json['enableGoogleAuth'] ?? true,
      enableAppleAuth: json['enableAppleAuth'] ?? true,
      enablePhoneAuth: json['enablePhoneAuth'] ?? true,
      enableEmailAuth: json['enableEmailAuth'] ?? true,
      phoneAuthTestNumber: json['phoneAuthTestNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableGoogleAuth': enableGoogleAuth,
      'enableAppleAuth': enableAppleAuth,
      'enablePhoneAuth': enablePhoneAuth,
      'enableEmailAuth': enableEmailAuth,
      'phoneAuthTestNumber': phoneAuthTestNumber,
    };
  }
}
