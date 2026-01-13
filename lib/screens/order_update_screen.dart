import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_state.dart';
import 'package:go_router/go_router.dart';

import '../bloc/order/order_event.dart';
import '../theme/app_theme.dart';

class OrderUpdateScreen extends StatefulWidget {
  final String orderId;

  const OrderUpdateScreen({super.key, required this.orderId});

  @override
  State<OrderUpdateScreen> createState() => _OrderUpdateScreenState();
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  final _titleController = TextEditingController();
  final _clientController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _clientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      final order =
          state.orders.where((o) => o.id == widget.orderId).firstOrNull;
      if (order == null) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (!_isInitialized) {
        _titleController.text = order.title;
        _clientController.text = order.client;
        _amountController.text = order.amount.toStringAsFixed(0);
        _isInitialized = true;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Редактировать'),
          leading: IconButton(
              onPressed: () => context.go('/'), icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Изменить информацию о заказе',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Название проекта',
                      icon: Icons.work_outline,
                    ),
                    SizedBox(height: 16),

                    // Заказчик
                    _buildTextField(
                      controller: _clientController,
                      label: 'Имя заказчика',
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: 16),

                    // Сумма
                    _buildTextField(
                      controller: _amountController,
                      label: 'Сумма',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      suffix: '₽',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _saveOrder(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Сохранить',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      TextInputType keyboardType = TextInputType.text,
      String? suffix}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.textSecondary),
        prefixIcon: Icon(
          icon,
          color: AppTheme.textSecondary,
        ),
        suffixText: suffix,
        suffixStyle: TextStyle(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.accent, width: 2),
        ),
      ),
    );
  }

  void _saveOrder() {
    final title =
        _titleController.text.isNotEmpty ? _titleController.text : null;
    final client =
        _clientController.text.isNotEmpty ? _clientController.text : null;
    final amount = double.tryParse(_amountController.text);

    context.read<OrderBloc>().add(UpdateOrder(
          id: widget.orderId,
          title: title,
          client: client,
          amount: amount,
        ));
    context.go('/order/${widget.orderId}');
  }
}
