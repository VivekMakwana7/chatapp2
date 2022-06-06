import 'package:shared_preferences/shared_preferences.dart';

class TextPreferences {
  static SharedPreferences? _preferences;

  static const _userEmail = 'email';
  static const _userName = 'name';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setEmail(String text) async =>
      await _preferences!.setString(_userEmail, text);
  static Future setName(String text) async =>
      await _preferences!.setString(_userName, text);


  static String getEmail() => _preferences!.getString(_userEmail) ?? '';
  static String getName() => _preferences!.getString(_userName) ?? '';

  static clearAllString() async {
      await _preferences!.clear();
  }
}
