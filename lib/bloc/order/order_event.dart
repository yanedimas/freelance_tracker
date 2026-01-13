abstract class OrderEvent {}

class LoadOrders extends OrderEvent {}

class AddOrder extends OrderEvent {
  final String title;
  final String client;
  final double amount;

  AddOrder({required this.title, required this.client, required this.amount});
}

class UpdateOrder extends OrderEvent {
  final String id;
  final String? title;
  final String? client;
  final double? amount;

  UpdateOrder({required this.id, this.title, this.client, this.amount});
}

class DeleteOrder extends OrderEvent {
  final String id;

  DeleteOrder({required this.id});
}

class StatusChange extends OrderEvent {
  final String id;

  StatusChange({required this.id});
}

class UpdateGoal extends OrderEvent {
  final double goal;

  UpdateGoal({required this.goal});
}
