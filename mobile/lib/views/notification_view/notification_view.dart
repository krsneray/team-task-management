import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_task_management/models/notification_response.dart';
import 'package:team_task_management/providers/notification_provider.dart';
import 'package:team_task_management/themes/theme.dart';
import 'package:team_task_management/views/notification_view/notification_cardview.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: _notificationAppBarWidget(isDark),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          List<NotificationResponse> notifications =
              notificationProvider.notifications;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationCardview(
                title: notifications[index].title,
                isRead: notifications[index].isRead,
                subTitle: notifications[index].message,
                type: notifications[index].type,
              );
            },
          );
        },
      ),
    );
  }

  AppBar _notificationAppBarWidget(bool isDark) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDark
          ? AppColors.headerBackground
          : AppColors.headerBorder,
      title: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Bildirimler",
              style: TextStyle(
                color: isDark ? AppColors.inputText : AppColors.lightInputText,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  "Okundu işaretle",
                  style: TextStyle(color: AppColors.link, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: isDark
              ? AppColors.headerBorder
              : AppColors.lightHomeBottomNavBorder,
          height: 2.0,
        ),
      ),
    );
  }
}
