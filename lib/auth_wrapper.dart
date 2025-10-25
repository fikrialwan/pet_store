import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'app_router.dart';
import 'injection_container.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AppStarted()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return MaterialApp.router(
              title: 'Pet Store',
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(),
              routerConfig: appRouter,
            );
          } else {
            // For all non-authenticated states (loading, error, unauthenticated)
            // Use a single MaterialApp that doesn't rebuild
            return MaterialApp(
              title: 'Pet Store',
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(),
              home: _buildAuthContent(context, state),
            );
          }
        },
      ),
    );
  }

  Widget _buildAuthContent(BuildContext context, AuthState state) {
    if (state is AuthLoading || state is AuthInitial) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // AuthUnauthenticated or AuthError - show login screen
      return BlocProvider.value(
        value: context.read<AuthBloc>(),
        child: const LoginScreen(),
      );
    }
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade900,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}