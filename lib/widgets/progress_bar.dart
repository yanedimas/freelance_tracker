import 'package:flutter/material.dart';
import 'package:freelance_tasks/theme/app_theme.dart';

class ProgressBar extends StatelessWidget {
  final double earned;
  final double goal;
  final VoidCallback onEditGoal;

  const ProgressBar({
    super.key,
    required this.earned,
    required this.goal,
    required this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (earned / goal).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).toInt();

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '💰 Заработано',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
              GestureDetector(
                onTap: onEditGoal,
                child: Icon(
                  Icons.edit,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: AppTheme.background,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      height: 12,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AnimatedValue(
                value: earned,
                suffix: ' ₽',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _AnimatedValue(
                value: percent.toDouble(),
                suffix: '%',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'из ${goal.toStringAsFixed(0)} ₽',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AnimatedValue extends StatefulWidget {
  final double value;
  final String suffix;
  final TextStyle style;

  const _AnimatedValue({
    required this.value,
    required this.suffix,
    required this.style,
  });

  @override
  State<_AnimatedValue> createState() => _AnimatedValueState();
}

class _AnimatedValueState extends State<_AnimatedValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = AlwaysStoppedAnimation(_currentValue);
  }

  @override
  void didUpdateWidget(_AnimatedValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _currentValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0).then((_) {
        _currentValue = widget.value;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          '${_animation.value.toStringAsFixed(0)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}