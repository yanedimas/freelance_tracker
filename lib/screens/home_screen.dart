import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_event.dart';
import 'package:freelance_tasks/theme/app_theme.dart';
import 'package:freelance_tasks/widgets/order_card.dart';
import 'package:freelance_tasks/widgets/progress_bar.dart';
import 'package:go_router/go_router.dart';
import '../bloc/order/order_bloc.dart';
import '../bloc/order/order_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freelance tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        final earned = state.orders
            .where((o) => o.isCompleted)
            .fold(0.0, (sum, o) => sum + o.amount);
        return Column(
          children: [
            ProgressBar(
                earned: earned,
                goal: state.goal,
                onEditGoal: () => _showGoalDialog(context, state.goal)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '📋 Заказы',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
            ),
            if (state.orders.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Список заказов пуст',
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(
                      order: order,
                      onTap: () => context.go('/order/${order.id}'));
                },
                itemCount: state.orders.length,
              )),
          ],
        );
      }),
    );
  }

  void _showGoalDialog(BuildContext context, double currentGoal) {
    final controller =
        TextEditingController(text: currentGoal.toStringAsFixed(0));
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Цель заработка'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Сумма',
                suffixText: '₽',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final goal = double.tryParse(controller.text) ?? 0;
                    context.read<OrderBloc>().add(UpdateGoal(goal: goal));
                    Navigator.pop(dialogContext);
                  },
                  child: Text('Сохранить')),
            ],
          );
        });
  }
}
