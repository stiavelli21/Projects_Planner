import 'dart:math';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'notification_service.dart';

const int _alarmId = 0;

class BackgroundTaskService {
  static Future<void> scheduleNextAlarm() async {
    final now = DateTime.now();
    int daysUntilSaturday = DateTime.saturday - now.weekday;
    
    if (daysUntilSaturday < 0 || (daysUntilSaturday == 0 && (now.hour > 12 || (now.hour == 12 && now.minute >= 0)))) {
      daysUntilSaturday += 7;
    }
    
    DateTime nextSaturday = DateTime(now.year, now.month, now.day).add(Duration(days: daysUntilSaturday));
    nextSaturday = nextSaturday.add(const Duration(hours: 12));

    await AndroidAlarmManager.oneShotAt(
      nextSaturday,
      _alarmId,
      _alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _alarmCallback() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inizializza i servizi
    final dbHelper = DatabaseHelper();
    final notificationService = NotificationService();
    await notificationService.init();

    // Ottieni tutti i progetti
    final projects = await dbHelper.getProjects();
    
    if (projects.isNotEmpty) {
      // Scegli un progetto a caso
      final random = Random();
      final randomProject = projects[random.nextInt(projects.length)];
      
      // Mostra la notifica
      await notificationService.showNotification(
        id: randomProject.id ?? 0,
        title: randomProject.title,
        body: randomProject.description,
        payload: randomProject.id.toString(),
      );
    }
    
    // Pianifica il prossimo allarme
    await scheduleNextAlarm();
  }
}
