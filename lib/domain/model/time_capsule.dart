import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'time_capsule.g.dart';

@HiveType(typeId: 0)
class TimeCapsule extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String message;

  @HiveField(2)
  DateTime unlockTime;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isOpened;

  @HiveField(5)
  bool notificationScheduled;

  TimeCapsule({
    String? id,
    required this.message,
    required this.unlockTime,
    DateTime? createdAt,
    this.isOpened = false,
    this.notificationScheduled = false,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  bool get isUnlocked => DateTime.now().isAfter(unlockTime);

  String get formattedUnlockTime {
    return DateFormat('M/d/yyyy HH:mm').format(unlockTime);
  }

  String get createdFormatted {
    return DateFormat('M/d/yyyy HH:mm').format(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'unlockTime': unlockTime.toIso8601String(),
      'createdAt': createdAt.toIso860String(),
      'isOpened': isOpened,
      'notificationScheduled': notificationScheduled,
    };
  }

  factory TimeCapsule.fromJson(Map<String, dynamic> json) {
    return TimeCapsule(
      id: json['id'],
      message: json['message'],
      unlockTime: DateTime.parse(json['unlockTime']),
      createdAt: DateTime.parse(json['createdAt']),
      isOpened: json['isOpened'],
      notificationScheduled: json['notificationScheduled'],
    );
  }

  TimeCapsule copyWith({
    String? id,
    String? message,
    DateTime? unlockTime,
    DateTime? createdAt,
    bool? isOpened,
    bool? notificationScheduled,
  }) {
    return TimeCapsule(
      id: id ?? this.id,
      message: message ?? this.message,
      unlockTime: unlockTime ?? this.unlockTime,
      createdAt: createdAt ?? this.createdAt,
      isOpened: isOpened ?? this.isOpened,
      notificationScheduled: notificationScheduled ?? this.notificationScheduled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeCapsule && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
