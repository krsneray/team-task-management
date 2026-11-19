import 'package:flutter/material.dart';
import 'package:team_task_management/themes/theme.dart';

class NotificationCardview extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isRead;
  final int type;

  const NotificationCardview({
    super.key,
    required this.title,
    required this.subTitle,
    required this.isRead,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(color: AppColors.headerBorder),
              start: BorderSide(color: AppColors.link, width: 4),
            ),
            color: isDark
                ? AppColors.pageBackground
                : AppColors.lightPageBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: isDark
                          ? AppColors.statusInProgressBackground
                          : AppColors.lightHomeStatusInProgressBackground,
                    ),
                    child: Icon(
                      Icons.folder_outlined,
                      color: isDark
                          ? AppColors.statusInProgress
                          : AppColors.lightHomeStatusInProgress,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.inputText
                                : AppColors.lightInputText,
                          ),
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.footerText
                                : AppColors.lightFooterText,
                          ),
                        ),
                      ],
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
