import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_task_management/themes/theme.dart';

class AppView extends StatelessWidget {
  final StatefulNavigationShell statefulNavigationShell;
  const AppView({super.key, required this.statefulNavigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: statefulNavigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: isDark
              ? AppColors.bottomNavBackground
              : AppColors.lightHomeBottomNavBackground,
        ),
        child: _navigationBarView(context),
      ),
    );
  }

  NavigationBar _navigationBarView(BuildContext context) {
    final selectedIndex = statefulNavigationShell.currentIndex;
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: statefulNavigationShell.goBranch,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: AppColors.bottomNavActive);
        }
        return const TextStyle(color: AppColors.bottomNavInactive);
      }),
      destinations: [
        _barItem(
          context,
          index: 0,
          currentIndex: selectedIndex,
          label: "Ana Sayfa",
          icon: Icons.home,
        ),
        _barItem(
          context,
          index: 1,
          currentIndex: selectedIndex,
          label: "Görevlerim",
          icon: Icons.check_box_outlined,
        ),
        _barItem(
          context,
          index: 2,
          currentIndex: selectedIndex,
          label: "Bildirimler",
          icon: Icons.notifications_none_rounded,
        ),
        _barItem(
          context,
          index: 3,
          currentIndex: selectedIndex,
          label: "Profil",
          icon: Icons.account_circle,
        ),
      ],
    );
  }

  Widget _barItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: currentIndex == index
            ? AppColors.bottomNavActive
            : AppColors.bottomNavInactive,
        size: 28,
      ),
      label: label,
    );
  }
}
