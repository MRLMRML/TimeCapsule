import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_capsule/data/local/time_capsule_box.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository_impl.dart';
import 'package:time_capsule/utils/notification_helper.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'checkUnlockedCapsules':
        await _checkAndNotifyUnlockedCapsules();
        break;
    }
    return Future.value(true);
  });
}

Future<void> _checkAndNotifyUnlockedCapsules() async {
  await Hive.initFlutter();
  await TimeCapsuleBox.openBox();

  final repository = TimeCapsuleBox.repository;
  final unlockedCapsules = await repository.getUnlockedButNotNotifiedCapsules();

  for (final capsule in unlockedCapsules) {
    await NotificationHelper.showNotification(
      id: capsule.id.hashCode,
      title: 'Your Time Capsule is Ready!',
      body: capsule.message.length > 50
          ? '${capsule.message.substring(0, 50)}...'
          : capsule.message,
    );
    await repository.markNotificationScheduled(capsule.id);
  }
}

Future<void> schedulePeriodicCheck() async {
  Workmanager().registerPeriodicTask(
    'capsule-notification-check',
    'checkUnlockedCapsules',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

Future<void> cancelScheduledCheck() async {
  Workmanager().cancelByUniqueName('capsule-notification-check');
}
