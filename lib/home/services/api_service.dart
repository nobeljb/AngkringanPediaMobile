// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/'; // Update with your server URL

  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/recipes/'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> recipesJson = data['recipes'];
        return recipesJson.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<List<Recipe>> searchRecipes(String query, String filter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/search/').replace(
          queryParameters: {
            'query': query,
            'filter': filter,
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> recipesJson = data['recipes'];
        return recipesJson.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search recipes');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}