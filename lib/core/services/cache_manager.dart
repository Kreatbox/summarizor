import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
   Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_uidKey);
    await prefs.remove(_fullNameKey);
  }
  
   Future<User> getUser() async {
    final cachedUser = await getCachedUser();
    return User(email: cachedUser!['email']!, uid: cachedUser['uid']!, fullName: cachedUser['fullName']!,);
  }
  static const String _emailKey = 'email';
  static const String _uidKey = 'uid';
  static const String _fullNameKey = 'fullName';

  Future<void> cacheUser(String email, String uid, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_uidKey, uid);
    await prefs.setString(_fullNameKey, fullName);
  }

  Future<Map<String, String>?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString(_emailKey);
    final String? uid = prefs.getString(_uidKey);
    final String? fullName = prefs.getString(_fullNameKey);

    if (email == null || uid == null || fullName == null) {
      return null;
    }
    return {
      'email': email,
      'uid': uid,
      'fullName': fullName,
    };
  }
}
class User {
  final String email;
  final String uid;
  final String fullName;
  User({
    required this.email,
    required this.uid,
    required this.fullName,
  });
}
