import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:funid/presentation/screens/splash/splash_screen.dart';
import 'package:funid/presentation/screens/auth/login_screen.dart';
import 'package:funid/presentation/screens/auth/register_screen.dart';
import 'package:funid/presentation/screens/home/dashboard/dashboard_screen.dart';
import 'package:funid/presentation/screens/home/profile/profile_screen.dart';
import 'package:funid/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static CustomTransitionPage _buildPageTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const ProfileScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register' || state.matchedLocation == '/splash';

      if (!authProvider.isAuthenticated && !loggingIn) {
        return '/login';
      }
      return null;
    },
  );
}
