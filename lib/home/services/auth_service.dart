// lib/home/services/auth_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../authentication/models/profile.dart';

class AuthService {
  static const String baseUrl = 'http://malvin-scafi-angkringanpedia.pbp.cs.ui.ac.id';
  final storage = const FlutterSecureStorage();

  Future<bool> checkIsAdmin() async {
    try {
      final username = await storage.read(key: 'username');
      if (username == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/get_user_profile/$username/'),
      );

      if (response.statusCode == 200) {
        final List<Profile> profiles = profileFromJson(response.body);
        if (profiles.isNotEmpty) {
          return profiles[0].fields.isAdmin.toLowerCase() == 'true';
        }
      }
      return false;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  Future<Profile?> getCurrentUserProfile() async {
    try {
      final username = await storage.read(key: 'username');
      if (username == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/get_user_profile/$username/'),
      );

      if (response.statusCode == 200) {
        final List<Profile> profiles = profileFromJson(response.body);
        if (profiles.isNotEmpty) {
          return profiles[0];
        }
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
}