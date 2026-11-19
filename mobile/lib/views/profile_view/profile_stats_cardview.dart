import 'package:flutter/material.dart';
import 'package:team_task_management/themes/theme.dart';

class ProfileStatsCardview extends StatelessWidget {
  final String done;
  final String opened;
  final String project;
  const ProfileStatsCardview({
    super.key,
    required this.done,
    required this.opened,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  opened,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.inputText
                        : AppColors.lightInputText,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Açık Görev", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        Container(
          width: 2,
          height: 100,
          color: isDark
              ? AppColors.headerBorder
              : AppColors.lightHomeBottomNavBorder,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  done,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.inputText
                        : AppColors.lightInputText,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Tamamlanan", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        Container(
          width: 2,
          height: 100,
          color: isDark
              ? AppColors.headerBorder
              : AppColors.lightHomeBottomNavBorder,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  project,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.inputText
                        : AppColors.lightInputText,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Proje", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
