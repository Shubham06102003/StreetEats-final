import 'package:go_router/go_router.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/auth/presentation/screens/auth_wrapper.dart';
import '../../features/vendor_application/presentation/screens/vendor_application_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/vendor/presentation/screens/vendor_dashboard_screen.dart';
import '../../features/location/presentation/screens/vendor_location_screen.dart';

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
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/vendor-dashboard',
      builder: (context, state) => const VendorDashboardScreen(),
    ),
    GoRoute(
      path: '/vendor-location',
      builder: (context, state) => const VendorLocationScreen(),
    ),
  ],
);
