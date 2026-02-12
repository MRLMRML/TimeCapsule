import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository_impl.dart';

class TimeCapsuleBox {
  static const String _boxName = 'time_capsules';
  static late Box<TimeCapsule> _box;

  static Future<void> openBox() async {
    _box = await Hive.openBox<TimeCapsule>(_boxName);
  }

  static Box<TimeCapsule> get getBox => _box;

  static TimeCapsuleRepository get repository => TimeCapsuleRepositoryImpl(_box);

  static Future<void> closeBox() async {
    await _box.close();
  }
}
