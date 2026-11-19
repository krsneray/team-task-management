import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_task_management/themes/theme.dart';

class TaskCardview extends StatelessWidget {
  final String title;
  final String priority;
  final String department;
  final String date;
  final String situation;

  const TaskCardview({
    super.key,
    required this.title,
    required this.priority,
    required this.department,
    required this.date,
    required this.situation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        context.go("/task_detail");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.taskCardBackground
                : AppColors.lightHomeTaskCardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.taskCardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.inputText
                              : AppColors.lightInputText,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.statusInProgressBackground
                            : AppColors.lightHomeStatusInProgressBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        child: Text(
                          situation,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.statusInProgress
                                : AppColors.lightHomeStatusInProgress,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24,
                thickness: 1,
                color: isDark ? AppColors.divider : AppColors.lightDivider,
                indent: 8,
                endIndent: 8,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isDark
                            ? const Color.fromRGBO(255, 255, 255, 0.06)
                            : AppColors.taskSectionTitle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 7,
                        ),
                        child: Text(
                          department,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF6B7A99)
                                : AppColors.lightHomeTaskSectionTitle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Icon(Icons.circle, size: 12, color: Colors.green),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 0, 8),
                      child: Text(
                        priority,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 0, 8, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.date_range, size: 16, color: Colors.red),
                        Text(date, style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
