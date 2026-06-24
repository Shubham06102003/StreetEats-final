import 'package:go_router/go_router.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/auth/presentation/screens/auth_wrapper.dart';
import '../../features/vendor_application/presentation/screens/vendor_application_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/vendor/presentation/screens/vendor_dashboard_screen.dart';
import '../../features/location/presentation/screens/vendor_location_screen.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/menu/presentation/screens/add_menu_item_screen.dart';
import '../../features/vendor/presentation/screens/stall_profile_screen.dart';
import '../../features/customer/presentation/screens/customer_home_screen.dart';
import '../../features/customer/presentation/screens/vendor_details_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';

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
      path: '/stall-profile',
      builder: (context, state) => const StallProfileScreen(),
    ),
    GoRoute(
      path: '/vendor-location',
      builder: (context, state) => const VendorLocationScreen(),
    ),
    GoRoute(path: '/menu', builder: (context, state) => const MenuScreen()),

    GoRoute(
      path: '/add-menu-item',
      builder: (context, state) => const AddMenuItemScreen(),
    ),
    GoRoute(
      path: '/edit-menu-item',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return AddMenuItemScreen(
          menuItemId: data['id'],
          initialName: data['name'],
          initialPrice: data['price'],
          initialCategory: data['category'],
          initialDescription: data['description'],
          initialImageUrl: data['imageUrl'],
        );
      },
    ),
    GoRoute(
      path: '/customer-home',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    GoRoute(
      path: '/vendor-details',
      builder: (context, state) {
        final vendorId = state.extra as String;

        return VendorDetailsScreen(vendorId: vendorId);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);
