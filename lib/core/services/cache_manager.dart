import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _emailKey = 'email';
  static const String _uidKey = 'uid';
  static const String _fullNameKey = 'fullName';

  Future<void> cacheUser(String email, String uid, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_uidKey, uid);
    await prefs.setString(_fullNameKey, fullName);
  }

  Future<void> saveUser(User user) async {
    await cacheUser(user.email, user.uid, user.fullName);
  }

  Future<User?> getUser() async {
    final cachedUserMap = await getCachedUser();
    if (cachedUserMap == null) {
      return null;
    }
    return User(
      email: cachedUserMap['email']!,
      uid: cachedUserMap['uid']!,
      fullName: cachedUserMap['fullName']!,
    );
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_uidKey);
    await prefs.remove(_fullNameKey);
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

  User copyWith({
    String? email,
    String? uid,
    String? fullName,
  }) {
    return User(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
    );
  }
}