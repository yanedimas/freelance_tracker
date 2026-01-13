import 'package:freelance_tasks/models/order.dart';

class OrderState {
  final List<Order> orders;
  final double goal;

  OrderState({required this.orders, required this.goal});

  factory OrderState.initial() {
    return OrderState(orders: [], goal: 0);
  }

  OrderState copyWith({List<Order>? orders, double? goal}) {
    return OrderState(orders: orders ?? this.orders, goal: goal ?? this.goal);
  }
}
