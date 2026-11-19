import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_task_management/models/task_response.dart';
import 'package:team_task_management/providers/task_provider.dart';
import 'package:team_task_management/themes/theme.dart';
import 'package:team_task_management/utils/task_enums.dart';
import 'package:team_task_management/views/task_view/task_cardview.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      "Tümü",
      "Yeni",
      "Devam Ediyor",
      "Beklemede",
      "Tamamlandı",
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _taskAppBarWidget(isDark),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final List<TaskResponse> tasks = taskProvider.tasks;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(buttons.length, (index) {
                      final isSelected = selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppColors.lightLink
                                : isDark
                                ? AppColors.taskCardBackground
                                : AppColors.lightPageBackground,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade700),
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Text(
                            buttons[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.inputText
                                  : AppColors.bottomNavInactive,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Görev veya proje ara...",
                      prefixIcon: const Icon(Icons.search),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${tasks.length} GÖREV",
                    maxLines: 1,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.cardLabel
                          : AppColors.lightHomeNotificationLabel,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (taskProvider.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (taskProvider.errorMessage != null)
                  Expanded(
                    child: Center(
                      child: Text(
                        taskProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                else if (tasks.isEmpty)
                  const Expanded(
                    child: Center(child: Text("Henüz görev bulunmuyor.")),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) => TaskCardview(
                        date: tasks[index].dueDate.toString().substring(0, 10),
                        department: "Pazarlama",
                        priority: getTaskPriorityInfo(
                          tasks[index].priority,
                        ).label,
                        situation: getTaskStatusInfo(tasks[index].status).label,
                        title: tasks[index].title,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _taskAppBarWidget(bool isDark) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDark
          ? AppColors.headerBackground
          : AppColors.headerBorder,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "Görevlerim",
        style: TextStyle(
          color: isDark ? AppColors.inputText : AppColors.lightInputText,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.notificationButton : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? AppColors.notificationButtonBorder
                  : Colors.transparent,
            ),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sort_outlined,
              size: 24,
              color: isDark ? AppColors.notificationIcon : Colors.grey,
            ),
          ),
        ),
      ],
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
