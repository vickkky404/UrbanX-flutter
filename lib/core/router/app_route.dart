import 'package:go_router/go_router.dart';
import 'package:urban_x/features/splash/screens/splash_screen.dart';
import 'package:urban_x/features/auth/screens/login_screen.dart';
import 'package:urban_x/features/auth/screens/signup_screen.dart';
import 'package:urban_x/features/dashboard/screens/home_screen_v2.dart';
import 'package:urban_x/features/dashboard/screens/dashboard_screen.dart';
import 'package:urban_x/features/dashboard/screens/ride_type_selection_screen.dart';
import 'package:urban_x/features/dashboard/screens/ride_details_screen.dart';
import 'package:urban_x/features/dashboard/screens/ride_confirmation_screen.dart';
import 'package:urban_x/features/dashboard/screens/active_ride_screen.dart';
import 'package:urban_x/features/dashboard/screens/ride_complete_screen.dart';
import 'package:urban_x/features/dashboard/screens/ride_history_screen.dart';
import 'package:urban_x/features/profile/screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreenV2(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/ride-type-selection',
      builder: (context, state) => const RideTypeSelectionScreen(),
    ),
    GoRoute(
      path: '/ride-details',
      builder: (context, state) => const RideDetailsScreen(),
    ),
    GoRoute(
      path: '/ride-confirmation',
      builder: (context, state) => const RideConfirmationScreen(),
    ),
    GoRoute(
      path: '/active-ride',
      builder: (context, state) => const ActiveRideScreen(),
    ),
    GoRoute(
      path: '/ride-complete',
      builder: (context, state) => const RideCompleteScreen(),
    ),
    GoRoute(
      path: '/ride-history',
      builder: (context, state) => const RideHistoryScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);