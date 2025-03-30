import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rudo/core/services/theme_service.dart';
import 'package:rudo/core/models/theme_config.dart';

// Events
abstract class ThemeEvent {}

class ThemeStarted extends ThemeEvent {}

class ThemeToggled extends ThemeEvent {}

class ThemeUpdated extends ThemeEvent {
  final ThemeConfig config;
  ThemeUpdated(this.config);
}

// States
abstract class ThemeState {
  final ThemeConfig config;
  ThemeState(this.config);
}

class ThemeInitial extends ThemeState {
  ThemeInitial(super.config);
}

class ThemeLoaded extends ThemeState {
  ThemeLoaded(super.config);
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeService _themeService;

  ThemeBloc({required ThemeService themeService})
    : _themeService = themeService,
      super(ThemeInitial(ThemeConfig())) {
    on<ThemeStarted>(_onThemeStarted);
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeUpdated>(_onThemeUpdated);
  }

  Future<void> _onThemeStarted(
    ThemeStarted event,
    Emitter<ThemeState> emit,
  ) async {
    final config = await _themeService.getThemeConfig();
    emit(ThemeLoaded(config));
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final config = await _themeService.toggleDarkMode();
    emit(ThemeLoaded(config));
  }

  void _onThemeUpdated(ThemeUpdated event, Emitter<ThemeState> emit) {
    emit(ThemeLoaded(event.config));
    _themeService.saveThemeConfig(event.config);
  }
}
