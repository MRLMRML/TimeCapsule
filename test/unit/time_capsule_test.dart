import 'package:flutter_test/flutter_test.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';

void main() {
  group('TimeCapsule', () {
    test('isUnlocked returns true when time has passed', () {
      final capsule = TimeCapsule(
        message: 'Test message',
        unlockTime: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(capsule.isUnlocked, true);
    });

    test('isUnlocked returns false when time has not passed', () {
      final capsule = TimeCapsule(
        message: 'Test message',
        unlockTime: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(capsule.isUnlocked, false);
    });

    test('formattedUnlockTime returns correct format', () {
      final unlockTime = DateTime(2025, 6, 15, 14, 30);
      final capsule = TimeCapsule(
        message: 'Test',
        unlockTime: unlockTime,
      );

      expect(capsule.formattedUnlockTime, '6/15/2025 14:30');
    });

    test('createdFormatted returns correct format', () {
      final createdAt = DateTime(2025, 6, 1, 10, 0);
      final capsule = TimeCapsule(
        message: 'Test',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
        createdAt: createdAt,
      );

      expect(capsule.createdFormatted, '6/1/2025 10:00');
    });

    test('default values are set correctly', () {
      final capsule = TimeCapsule(
        message: 'Test',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );

      expect(capsule.isOpened, false);
      expect(capsule.notificationScheduled, false);
      expect(capsule.id, isNotEmpty);
    });

    test('toJson returns correct map', () {
      final unlockTime = DateTime(2025, 6, 15, 14, 30);
      final createdAt = DateTime(2025, 6, 1, 10, 0);
      final capsule = TimeCapsule(
        id: 'test-id',
        message: 'Test message',
        unlockTime: unlockTime,
        createdAt: createdAt,
        isOpened: true,
        notificationScheduled: true,
      );

      final json = capsule.toJson();

      expect(json['id'], 'test-id');
      expect(json['message'], 'Test message');
      expect(json['isOpened'], true);
      expect(json['notificationScheduled'], true);
    });

    test('fromJson creates correct instance', () {
      final json = {
        'id': 'test-id',
        'message': 'Test message',
        'unlockTime': '2025-06-15T14:30:00.000',
        'createdAt': '2025-06-01T10:00:00.000',
        'isOpened': true,
        'notificationScheduled': false,
      };

      final capsule = TimeCapsule.fromJson(json);

      expect(capsule.id, 'test-id');
      expect(capsule.message, 'Test message');
      expect(capsule.isOpened, true);
      expect(capsule.notificationScheduled, false);
    });

    test('copyWith creates modified copy', () {
      final original = TimeCapsule(
        id: 'test-id',
        message: 'Original',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );

      final modified = original.copyWith(
        message: 'Modified',
        isOpened: true,
      );

      expect(modified.id, original.id);
      expect(modified.message, 'Modified');
      expect(modified.isOpened, true);
      expect(modified.unlockTime, original.unlockTime);
    });

    test('equality is based on id', () {
      final capsule1 = TimeCapsule(
        id: 'same-id',
        message: 'First',
        unlockTime: DateTime.now().add(const Duration(days: 1)),
      );

      final capsule2 = TimeCapsule(
        id: 'same-id',
        message: 'Different message',
        unlockTime: DateTime.now().add(const Duration(days: 2)),
      );

      expect(capsule1, equals(capsule2));
    });
  });
}
