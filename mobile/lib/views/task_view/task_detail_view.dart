import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_task_management/themes/theme.dart';

class TaskDetailView extends StatefulWidget {
  const TaskDetailView({super.key});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: _taskDetailAppBarWidget(isDark),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Q3 Pazarlama Raporu hazırla",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.inputText
                            : AppColors.lightInputText,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.statusInProgressBackground
                          : AppColors.lightHomeStatusInProgressBackground,
                      borderRadius: BorderRadius.circular(8),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.check_box_outline_blank, size: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Pazarlama",
                      style: TextStyle(color: AppColors.link),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.taskCardBackground
                      : AppColors.lightHomeTaskCardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.taskCardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sorumlu"),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 24,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "EY",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Eray Kırşan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.inputText
                                        : AppColors.lightInputText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text("Başlangıç"),
                            SizedBox(height: 8),
                            Text(
                              "23 Ağu 2026",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.inputText
                                    : AppColors.lightInputText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Öncelik"),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Yüksek",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text("Bitiş"),
                            SizedBox(height: 8),
                            Text(
                              "12 Eyl 2026",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.taskCardBackground
                      : AppColors.lightHomeTaskCardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.taskCardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Açıklama",
                        style: TextStyle(
                          color: isDark
                              ? AppColors.inputText
                              : AppColors.lightInputText,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        textAlign: TextAlign.justify,
                        "Üçüncü çeyreğe ait tüm kampanya performans verilerini derleyerek yönetim kuruluna sunulacak kapsamlı bir rapor hazırlanacak. Grafik ve karşılaştırmalar dahil edilmeli.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 24),
                    SizedBox(width: 8),
                    Text("Durumu Güncelle", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.taskCardBackground
                      : AppColors.lightHomeTaskCardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.taskCardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        "Ekler (2)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.inputText
                              : AppColors.lightInputText,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: isDark
                                  ? AppColors.statusInProgressBackground
                                  : AppColors
                                        .lightHomeStatusInProgressBackground,
                            ),
                            child: Icon(
                              Icons.insert_drive_file_outlined,
                              color: isDark
                                  ? AppColors.statusInProgress
                                  : AppColors.lightHomeStatusInProgress,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("q3_rapor_günlük.pdf"),
                              Text("2.5 MB"),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.file_download_outlined),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Divider(
                      indent: 10,
                      height: 10,
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: isDark
                                  ? AppColors.statusInProgressBackground
                                  : AppColors
                                        .lightHomeStatusInProgressBackground,
                            ),
                            child: Icon(
                              Icons.insert_drive_file_outlined,
                              color: isDark
                                  ? AppColors.statusInProgress
                                  : AppColors.lightHomeStatusInProgress,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("q3_rapor_günlük.pdf"),
                              Text("2.5 MB"),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.file_download_outlined),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.taskCardBackground
                      : AppColors.lightHomeTaskCardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.taskCardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        "Yorumlar (3)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.inputText
                              : AppColors.lightInputText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle, size: 36, color: Colors.blue),
                              Text(
                                "EY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Eray Kırşan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.inputText
                                        : AppColors.lightInputText,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.justify,
                                  "Rapor şablonunu drive'a yükledim, inceleyebilirsiniz.",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Text("2 sa önce"),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 10,
                      height: 10,
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle, size: 36, color: Colors.blue),
                              Text(
                                "EY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Eray Kırşan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.inputText
                                        : AppColors.lightInputText,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.justify,
                                  "Rapor şablonunu drive'a yükledim, inceleyebilirsiniz.",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Text("2 sa önce"),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 10,
                      height: 10,
                      thickness: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.lightDivider,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle, size: 36, color: Colors.blue),
                              Text(
                                "EY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Eray Kırşan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.inputText
                                        : AppColors.lightInputText,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.justify,
                                  "Rapor şablonunu drive'a yükledim, inceleyebilirsiniz.",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Text("2 sa önce"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _taskDetailAppBarWidget(bool isDark) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: isDark
          ? AppColors.headerBackground
          : AppColors.headerBorder,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "Görev Detayı",
        style: TextStyle(
          color: isDark ? AppColors.inputText : AppColors.lightInputText,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.notificationButton : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? AppColors.notificationButtonBorder
                  : Colors.grey.shade400,
            ),
          ),
          child: IconButton(
            onPressed: () {
              context.go("/tasks");
            },
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color: isDark ? AppColors.notificationIcon : Colors.grey,
            ),
          ),
        ),
      ),
      actions: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.notificationButton
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.notificationButtonBorder
                        : Colors.grey.shade400,
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: isDark ? AppColors.notificationIcon : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
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
