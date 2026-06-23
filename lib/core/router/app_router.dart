import 'package:go_router/go_router.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/auth/presentation/screens/auth_wrapper.dart';
import '../../features/vendor_application/presentation/screens/vendor_application_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthWrapper()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/vendor-application',
      builder: (context, state) => const VendorApplicationScreen(),
    ),
  ],
);
