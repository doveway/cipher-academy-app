import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class StorageService {
  static const String _userProgressKey = 'user_progress';
  static const String _userIdKey = 'user_id';
  static const String _firstLaunchKey = 'first_launch';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    final json = jsonEncode(progress.toJson());
    await _prefs.setString(_userProgressKey, json);
  }

  UserProgress? getUserProgress() {
    final json = _prefs.getString(_userProgressKey);
    if (json == null) return null;

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return UserProgress.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  Future<void> clearAllData() async {
    await _prefs.clear();
  }

  Future<void> resetHintCountIfNeeded(UserProgress progress) async {
    final now = DateTime.now();
    final lastReset = progress.lastHintResetDate;

    if (now.day != lastReset.day ||
        now.month != lastReset.month ||
        now.year != lastReset.year) {
      final updatedProgress = progress.copyWith(
        hintsUsedToday: 0,
        lastHintResetDate: now,
      );
      await saveUserProgress(updatedProgress);
    }
  }
}
