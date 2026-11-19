import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ============================================================
  // DARK LOGIN / GENERAL
  // ============================================================

  static const Color pageBackground = Color(0xFF0C1120);
  static const Color phoneFrame = Color(0xFF1C1C24);
  static const Color inputBackground = Color(0xFF17171F);
  static const Color phoneSurface = Color(0xFF0F0F14);

  // ============================================================
  // DARK LOGIN BUTTONS
  // ============================================================

  static const Color primaryButton = Color(0xFF3B82F6);
  static const Color microsoftButton = Color(0xFF17171F);

  static const Color buttonShadow = Color.fromRGBO(59, 130, 246, 0.30);

  static const Color microsoftBorder = Color.fromRGBO(255, 255, 255, 0.09);

  // ============================================================
  // DARK LOGIN TEXT
  // ============================================================

  static const Color title = Color(0xFFF0F4FF);
  static const Color subtitle = Color(0xFF6B7A99);
  static const Color inputLabel = Color(0xFF6B7A99);
  static const Color inputText = Color(0xFFF0F4FF);
  static const Color inputPlaceholder = Color(0xFF3D4660);
  static const Color rememberMe = Color(0xFF8893AA);
  static const Color microsoftText = Color(0xFFC8D0E0);
  static const Color link = Color(0xFF3B82F6);
  static const Color footerText = Color(0xFF6B7A99);

  // ============================================================
  // DARK LOGIN ICONS
  // ============================================================

  static const Color icon = Color(0xFF6B7A99);

  // ============================================================
  // DARK LOGIN INPUT
  // ============================================================

  static const Color inputBorder = Color.fromRGBO(255, 255, 255, 0.07);

  static const Color focusBorder = Color(0xFF3B82F6);

  static const Color focusGlow = Color.fromRGBO(59, 130, 246, 0.12);

  // ============================================================
  // DARK CHECKBOX
  // ============================================================

  static const Color checkboxSelected = Color(0xFF3B82F6);

  static const Color checkboxUnselectedBorder = Color.fromRGBO(
    255,
    255,
    255,
    0.15,
  );

  // ============================================================
  // DARK OTHER
  // ============================================================

  static const Color divider = Color.fromRGBO(255, 255, 255, 0.07);

  static const Color statusBar = Colors.white;

  // ============================================================
  // DARK HOME / DASHBOARD
  // ============================================================

  // Genel
  static const Color darkHomeBackground = Color(0xFF070D1A);
  static const Color darkHomeSurface = Color(0xFF0C1120);

  // Header
  static const Color headerBackground = Color(0xFF0C1120);

  static const Color headerBorder = Color.fromRGBO(255, 255, 255, 0.05);

  static const Color welcomeText = Color(0xFF4A5568);
  static const Color homeTitle = Color(0xFFF0F4FF);
  static const Color dateText = Color(0xFF4A5568);

  // Bildirim butonu
  static const Color notificationButton = Color(0xFF17202E);

  static const Color notificationButtonBorder = Color.fromRGBO(
    255,
    255,
    255,
    0.07,
  );

  static const Color notificationIcon = Color(0xFF8FA3BE);

  static const Color notificationBadge = Color(0xFFEF4444);
  static const Color notificationBadgeBorder = Color(0xFF0C1120);
  static const Color notificationBadgeText = Colors.white;

  // ============================================================
  // DARK SUMMARY CARDS
  // ============================================================

  static const Color openTaskCardStart = Color(0xFF1E3A6E);
  static const Color openTaskCardEnd = Color(0xFF1A2F54);

  static const Color openTaskBorder = Color.fromRGBO(59, 130, 246, 0.18);

  static const Color openTaskIconBackground = Color.fromRGBO(
    59,
    130,
    246,
    0.18,
  );

  static const Color openTaskIcon = Color(0xFF3B82F6);
  static const Color openTaskNumber = Color(0xFFF0F4FF);

  static const Color overdueTaskCard = Color(0xFF17202E);

  static const Color overdueTaskBorder = Color.fromRGBO(239, 68, 68, 0.15);

  static const Color overdueTaskIconBackground = Color.fromRGBO(
    239,
    68,
    68,
    0.12,
  );

  static const Color overdueTaskIcon = Color(0xFFEF4444);
  static const Color overdueTaskNumber = Color(0xFFEF4444);

  static const Color notificationCard = Color(0xFF17202E);

  static const Color notificationCardBorder = Color.fromRGBO(
    139,
    92,
    246,
    0.15,
  );

  static const Color notificationIconBackground = Color.fromRGBO(
    139,
    92,
    246,
    0.12,
  );

  static const Color notificationCardIcon = Color(0xFF8B5CF6);
  static const Color notificationNumber = Color(0xFFF0F4FF);

  static const Color cardLabel = Color(0xFF8FA3BE);

  static const Color viewButtonBackground = Color.fromRGBO(139, 92, 246, 0.14);

  static const Color viewButtonBorder = Color.fromRGBO(139, 92, 246, 0.20);

  static const Color viewButtonText = Color(0xFF8B5CF6);

  // ============================================================
  // DARK TASK LIST
  // ============================================================

  static const Color taskSectionTitle = Color(0xFFF0F4FF);
  static const Color seeAllText = Color(0xFF3B82F6);

  static const Color taskCardBackground = Color(0xFF17202E);

  static const Color taskCardBorder = Color.fromRGBO(255, 255, 255, 0.05);

  static const Color taskTitle = Color(0xFFDDE8F5);

  static const Color projectTagBackground = Color.fromRGBO(255, 255, 255, 0.06);

  static const Color projectTagText = Color(0xFF6B7A99);
  static const Color taskDateText = Color(0xFF6B7A99);
  static const Color separatorDot = Color(0xFF4A5568);

  // ============================================================
  // DARK STATUS BADGES
  // ============================================================

  static const Color statusNewBackground = Color.fromRGBO(148, 163, 184, 0.12);

  static const Color statusNew = Color(0xFF94A3B8);

  static const Color statusInProgressBackground = Color.fromRGBO(
    59,
    130,
    246,
    0.15,
  );

  static const Color statusInProgress = Color(0xFF3B82F6);

  static const Color statusPendingBackground = Color.fromRGBO(
    251,
    146,
    60,
    0.14,
  );

  static const Color statusPending = Color(0xFFFB923C);

  static const Color statusCompletedBackground = Color.fromRGBO(
    34,
    197,
    94,
    0.12,
  );

  static const Color statusCompleted = Color(0xFF22C55E);

  static const Color statusCancelledBackground = Color.fromRGBO(
    239,
    68,
    68,
    0.13,
  );

  static const Color statusCancelled = Color(0xFFEF4444);

  // ============================================================
  // DARK BOTTOM NAVIGATION
  // ============================================================

  static const Color bottomNavBackground = Color(0xFF0F1623);

  static const Color bottomNavBorder = Color.fromRGBO(255, 255, 255, 0.06);

  static const Color bottomNavActive = Color(0xFF3B82F6);
  static const Color bottomNavInactive = Color(0xFF4A5568);
  static const Color bottomNavIndicator = Color(0xFF3B82F6);
  static const Color bottomNavNotification = Color(0xFFEF4444);

  static const Color bottomNavNotificationBorder = Color(0xFF0F1623);

  // ============================================================
  // LIGHT LOGIN
  // ============================================================

  static const Color lightPageBackground = Color(0xFFE8EDF5);
  static const Color lightPhoneSurface = Color(0xFFF0F4F8);
  static const Color lightPhoneFrame = Color(0xFFD1D9E6);
  static const Color lightPhoneBorder = Color(0xFFC8D0E0);

  // Logo
  static const Color lightLogoBackground = Color(0xFF1E40AF);

  static const Color lightLogoShadow = Color.fromRGBO(30, 64, 175, 0.28);

  static const Color lightLogoText = Color(0xFF1E293B);
  static const Color lightLogoSubtitle = Color(0xFF94A3B8);

  // Titles
  static const Color lightTitle = Color(0xFF1E293B);
  static const Color lightSubtitle = Color(0xFF94A3B8);

  // Inputs
  static const Color lightInputBackground = Colors.white;
  static const Color lightInputBorder = Color(0xFFDDE4EF);
  static const Color lightFocusBorder = Color(0xFF1E40AF);

  static const Color lightFocusGlow = Color.fromRGBO(30, 64, 175, 0.10);

  static const Color lightInputText = Color(0xFF1E293B);
  static const Color lightPlaceholder = Color(0xFFB0BDD0);
  static const Color lightInputLabel = Color(0xFF64748B);
  static const Color lightIcon = Color(0xFF94A3B8);

  // Buttons
  static const Color lightPrimaryButton = Color(0xFF1E40AF);
  static const Color lightPrimaryButtonText = Colors.white;

  static const Color lightPrimaryButtonShadow = Color.fromRGBO(
    30,
    64,
    175,
    0.25,
  );

  static const Color lightMicrosoftButton = Colors.white;
  static const Color lightMicrosoftBorder = Color(0xFFDDE4EF);
  static const Color lightMicrosoftText = Color(0xFF334155);

  static const Color lightMicrosoftShadow = Color.fromRGBO(0, 0, 0, 0.06);

  // Checkbox
  static const Color lightCheckboxSelected = Color(0xFF1E40AF);
  static const Color lightCheckboxSelectedBorder = Color(0xFF1E40AF);

  static const Color lightCheckboxUnselectedBackground = Colors.white;

  static const Color lightCheckboxUnselectedBorder = Color(0xFFC8D4E8);

  static const Color lightRememberMe = Color(0xFF64748B);

  // Other
  static const Color lightLink = Color(0xFF1E40AF);
  static const Color lightFooterText = Color(0xFF94A3B8);
  static const Color lightDivider = Color(0xFFDDE4EF);
  static const Color lightOrText = Color(0xFF94A3B8);

  static const Color lightHomeIndicator = Color.fromRGBO(0, 0, 0, 0.15);

  static const Color lightStatusBar = Color(0xFF1E293B);

  // ============================================================
  // LIGHT HOME / DASHBOARD
  // ============================================================

  // Genel zemin
  static const Color lightHomeBackground = Color(0xFF070D1A);
  static const Color lightHomeSurface = Color(0xFFF0F4F8);
  static const Color lightHomePhoneFrame = Color(0xFF1C1C24);

  // Header
  static const Color lightHomeHeaderBackground = Color(0xFF1A2F54);

  static const Color lightHomeWelcomeText = Color.fromRGBO(255, 255, 255, 0.55);

  static const Color lightHomeTitle = Colors.white;

  static const Color lightHomeDateText = Color.fromRGBO(255, 255, 255, 0.45);

  static const Color lightHomeNotificationButton = Color.fromRGBO(
    255,
    255,
    255,
    0.10,
  );

  static const Color lightHomeNotificationIcon = Colors.white;

  static const Color lightHomeNotificationBadge = Color(0xFFEF4444);

  static const Color lightHomeNotificationBadgeText = Colors.white;

  static const Color lightHomeNotificationBadgeBorder = Color(0xFF1A2F54);

  // ============================================================
  // LIGHT HOME SUMMARY CARDS
  // ============================================================

  // Açık görevler
  static const Color lightHomeOpenTaskCard = Color(0xFF1A2F54);

  static const Color lightHomeOpenTaskIconBackground = Color.fromRGBO(
    59,
    130,
    246,
    0.20,
  );

  static const Color lightHomeOpenTaskIcon = Color(0xFF3B82F6);

  static const Color lightHomeOpenTaskNumber = Colors.white;

  static const Color lightHomeOpenTaskLabel = Color.fromRGBO(
    255,
    255,
    255,
    0.55,
  );

  // Geciken görevler
  static const Color lightHomeOverdueTaskCard = Colors.white;

  static const Color lightHomeOverdueTaskIconBackground = Color.fromRGBO(
    239,
    68,
    68,
    0.10,
  );

  static const Color lightHomeOverdueTaskIcon = Color(0xFFEF4444);

  static const Color lightHomeOverdueTaskNumber = Color(0xFFEF4444);

  static const Color lightHomeOverdueTaskLabel = Color(0xFF94A3B8);

  static const Color lightHomeOverdueTaskShadow = Color.fromRGBO(0, 0, 0, 0.07);

  // Bildirimler
  static const Color lightHomeNotificationCard = Colors.white;

  static const Color lightHomeNotificationIconBackground = Color.fromRGBO(
    139,
    92,
    246,
    0.10,
  );

  static const Color lightHomeNotificationCardIcon = Color(0xFF8B5CF6);

  static const Color lightHomeNotificationNumber = Color(0xFF1E293B);

  static const Color lightHomeNotificationLabel = Color(0xFF94A3B8);

  static const Color lightHomeViewButtonBackground = Color.fromRGBO(
    139,
    92,
    246,
    0.10,
  );

  static const Color lightHomeViewButtonText = Color(0xFF8B5CF6);

  // ============================================================
  // LIGHT HOME TASK LIST
  // ============================================================

  static const Color lightHomeTaskSectionTitle = Color(0xFF1E293B);

  static const Color lightHomeSeeAllText = Color(0xFF3B82F6);

  static const Color lightHomeTaskCardBackground = Colors.white;

  static const Color lightHomeTaskCardShadow = Color.fromRGBO(0, 0, 0, 0.06);

  static const Color lightHomeTaskTitle = Color(0xFF1E293B);

  static const Color lightHomeProjectTagBackground = Color(0xFFF1F5F9);

  static const Color lightHomeProjectTagText = Color(0xFF94A3B8);

  static const Color lightHomeTaskDateText = Color(0xFF94A3B8);

  static const Color lightHomeSeparatorDot = Color(0xFF94A3B8);

  // ============================================================
  // LIGHT HOME STATUS BADGES
  // ============================================================

  static const Color lightHomeStatusNewBackground = Color.fromRGBO(
    148,
    163,
    184,
    0.12,
  );

  static const Color lightHomeStatusNew = Color(0xFF94A3B8);

  static const Color lightHomeStatusInProgressBackground = Color.fromRGBO(
    59,
    130,
    246,
    0.12,
  );

  static const Color lightHomeStatusInProgress = Color(0xFF3B82F6);

  static const Color lightHomeStatusPendingBackground = Color.fromRGBO(
    251,
    146,
    60,
    0.12,
  );

  static const Color lightHomeStatusPending = Color(0xFFFB923C);

  static const Color lightHomeStatusCompletedBackground = Color.fromRGBO(
    34,
    197,
    94,
    0.12,
  );

  static const Color lightHomeStatusCompleted = Color(0xFF22C55E);

  static const Color lightHomeStatusCancelledBackground = Color.fromRGBO(
    239,
    68,
    68,
    0.12,
  );

  static const Color lightHomeStatusCancelled = Color(0xFFEF4444);

  // ============================================================
  // LIGHT HOME BOTTOM NAVIGATION
  // ============================================================

  static const Color lightHomeBottomNavBackground = Colors.white;

  static const Color lightHomeBottomNavBorder = Color.fromRGBO(0, 0, 0, 0.06);

  static const Color lightHomeBottomNavActive = Color(0xFF3B82F6);

  static const Color lightHomeBottomNavInactive = Color(0xFF6B7A99);

  static const Color lightHomeBottomNavIndicator = Color(0xFF3B82F6);

  static const Color lightHomeBottomNavNotification = Color(0xFFEF4444);

  static const Color lightHomeBottomNavNotificationBorder = Colors.white;
}

// ================================================================
// APP THEME
// ================================================================

class AppTheme {
  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    // Home'un varsayılan ana zemini
    scaffoldBackgroundColor: AppColors.darkHomeSurface,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryButton,
      surface: AppColors.darkHomeSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.title,
    ),

    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.title,
          fontWeight: FontWeight.w700,
        ),

        headlineMedium: TextStyle(
          color: AppColors.title,
          fontWeight: FontWeight.w700,
        ),

        titleLarge: TextStyle(
          color: AppColors.title,
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: TextStyle(
          color: AppColors.inputText,
          fontWeight: FontWeight.w400,
        ),

        bodyMedium: TextStyle(
          color: AppColors.subtitle,
          fontWeight: FontWeight.w400,
        ),

        bodySmall: TextStyle(
          color: AppColors.footerText,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,

      labelStyle: const TextStyle(
        color: AppColors.inputLabel,
        fontWeight: FontWeight.w400,
      ),

      hintStyle: const TextStyle(
        color: AppColors.inputPlaceholder,
        fontWeight: FontWeight.w400,
      ),

      prefixIconColor: AppColors.icon,
      suffixIconColor: AppColors.icon,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.focusBorder, width: 1.5),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.checkboxSelected;
        }

        return Colors.transparent;
      }),

      side: const BorderSide(color: AppColors.checkboxUnselectedBorder),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: Colors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        textStyle: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),

    iconTheme: const IconThemeData(color: AppColors.icon),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.headerBackground,
      foregroundColor: AppColors.title,
      elevation: 0,

      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.headerBackground,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.darkHomeSurface,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
  );

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    // Home'un varsayılan ana zemini
    scaffoldBackgroundColor: AppColors.lightHomeSurface,

    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimaryButton,
      surface: AppColors.lightHomeSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.lightTitle,
    ),

    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.lightTitle,
          fontWeight: FontWeight.w700,
        ),

        headlineMedium: TextStyle(
          color: AppColors.lightTitle,
          fontWeight: FontWeight.w700,
        ),

        titleLarge: TextStyle(
          color: AppColors.lightTitle,
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: TextStyle(
          color: AppColors.lightInputText,
          fontWeight: FontWeight.w400,
        ),

        bodyMedium: TextStyle(
          color: AppColors.lightSubtitle,
          fontWeight: FontWeight.w400,
        ),

        bodySmall: TextStyle(
          color: AppColors.lightFooterText,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInputBackground,

      labelStyle: const TextStyle(
        color: AppColors.lightInputLabel,
        fontWeight: FontWeight.w400,
      ),

      hintStyle: const TextStyle(
        color: AppColors.lightPlaceholder,
        fontWeight: FontWeight.w400,
      ),

      prefixIconColor: AppColors.lightIcon,
      suffixIconColor: AppColors.lightIcon,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.lightInputBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.lightInputBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.lightFocusBorder,
          width: 1.5,
        ),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightCheckboxSelected;
        }

        return AppColors.lightCheckboxUnselectedBackground;
      }),

      side: const BorderSide(color: AppColors.lightCheckboxUnselectedBorder),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimaryButton,
        foregroundColor: AppColors.lightPrimaryButtonText,
        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        textStyle: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),

    iconTheme: const IconThemeData(color: AppColors.lightIcon),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightHomeHeaderBackground,
      foregroundColor: Colors.white,
      elevation: 0,

      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.lightHomeHeaderBackground,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,

        systemNavigationBarColor: AppColors.lightHomeSurface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
  );
}
