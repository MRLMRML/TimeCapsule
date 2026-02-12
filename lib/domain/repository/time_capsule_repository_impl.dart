import 'package:time_capsule/data/local/time_capsule_box.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';

class TimeCapsuleRepositoryImpl implements TimeCapsuleRepository {
  final TimeCapsuleBox _box;

  TimeCapsuleRepositoryImpl(this._box);

  @override
  Future<List<TimeCapsule>> getAllCapsules() async {
    final capsules = _box.getAll().values.toList();
    capsules.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return capsules;
  }

  @override
  Future<TimeCapsule?> getCapsuleById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<TimeCapsule>> getUnopenedCapsules() async {
    final capsules = _box.getAll().values.toList();
    return capsules.where((c) => !c.isOpened).toList();
  }

  @override
  Future<List<TimeCapsule>> getUnlockedButNotNotifiedCapsules() async {
    final now = DateTime.now();
    final capsules = _box.getAll().values.toList();
    return capsules
        .where((c) => !c.isOpened && c.isUnlocked && !c.notificationScheduled)
        .toList();
  }

  @override
  Future<String> createCapsule(TimeCapsule capsule) async {
    await _box.put(capsule.id, capsule);
    return capsule.id;
  }

  @override
  Future<void> updateCapsule(TimeCapsule capsule) async {
    await _box.put(capsule.id, capsule);
  }

  @override
  Future<void> deleteCapsule(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> markAsOpened(String id) async {
    final capsule = await getCapsuleById(id);
    if (capsule != null && capsule.isUnlocked && !capsule.isOpened) {
      capsule.isOpened = true;
      await updateCapsule(capsule);
    }
  }

  @override
  Future<void> markNotificationScheduled(String id) async {
    final capsule = await getCapsuleById(id);
    if (capsule != null) {
      capsule.notificationScheduled = true;
      await updateCapsule(capsule);
    }
  }
}
