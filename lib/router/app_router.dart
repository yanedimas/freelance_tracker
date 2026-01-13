import 'package:freelance_tasks/screens/add_screen.dart';
import 'package:freelance_tasks/screens/home_screen.dart';
import 'package:freelance_tasks/screens/order_detail_screen.dart';
import 'package:freelance_tasks/screens/order_update_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',  // Изменили начальный экран
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: orderId);
        }),
    GoRoute(
        path: '/update/:id',
        builder: (context, state){
          final orderId = state.pathParameters['id']!;
          return OrderUpdateScreen(orderId: orderId);
        }),
    GoRoute(path: '/add', builder: (context, state) => AddScreen()),
  ],
);
