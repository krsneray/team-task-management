import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_task_management/providers/auth_provider.dart';
import 'package:team_task_management/providers/theme_provider.dart';
import 'package:team_task_management/themes/theme.dart';
import 'package:team_task_management/views/profile_view/profile_menu_cardview.dart';
import 'package:team_task_management/views/profile_view/profile_stats_cardview.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _profileAppBarWidget(isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final authResponse = authProvider.authResponse;

                if (authResponse == null) {
                  return const SizedBox.shrink();
                }
                final List<String> nameSurname = authResponse.fullName.split(
                  " ",
                );
                final String title =
                    "${nameSurname[0][0].toUpperCase()}${nameSurname[1][0].toUpperCase()}";
                final String fullName =
                    "${nameSurname[0][0].toUpperCase()}${nameSurname[0].substring(1)} "
                    "${nameSurname[1][0].toUpperCase()}${nameSurname[1].substring(1)}";
                return Container(
                  color: isDark ? AppColors.pageBackground : Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle, size: 100, color: Colors.blue),
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          fullName,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.inputText
                                : AppColors.lightInputText,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(authProvider.authResponse!.email),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.statusInProgressBackground
                                  : AppColors
                                        .lightHomeStatusInProgressBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 4,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  authResponse.roles[0],
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.statusInProgress
                                        : AppColors.lightHomeStatusInProgress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        PreferredSize(
                          preferredSize: const Size.fromHeight(1),
                          child: Container(
                            height: 2,
                            color: isDark
                                ? AppColors.headerBorder
                                : AppColors.lightHomeBottomNavBorder,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.pageBackground
                      : AppColors.lightPageBackground,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.notificationCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ProfileStatsCardview(
                        done: "38",
                        project: "3",
                        opened: "14",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.notificationCard : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const ProfileMenuCardview(
                      temp_icon: Icons.chevron_right_rounded,
                      icon: Icons.info_outline,
                      title: "Hesap Bilgileri",
                    ),
                    Divider(
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                      indent: 10,
                    ),
                    const ProfileMenuCardview(
                      temp_icon: Icons.chevron_right_rounded,
                      icon: Icons.notifications_none_rounded,
                      title: "Bildirim Ayarları",
                    ),
                    Divider(
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                      indent: 10,
                    ),
                    const ProfileMenuCardview(
                      temp_icon: Icons.chevron_right_rounded,
                      icon: Icons.lock_outline,
                      title: "Şifre Değiştir",
                    ),
                    Divider(
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                      indent: 10,
                    ),
                    const ProfileMenuCardview(
                      temp_icon: Icons.chevron_right_rounded,
                      icon: Icons.help_outline_sharp,
                      title: "Yardım ve Destek",
                    ),
                    Divider(
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                      indent: 10,
                    ),
                    _darkThemeWidget(isDark),
                  ],
                ),
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        context.go("/login");
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.red, size: 24),
                    label: const Text(
                      "Çıkış Yap",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: isDark
                          ? const Color(0xFF211417)
                          : const Color(0xFFFFF5F5),
                      elevation: 0,
                      padding: const EdgeInsets.all(16.0),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF6A212A)
                            : const Color(0xFFFFCCCC),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _darkThemeWidget(bool isDark) {
    return Row(
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
              child: Icon(Icons.brightness_3),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Karanlık Tema",
              style: TextStyle(
                color: isDark ? AppColors.inputText : AppColors.lightInputText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Switch(
                value: themeProvider.isDark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  AppBar _profileAppBarWidget(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.headerBackground : Colors.white,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        "Profil",
        style: TextStyle(
          color: isDark ? AppColors.inputText : AppColors.lightInputText,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 2,
          color: isDark
              ? AppColors.headerBorder
              : AppColors.lightHomeBottomNavBorder,
        ),
      ),
    );
  }
}
