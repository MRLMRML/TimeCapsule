import 'package:time_capsule/domain/model/time_capsule.dart';

abstract class TimeCapsuleRepository {
  Future<List<TimeCapsule>> getAllCapsules();
  Future<TimeCapsule?> getCapsuleById(String id);
  Future<List<TimeCapsule>> getUnopenedCapsules();
  Future<List<TimeCapsule>> getUnlockedButNotNotifiedCapsules();
  Future<String> createCapsule(TimeCapsule capsule);
  Future<void> updateCapsule(TimeCapsule capsule);
  Future<void> deleteCapsule(String id);
  Future<void> markAsOpened(String id);
  Future<void> markNotificationScheduled(String id);
}
