import 'package:hive_flutter/hive_flutter.dart';

part 'order.g.dart';

@HiveType(typeId: 0)
class Order extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final bool isCompleted;
  @HiveField(5)
  final String client;

  Order({
    required this.id,
    required this.title,
    required this.client, // добавь
    required this.amount,
    required this.date,
    this.isCompleted = false,
  });

  Order copyWith({
    String? id,
    String? title,
    String? client,
    double? amount,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Order(
      id: id ?? this.id,
      title: title ?? this.title,
      client: client ?? this.client,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
