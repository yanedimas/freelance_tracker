import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static double get goal => _prefs?.getDouble('goal') ?? 0.0;

  static Future<void> setGoal(double goal) async {
    await _prefs?.setDouble('goal', goal);
  }
}
