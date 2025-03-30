import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rudo/bloc/auth/auth_bloc.dart';
import 'package:rudo/bloc/auth/auth_event.dart';
import 'package:rudo/bloc/auth/auth_state.dart';
import 'package:rudo/bloc/theme/theme_bloc.dart';
import 'package:rudo/core/repositories/auth_repository.dart';
import 'package:rudo/core/services/auth_service.dart';
import 'package:rudo/core/services/theme_service.dart';
import 'package:rudo/ui/screen/login_screen.dart';
import 'package:rudo/ui/screen/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(create: (context) => AuthService()),
        RepositoryProvider<AuthRepository>(
          create:
              (context) =>
                  AuthRepository(authService: context.read<AuthService>()),
        ),
        RepositoryProvider<ThemeService>(create: (context) => ThemeService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>())
                      ..add(AppStarted()),
          ),
          BlocProvider<ThemeBloc>(
            create:
                (context) =>
                    ThemeBloc(themeService: context.read<ThemeService>())
                      ..add(ThemeStarted()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            final themeService = context.read<ThemeService>();
            final themeData = themeService.getThemeData(themeState.config);

            return MaterialApp(
              title: 'Rudo App',
              theme: themeData,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return const DashboardScreen();
                  }
                  return const LoginScreen();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
