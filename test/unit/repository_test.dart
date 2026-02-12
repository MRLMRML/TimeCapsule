import 'package:flutter_test/flutter_test.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';

class MockTimeCapsuleRepository implements TimeCapsuleRepository {
  final Map<String, TimeCapsule> _storage = {};

  @override
  Future<List<TimeCapsule>> getAllCapsules() async {
    return _storage.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<TimeCapsule?> getCapsuleById(String id) async {
    return _storage[id];
  }

  @override
  Future<List<TimeCapsule>> getUnopenedCapsules() async {
    return _storage.values.where((c) => !c.isOpened).toList();
  }

  @override
  Future<List<TimeCapsule>> getUnlockedButNotNotifiedCapsules() async {
    final now = DateTime.now();
    return _storage.values
        .where((c) => !c.isOpened && c.unlockTime.isBefore(now) && !c.notificationScheduled)
        .toList();
  }

  @override
  Future<String> createCapsule(TimeCapsule capsule) async {
    _storage[capsule.id] = capsule;
    return capsule.id;
  }

  @override
  Future<void> updateCapsule(TimeCapsule capsule) async {
    _storage[capsule.id] = capsule;
  }

  @override
  Future<void> deleteCapsule(String id) async {
    _storage.remove(id);
  }

  @override
  Future<void> markAsOpened(String id) async {
    final capsule = _storage[id];
    if (capsule != null) {
      capsule.isOpened = true;
    }
  }

  @override
  Future<void> markNotificationScheduled(String id) async {
    final capsule = _storage[id];
    if (capsule != null) {
      capsule.notificationScheduled = true;
    }
  }
}

void main() {
  group('TimeCapsuleRepository', () {
    late MockTimeCapsuleRepository repository;

    setUp(() {
      repository = MockTimeCapsuleRepository();
    });

    test('createCapsule adds to storage', () async {
      final capsule = TimeCapsule(
        message: 'Test message',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );

      final id = await repository.createCapsule(capsule);

      expect(id, equals(capsule.id));
      expect(await repository.getCapsuleById(id), isNotNull);
    });

    test('getAllCapsules returns all capsules', () async {
      await repository.createCapsule(
        TimeCapsule(message: 'First', unlockTime: DateTime.now().add(const Duration(days: 1))),
      );
      await repository.createCapsule(
        TimeCapsule(message: 'Second', unlockTime: DateTime.now().add(const Duration(days: 2))),
      );

      final capsules = await repository.getAllCapsules();

      expect(capsules.length, 2);
    });

    test('deleteCapsule removes from storage', () async {
      final capsule = TimeCapsule(
        message: 'To delete',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );
      final id = await repository.createCapsule(capsule);

      await repository.deleteCapsule(id);

      expect(await repository.getCapsuleById(id), isNull);
    });

    test('markAsOpened only opens unlocked capsules', () async {
      final unlockedCapsule = TimeCapsule(
        message: 'Already unlocked',
        unlockTime: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final lockedCapsule = TimeCapsule(
        message: 'Still locked',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );

      final unlockedId = await repository.createCapsule(unlockedCapsule);
      final lockedId = await repository.createCapsule(lockedCapsule);

      await repository.markAsOpened(unlockedId);
      await repository.markAsOpened(lockedId);

      expect((await repository.getCapsuleById(unlockedId))!.isOpened, true);
      expect((await repository.getCapsuleById(lockedId))!.isOpened, false);
    });

    test('getUnlockedButNotNotifiedCapsules filters correctly', () async {
      final unlocked = TimeCapsule(
        message: 'Ready',
        unlockTime: DateTime.now().subtract(const Duration(hours: 1)),
        notificationScheduled: false,
      );
      final notified = TimeCapsule(
        message: 'Already notified',
        unlockTime: DateTime.now().subtract(const Duration(hours: 1)),
        notificationScheduled: true,
      );
      final locked = TimeCapsule(
        message: 'Not ready',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );

      await repository.createCapsule(unlocked);
      await repository.createCapsule(notified);
      await repository.createCapsule(locked);

      final unlockedCapsules = await repository.getUnlockedButNotNotifiedCapsules();

      expect(unlockedCapsules.length, 1);
      expect(unlockedCapsules.first.message, 'Ready');
    });
  });
}
