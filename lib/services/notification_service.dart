import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/services/database_service.dart';

abstract interface class NotificationClient {
  Future<void> initialize(InitializationSettings settings);

  Future<void> cancel(int id);

  Future<void> cancelAll();

  Future<void> zonedSchedule(
    int id,
    String? title,
    String? body,
    tz.TZDateTime scheduledDate,
    NotificationDetails notificationDetails, {
    required AndroidScheduleMode androidScheduleMode,
    required UILocalNotificationDateInterpretation
        uiLocalNotificationDateInterpretation,
    DateTimeComponents? matchDateTimeComponents,
  });
}

class FlutterNotificationClient implements NotificationClient {
  FlutterNotificationClient({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> initialize(InitializationSettings settings) async {
    await _plugin.initialize(settings);
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<void> zonedSchedule(
    int id,
    String? title,
    String? body,
    tz.TZDateTime scheduledDate,
    NotificationDetails notificationDetails, {
    required AndroidScheduleMode androidScheduleMode,
    required UILocalNotificationDateInterpretation
        uiLocalNotificationDateInterpretation,
    DateTimeComponents? matchDateTimeComponents,
  }) {
    return _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: androidScheduleMode,
      matchDateTimeComponents: matchDateTimeComponents,
      uiLocalNotificationDateInterpretation:
          uiLocalNotificationDateInterpretation,
    );
  }
}

/// Service that manages local push notifications for habit reminders.
class NotificationService {
  NotificationService._();

  static NotificationClient _client = FlutterNotificationClient();

  static bool _initialized = false;

  /// Replaces the platform client for deterministic tests.
  static void setClientForTesting(NotificationClient client) {
    _client = client;
    _initialized = false;
  }

  /// Initialize the notification plugin and timezone data.
  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestBadgePermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _client.initialize(initSettings);
    _initialized = true;
  }

  /// Whether daily reminders are enabled by the user.
  static bool get remindersEnabled =>
      DatabaseService.getSetting<bool>('remindersEnabled') ?? true;

  /// Toggle the daily reminders setting and reschedule or cancel accordingly.
  static Future<void> setRemindersEnabled({
    required bool enabled,
    required List<Habit> habits,
  }) async {
    await DatabaseService.setSetting('remindersEnabled', enabled);
    if (enabled) {
      await rescheduleAll(habits);
    } else {
      await cancelAll();
    }
  }

  /// Returns the [TimeOfDay] hour/minute pair for a given [HabitTimeOfDay].
  static ({int hour, int minute}) _timeForSlot(HabitTimeOfDay slot) {
    switch (slot) {
      case HabitTimeOfDay.morning:
        return (hour: 8, minute: 0);
      case HabitTimeOfDay.afternoon:
        return (hour: 13, minute: 0);
      case HabitTimeOfDay.evening:
        return (hour: 19, minute: 0);
      case HabitTimeOfDay.anytime:
        return (hour: 9, minute: 0);
    }
  }

  /// Generates a stable integer ID from the habit's UUID for notification
  /// channel grouping. We take the first 8 hex chars of the UUID.
  static int _notificationId(String habitId) =>
      habitId.hashCode.abs() % 0x7FFFFFFF;

  // ── Schedule ────────────────────────────────────────────────────────────

  /// Schedule a notification for [habit] based on its frequency type.
  static Future<void> scheduleHabitReminder(Habit habit) async {
    if (!remindersEnabled) return;

    // Cancel any existing notification for this habit first.
    await cancelHabitReminder(habit.id);

    final time = _timeForSlot(habit.timeOfDay);
    final baseId = _notificationId(habit.id);

    switch (habit.frequencyType) {
      case FrequencyType.daily:
        await _scheduleDailyNotification(
          id: baseId,
          title: 'Momentum Reminder',
          body: 'Time to complete: ${habit.name}',
          hour: time.hour,
          minute: time.minute,
        );

      case FrequencyType.weekly:
        // Schedule one notification per selected weekday.
        for (var i = 0; i < habit.weeklyDays.length; i++) {
          final weekday = habit.weeklyDays[i];
          await _scheduleWeeklyNotification(
            id: baseId + weekday,
            title: 'Momentum Reminder',
            body: 'Time to complete: ${habit.name}',
            hour: time.hour,
            minute: time.minute,
            weekday: weekday,
          );
        }

      case FrequencyType.interval:
        // For interval habits, schedule the next upcoming occurrence.
        await _scheduleNextInterval(
          habit: habit,
          id: baseId,
          title: 'Momentum Reminder',
          body: 'Time to complete: ${habit.name}',
          hour: time.hour,
          minute: time.minute,
        );
    }
  }

  /// Cancel all notifications tied to [habitId].
  static Future<void> cancelHabitReminder(String habitId) async {
    final baseId = _notificationId(habitId);
    // Cancel the base ID and all possible weekday offsets (1-7).
    await _client.cancel(baseId);
    for (var day = 1; day <= 7; day++) {
      await _client.cancel(baseId + day);
    }
  }

  /// Cancel every pending notification.
  static Future<void> cancelAll() async {
    await _client.cancelAll();
  }

  /// Reschedule notifications for all active (non-archived) habits.
  static Future<void> rescheduleAll(List<Habit> habits) async {
    await cancelAll();
    if (!remindersEnabled) return;
    for (final habit in habits) {
      if (!habit.isArchived) {
        await scheduleHabitReminder(habit);
      }
    }
  }

  // ── Private scheduling helpers ──────────────────────────────────────────

  static NotificationDetails get _notificationDetails {
    const android = AndroidNotificationDetails(
      'momentum_habit_reminders',
      'Habit Reminders',
      channelDescription: 'Daily reminders for your habits',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    return const NotificationDetails(android: android, iOS: ios);
  }

  static Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);
    await _client.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required int weekday,
  }) async {
    final scheduledDate = _nextInstanceOfWeekday(weekday, hour, minute);
    await _client.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> _scheduleNextInterval({
    required Habit habit,
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Walk forward from today to find the next scheduled date.
    final now = DateTime.now();
    var candidate = DateTime(now.year, now.month, now.day);

    for (var i = 0; i < 365; i++) {
      if (habit.isScheduledOn(candidate)) {
        final candidateTime = tz.TZDateTime(
          tz.local,
          candidate.year,
          candidate.month,
          candidate.day,
          hour,
          minute,
        );
        if (candidateTime.isAfter(tz.TZDateTime.now(tz.local))) {
          await _client.zonedSchedule(
            id,
            title,
            body,
            candidateTime,
            _notificationDetails,
            androidScheduleMode:
                AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          return;
        }
      }
      candidate = candidate.add(const Duration(days: 1));
    }
  }

  // ── Time helpers ────────────────────────────────────────────────────────

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static tz.TZDateTime _nextInstanceOfWeekday(
    int weekday,
    int hour,
    int minute,
  ) {
    var scheduled = _nextInstanceOfTime(hour, minute);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
