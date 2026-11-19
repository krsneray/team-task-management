import 'package:flutter/material.dart';
import 'package:team_task_management/providers/auth_provider.dart';
import 'package:team_task_management/providers/notification_provider.dart';
import 'package:team_task_management/providers/project_provider.dart';
import 'package:team_task_management/providers/task_comment_provider.dart';
import 'package:team_task_management/providers/task_provider.dart';
import 'package:team_task_management/providers/theme_provider.dart';
import 'themes/theme.dart';
import "routers/router.dart";
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TaskCommentProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.15),
          ),
          child: child!,
        );
      },
    );
  }
}
