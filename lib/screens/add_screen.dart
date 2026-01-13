import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_bloc.dart';
import 'package:freelance_tasks/bloc/order/order_event.dart';
import 'package:freelance_tasks/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _clientController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый заказ'),
        leading: IconButton(
            onPressed: () => context.go('/'), icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Информация о заказе',
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
    if (_titleController.text.isNotEmpty &&
        _clientController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сумма должна быть больше 0')),
        );
        return;
      }
      context.read<OrderBloc>().add(AddOrder(
          title: _titleController.text,
          client: _clientController.text,
          amount: amount));
      context.go('/');
    }
  }
}
