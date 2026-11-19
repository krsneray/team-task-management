import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_task_management/views/home_view/home_view.dart';
import 'package:team_task_management/views/login_view/login_view.dart';
import 'package:team_task_management/views/notification_view/notification_view.dart';
import 'package:team_task_management/views/profile_view/profile_view.dart';
import 'package:team_task_management/views/splash_view/splash_view.dart';
import 'package:team_task_management/views/task_view/task_detail_view.dart';
import 'package:team_task_management/views/task_view/task_view.dart';
import 'package:team_task_management/views/widgets/app_view.dart';

final routerKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  navigatorKey: routerKey,
  routes: [
    GoRoute(path: "/splash", builder: (context, state) => const SplashView()),
    GoRoute(path: "/login", builder: (context, state) => const LoginView()),
    GoRoute(
      path: "/task_detail",
      builder: (context, state) => const TaskDetailView(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppView(statefulNavigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/tasks",
              builder: (context, state) => const TaskView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/notifications",
              builder: (context, state) => const NotificationView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
