# Rudo App

A modern Flutter application with a dynamic UI system, theme customization, and comprehensive authentication.

## Features

- Dynamic UI System: Build UI components from JSON configurations
- Theme Customization: Toggle between light and dark modes with true black AMOLED support
- Authentication: Multiple sign-in methods including email/password, Google, Apple, and phone verification
- BLoC Architecture: Clean separation of UI, business logic, and data layers
- Responsive Design: Adapts to different screen sizes and orientations

# Getting Started

## Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK (^3.7.2)
- Firebase account for authentication services


## Project Structure

lib/
├── bloc/           # BLoC pattern implementation
│   ├── auth/       # Authentication BLoCs
│   └── theme/      # Theme management BLoCs
├── core/           # Core functionality
│   ├── repositories/ # Data repositories
│   └── services/   # Business logic services
├── ui/             # UI components
│   ├── screen/     # App screens
│   └── widgets/    # Reusable widgets
└── main.dart       # Entry point


## Authentication

The app supports multiple authentication methods:
- Email/Password
- Google Sign-In
- Apple Sign-In
- Phone verification

## Theming

The app supports:
- Light mode
- Dark mode
- True black AMOLED mode
- Dynamic UI


## Dynamic UI

UI components can be defined using JSON configuration, allowing for:
- Dynamic layouts
- Server-driven UI updates

## Architecture

The app follows the BLoC (Business Logic Component) pattern:
- BLoC Layer: Manages state and business logic
- Repository Layer: Abstracts data sources
- Service Layer: Handles external services (Firebase, etc.)
- UI Layer: Presents data and captures user input

