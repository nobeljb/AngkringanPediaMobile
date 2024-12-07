// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Recipe> recipes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => isLoading = true);
    try {
      final loadedRecipes = await _apiService.getRecipes();
      setState(() {
        recipes = loadedRecipes;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load recipes: $e')),
      );
    }
  }

  Future<void> _handleSearch(String query, String filter) async {
    setState(() => isLoading = true);
    try {
      final searchResults = await _apiService.searchRecipes(query, filter);
      setState(() {
        recipes = searchResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search recipes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Header(onSearch: _handleSearch),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkOliveGreen,
                    ),
                  )
                : RecipeGrid(recipes: recipes),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.buttonColor,
        label: const Text(
          'Add Recipe',
          style: TextStyle(color: AppColors.honeydew),
        ),
        icon: const Icon(Icons.add, color: AppColors.honeydew),
      ),
    );
  }
}