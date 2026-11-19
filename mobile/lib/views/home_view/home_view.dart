import 'package:flutter/material.dart';
import 'package:team_task_management/themes/theme.dart';
import 'package:team_task_management/views/home_view/home_stat_cardview.dart';
import 'package:team_task_management/views/home_view/home_task_cardview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkHomeSurface
          : AppColors.lightHomeSurface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: isDark
            ? AppColors.darkHomeSurface
            : AppColors.lightHomeHeaderBackground,
        title: _appBarTitleWidget(isDark),
        bottom: _appBarBottomWidget(isDark),
        toolbarHeight: 120,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _taskInfoWidget(isDark),
            _notificationInfoWidget(isDark),
            const SizedBox(height: 20),
            _seeAllTaskWidget(isDark),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) => _taskCardWidget(),
            ),
          ],
        ),
      ),
    );
  }

  HomeTaskCardview _taskCardWidget() => const HomeTaskCardview();

  Row _seeAllTaskWidget(bool isDark) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Son Görevlerim",
            style: TextStyle(
              fontSize: 20,
              color: isDark ? AppColors.inputText : AppColors.lightInputText,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              "Tümünü Gör",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.link,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _notificationInfoWidget(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.notificationCard
              : AppColors.lightHomeNotificationCard,
          border: Border.all(
            color: isDark
                ? AppColors.notificationCardBorder
                : Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          boxShadow: const [
            BoxShadow(
              color: Color(
                0x26000000,
              ), // Colors.black.withValues(alpha: 0.15) sabit hex hali
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.notificationIconBackground
                      : AppColors.lightHomeNotificationIconBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: isDark
                      ? AppColors.notificationCardIcon
                      : AppColors.lightHomeNotificationCardIcon,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Okunmamış Bildirim",
                        maxLines: 1,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.cardLabel
                              : AppColors.lightHomeNotificationLabel,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      "5",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.notificationNumber
                            : AppColors.lightHomeNotificationNumber,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.viewButtonBackground
                      : AppColors.lightHomeViewButtonBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: isDark
                        ? AppColors.viewButtonBorder
                        : Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Görüntüle",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.viewButtonText
                            : AppColors.lightHomeViewButtonText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize _appBarBottomWidget(bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: isDark
            ? AppColors.headerBorder
            : AppColors.lightHomeBottomNavBorder,
        height: 2.0,
      ),
    );
  }

  Widget _appBarTitleWidget(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoş geldiniz 👋",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.welcomeText
                        : AppColors.lightHomeWelcomeText,
                  ),
                ),
                Text(
                  "Merhaba, Eray",
                  style: TextStyle(
                    color: isDark
                        ? AppColors.homeTitle
                        : AppColors.lightHomeTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "22 Ağustos 2026, Cuma",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.dateText
                        : AppColors.lightHomeDateText,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.notificationButton
                      : AppColors.lightHomeNotificationButton,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  border: Border.all(
                    color: isDark
                        ? AppColors.notificationButtonBorder
                        : Colors.transparent,
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    size: 24,
                    color: isDark
                        ? AppColors.notificationIcon
                        : AppColors.lightHomeNotificationIcon,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.notificationBadge
                        : AppColors.lightHomeNotificationBadge,
                    border: Border.all(
                      color: isDark
                          ? AppColors.notificationBadgeBorder
                          : AppColors.lightHomeNotificationBadgeBorder,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "5",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.notificationBadgeText
                          : AppColors.lightHomeNotificationBadgeText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskInfoWidget(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: HomeStatCard(
              icon: Icons.check_box_outlined,
              iconColor: isDark
                  ? AppColors.openTaskIcon
                  : AppColors.lightHomeOpenTaskIcon,
              count: "14",
              countColor: isDark
                  ? AppColors.openTaskNumber
                  : AppColors.lightHomeOpenTaskNumber,
              title: "Açık Görev",
              borderColor: isDark
                  ? AppColors.openTaskBorder
                  : Colors.transparent,
              cardBgColor: isDark
                  ? AppColors.openTaskCardEnd
                  : AppColors.lightHomeOpenTaskCard,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: HomeStatCard(
              icon: Icons.access_time_rounded,
              iconColor: isDark
                  ? AppColors.overdueTaskIcon
                  : AppColors.lightHomeOverdueTaskIcon,
              count: "3",
              countColor: isDark
                  ? AppColors.overdueTaskNumber
                  : AppColors.lightHomeOverdueTaskNumber,
              title: "Geciken",
              borderColor: isDark
                  ? AppColors.overdueTaskBorder
                  : Colors.transparent,
              cardBgColor: isDark
                  ? AppColors.overdueTaskCard
                  : AppColors.lightHomeOverdueTaskCard,
            ),
          ),
        ],
      ),
    );
  }
}
