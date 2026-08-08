import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/project_detail_screen.dart';
import 'services/notification_service.dart';
import 'services/background_task_service.dart';
import 'data/database_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();
  
  if (Platform.isAndroid) {
    await BackgroundTaskService.scheduleNextAlarm();
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ProjectsApp());
}

class ProjectsApp extends StatefulWidget {
  const ProjectsApp({super.key});

  @override
  State<ProjectsApp> createState() => _ProjectsAppState();
}

class _ProjectsAppState extends State<ProjectsApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _handleInitialNotification();
    _notificationService.onNotificationClick.listen((String? payload) {
      _navigateToProject(payload);
    });
  }

  Future<void> _handleInitialNotification() async {
    final payload = await _notificationService.getInitialPayload();
    if (payload != null) {
      // Delay navigation to let the app initialize
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToProject(payload);
      });
    }
  }

  void _navigateToProject(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      final projectId = int.tryParse(payload);
      if (projectId != null) {
        final dbHelper = DatabaseHelper();
        final project = await dbHelper.getProject(projectId);
        if (project != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(project: project),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'I miei Progetti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
