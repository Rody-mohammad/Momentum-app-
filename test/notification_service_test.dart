import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/services/database_service.dart';
import 'package:momentum/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

import 'test_database.dart';

void main() {
  late _FakeNotificationClient client;

  setUpAll(() async {
    await initializeTestDatabase();
    client = _FakeNotificationClient();
    NotificationService.setClientForTesting(client);
    await NotificationService.init();
  });

  setUp(() async {
    client.reset();
    await resetTestDatabase();
  });

  test('schedules one daily reminder at the habit time', () async {
    await NotificationService.scheduleHabitReminder(
      Habit(
        id: 'daily-reminder',
        name: 'Journal',
        category: HabitCategory.mind,
        timeOfDay: HabitTimeOfDay.evening,
      ),
    );

    expect(client.scheduledNotificationCount, 1);
  });

  test('does not schedule reminders when the user disables them', () async {
    await DatabaseService.setSetting('remindersEnabled', false);

    await NotificationService.scheduleHabitReminder(
      Habit(
        id: 'disabled-reminder',
        name: 'Stretch',
        category: HabitCategory.health,
        timeOfDay: HabitTimeOfDay.morning,
      ),
    );

    expect(client.scheduledNotificationCount, 0);
  });
}

class _FakeNotificationClient implements NotificationClient {
  int scheduledNotificationCount = 0;

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<void> initialize(InitializationSettings settings) async {}

  void reset() {
    scheduledNotificationCount = 0;
  }

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
  }) async {
    scheduledNotificationCount++;
  }
}