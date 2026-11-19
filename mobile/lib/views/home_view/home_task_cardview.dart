import 'package:flutter/material.dart';
import 'package:team_task_management/themes/theme.dart';

class HomeTaskCardview extends StatelessWidget {
  const HomeTaskCardview({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.taskCardBackground
              : AppColors.lightHomeTaskCardBackground,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: AppColors.taskCardBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000), // Colors.black.withValues(alpha: 0.15)
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.circle, size: 12, color: Colors.blue),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q3 Pazarlama raporu hazırla ve yönetim kuruluna sunum yapmak için slaytları düzenle",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.inputText
                              : AppColors.lightInputText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                              color: isDark
                                  ? const Color(
                                      0x0FFFFFFF,
                                    ) // const Color.fromRGBO(255, 255, 255, 0.06)
                                  : AppColors.taskSectionTitle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 7,
                              ),
                              child: Text(
                                "Pazarlama",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? const Color(0xFF6B7A99)
                                      : AppColors.lightHomeTaskSectionTitle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.circle, size: 4),
                          const SizedBox(width: 10),
                          Text(
                            "23 Ağu",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.taskDateText
                                  : AppColors.lightHomeTaskDateText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.statusInProgressBackground
                      : AppColors.lightHomeStatusInProgressBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: Text(
                    "Devam Ediyor",
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
      ),
    );
  }
}
