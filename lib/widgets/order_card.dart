import 'package:flutter/material.dart';
import 'package:freelance_tasks/models/order.dart';
import 'package:freelance_tasks/theme/app_theme.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onStatusChange;

  const OrderCard(
      {super.key,
      required this.order,
      required this.onTap,
      required this.onDelete,
      required this.onStatusChange});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.order.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: InkWell(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: Duration(milliseconds: 150),
          scale: _isPressed ? 0.95 : 1.0,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  widget.order.isCompleted ? '🟢' : '🟠',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.order.client,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${widget.order.amount.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: widget.onStatusChange,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      widget.order.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      key: ValueKey(widget.order.isCompleted),
                      color: widget.order.isCompleted
                          ? AppTheme.completed
                          : AppTheme.inProgress,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
