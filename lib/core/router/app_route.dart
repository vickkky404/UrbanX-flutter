import 'package:go_router/go_router.dart';
import 'package:urban_x/features/splash/screens/splash_screen.dart';
import 'package:urban_x/features/auth/screens/login_screen.dart';
import 'package:urban_x/features/dashboard/screens/dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);