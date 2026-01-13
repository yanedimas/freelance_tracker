import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_event.dart';
import 'package:freelance_tasks/bloc/order/order_state.dart';
import 'package:freelance_tasks/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

import '../bloc/order/order_bloc.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      final order = state.orders.where((o) => o.id == orderId).firstOrNull;
      if (order == null) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Детали заказа'),
          leading: IconButton(
              onPressed: () => context.go('/'), icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: order.isCompleted
                      ? AppTheme.completed.withValues(alpha: 0.2)
                      : AppTheme.inProgress.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      order.isCompleted ? '🟢' : '🟠',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      order.isCompleted ? 'Выполнено' : 'В процессе',
                      style: TextStyle(
                          color: order.isCompleted
                              ? AppTheme.completed
                              : AppTheme.inProgress,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '📋 Информация',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Название", order.title),
                    Divider(
                      color: AppTheme.background,
                      height: 24,
                    ),
                    _buildInfoRow('Заказчик', order.client),
                    Divider(
                      color: AppTheme.background,
                      height: 24,
                    ),
                    _buildInfoRow(
                        'Сумма', '${order.amount.toStringAsFixed(0)} ₽'),
                    Divider(
                      color: AppTheme.background,
                      height: 24,
                    ),
                    _buildInfoRow('Дата',
                        '${order.date.day}.${order.date.month}.${order.date.year}'),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              _buildActionButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(StatusChange(id: orderId));
                  },
                  icon: order.isCompleted ? Icons.undo : Icons.check,
                  label: order.isCompleted
                      ? 'Вернуть в работу'
                      : 'Отметить выполненным',
                  color: AppTheme.accent),
              SizedBox(
                height: 12,
              ),
              _buildActionButton(
                  onPressed: () => context.go('/update/${order.id}'),
                  icon: Icons.edit,
                  label: 'Редактировать',
                  color: AppTheme.textSecondary),
              SizedBox(
                height: 12,
              ),
              _buildActionButton(
                  onPressed: () {
                    _showDeleteDialog(context, orderId);
                  },
                  icon: Icons.delete,
                  label: 'Удалить',
                  color: Colors.red),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String orderId) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Удалить заказ'),
            content: Text('Это действие отменить нельзя'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Отмена')),
              TextButton(
                onPressed: () {
                  context.read<OrderBloc>().add(DeleteOrder(id: orderId));
                  Navigator.pop(dialogContext);
                  context.go('/');
                },
                child: Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
