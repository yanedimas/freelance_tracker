import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_event.dart';
import 'package:freelance_tasks/models/order.dart';
import 'package:freelance_tasks/router/app_router.dart';
import 'package:freelance_tasks/services/storage_service.dart';
import 'package:freelance_tasks/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OrderAdapter());
  await Hive.openBox<Order>('orders');
  await StorageService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(
        Hive.box<Order>('orders'),
      )..add(LoadOrders()),
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
      ),
    );
  }
}
