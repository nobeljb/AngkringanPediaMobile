// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/'; // Update with your server URL

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

  Future<Map<String, dynamic>> addRecipe(Map<String, dynamic> recipeData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/add-recipe/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(recipeData),
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error occurred');
        }
      } else {
        // Try to decode error message if available
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to add recipe');
        } catch (e) {
          throw Exception('Failed to add recipe. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else {
        throw Exception('Failed to connect to server: $e');
      }
    }
  }

  // Add error handling for getRecipes
  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/recipes/'),
        headers: {
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> recipesJson = data['recipes'];
        return recipesJson.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else {
        throw Exception('Failed to connect to server: $e');
      }
    }
  }

  Future<bool> deleteRecipe(int recipeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$recipeId'),
        headers: {
          'Accept': 'application/json',
        },
      );
      
      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
}
