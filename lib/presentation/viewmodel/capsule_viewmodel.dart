import 'package:flutter/foundation.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/workers/notification_worker.dart';

class CapsuleViewModel extends ChangeNotifier {
  final TimeCapsuleRepository _repository;

  List<TimeCapsule> _capsules = [];
  TimeCapsule? _selectedCapsule;
  bool _isLoading = false;
  String? _error;

  CapsuleViewModel(this._repository);

  List<TimeCapsule> get capsules => _capsules;
  TimeCapsule? get selectedCapsule => _selectedCapsule;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCapsules() async {
    _isLoading = true;
    notifyListeners();

    try {
      _capsules = await _repository.getAllCapsules();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCapsule(String message, DateTime unlockTime) async {
    if (message.trim().isEmpty) {
      _error = 'Message cannot be empty';
      notifyListeners();
      return;
    }

    if (unlockTime.isBefore(DateTime.now())) {
      _error = 'Unlock time must be in the future';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final capsule = TimeCapsule(
        message: message.trim(),
        unlockTime: unlockTime,
      );
      await _repository.createCapsule(capsule);
      await loadCapsules();
      await schedulePeriodicCheck();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCapsule(String id) async {
    try {
      await _repository.deleteCapsule(id);
      await loadCapsules();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> openCapsule(String id) async {
    try {
      final capsule = await _repository.getCapsuleById(id);
      if (capsule != null && capsule.isUnlocked) {
        await _repository.markAsOpened(id);
        _selectedCapsule = capsule.copyWith(isOpened: true);
        await loadCapsules();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadCapsuleById(String id) async {
    try {
      _selectedCapsule = await _repository.getCapsuleById(id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearSelectedCapsule() {
    _selectedCapsule = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
