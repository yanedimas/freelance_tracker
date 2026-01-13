import 'package:flutter/material.dart';
import 'package:freelance_tasks/theme/app_theme.dart';

class ProgressBar extends StatelessWidget {
  final double earned;
  final double goal;
  final VoidCallback onEditGoal;

  const ProgressBar(
      {super.key,
      required this.earned,
      required this.goal,
      required this.onEditGoal});

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
              IconButton(
                  onPressed: onEditGoal,
                  icon: Icon(
                    Icons.edit,
                    color: AppTheme.textSecondary,
                    size: 20,
                  )),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppTheme.background,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${earned.toStringAsFixed(0)} ₽',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'из ${goal.toStringAsFixed(0)} ₽',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          )
        ],
      ),
    );
  }
}
