import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_event.dart';
import 'package:freelance_tasks/bloc/order/order_state.dart';
import 'package:freelance_tasks/models/order.dart';
import 'package:freelance_tasks/services/storage_service.dart';
import 'package:hive_flutter/adapters.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final Box<Order> _box;

  OrderBloc(this._box) : super(OrderState.initial()) {
    on<LoadOrders>((event, emit) {
      final orders = _box.values.toList();
      final goal = StorageService.goal;
      emit(state.copyWith(orders: orders, goal: goal));
    });
    on<AddOrder>((event, emit) {
      final Order newOrder = Order(
          id: DateTime.now().toString(),
          title: event.title,
          client: event.client,
          amount: event.amount,
          date: DateTime.now());
      _box.add(newOrder);
      final newOrders = _box.values.toList();
      emit(state.copyWith(orders: newOrders));
    });
    on<UpdateOrder>((event, emit) {
      final updateOrders = state.orders.map((order) {
        if (order.id == event.id) {
          return order.copyWith(
              title: event.title ?? order.title,
              client: event.client ?? order.client,
              amount: event.amount ?? order.amount);
        }
        return order;
      }).toList();
      final index = state.orders.indexWhere((o) => o.id == event.id);
      if (index != -1) {
        _box.putAt(index, updateOrders[index]);
      }
      emit(state.copyWith(orders: updateOrders));
    });
    on<DeleteOrder>((event, emit) async {
      final index = state.orders.indexWhere((o) => o.id == event.id);
      if (index != -1) {
        await _box.deleteAt(index);
      }
      final updateOrders = _box.values.toList();
      emit(state.copyWith(orders: updateOrders));
    });
    on<StatusChange>((event, emit) {
      final index = state.orders.indexWhere((o) => o.id == event.id);
      if (index == -1) return;
      final order = _box.getAt(index);
      if (order == null) return;
      final updatedOrder = order.copyWith(
        isCompleted: !order.isCompleted,
      );
      _box.putAt(index, updatedOrder);
      emit(state.copyWith(orders: _box.values.toList()));
    });
    on<UpdateGoal>((event, emit) async {
      await StorageService.setGoal(event.goal);
      final newGoal = StorageService.goal;
      emit(state.copyWith(goal: newGoal));
    });
  }
}
