// lib/screens/home_page.dart
import 'package:angkringan_pedia/home/screens/add_recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/header.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final Function(int)? onDeleteRecipe;

  const RecipeGrid({
    Key? key, 
    required this.recipes,
    this.onDeleteRecipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          onDelete: onDeleteRecipe != null 
            ? () => onDeleteRecipe!(recipe.id)
            : null,
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Recipe> recipes = [];
  bool isLoading = false;
  bool isAdmin = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final adminStatus = await storage.read(key: 'isAdmin');
    setState(() {
      isAdmin = adminStatus == 'true';
    });
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
                : RecipeGrid(
                    recipes: recipes,
                    onDeleteRecipe: isAdmin ? (int recipeId) async {
                      try {
                        final deleted = await ApiService().deleteRecipe(recipeId);
                        if (deleted) {
                          setState(() {
                            recipes.removeWhere((recipe) => recipe.id == recipeId);
                          });
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete recipe: $e')),
                        );
                      }
                    } : null,
                  ),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
          if (result == true) {
            _loadRecipes();
          }
        },
        backgroundColor: AppColors.buttonColor,
        label: const Text('Add Recipe', style: TextStyle(color: AppColors.honeydew)),
        icon: const Icon(Icons.add, color: AppColors.honeydew),
      ) : null,
    );
  }
}
