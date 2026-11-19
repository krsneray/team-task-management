import 'package:flutter/material.dart';
import 'package:team_task_management/themes/theme.dart';

class ProfileMenuCardview extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData temp_icon;

  const ProfileMenuCardview({
    super.key,
    required this.title,
    required this.icon,
    required this.temp_icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.pageBackground : Colors.grey.shade200,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                border: Border.all(
                  color: isDark
                      ? AppColors.notificationButtonBorder
                      : Colors.transparent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? AppColors.inputText
                      : AppColors.lightInputText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Icon(temp_icon),
          ),
        ],
      ),
    );
  }
}
