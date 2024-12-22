// lib/home/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:angkringan_pedia/home/screens/add_recipe_screen.dart';
import '../widgets/header.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../authentication/models/profile.dart';
import 'package:http/http.dart' as http;

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final bool isAdmin;
  final Function(int)? onDeleteRecipe;

  const RecipeGrid({
    Key? key, 
    required this.recipes,
    required this.isAdmin,
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
          isAdmin: isAdmin,
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
  final storage = const FlutterSecureStorage();
  List<Recipe> recipes = [];
  bool isLoading = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final username = await storage.read(key: 'username');
      if (username == null) {
        setState(() => isAdmin = false);
        return;
      }

      final response = await http.get(
        Uri.parse('http://malvin-scafi-angkringanpedia.pbp.cs.ui.ac.id/auth/get_user_profile/$username/'),
      );

      if (response.statusCode == 200) {
        final List<Profile> profiles = profileFromJson(response.body);
        if (profiles.isNotEmpty) {
          setState(() {
            isAdmin = profiles[0].fields.isAdmin.toLowerCase() == 'true';
          });
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error checking admin status: $e');
      setState(() => isAdmin = false);
    }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load recipes: $e')),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to search recipes: $e')),
        );
      }
    }
  }

  Future<void> _handleDeleteRecipe(int recipeId) async {
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only Admin can delete recipes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final deleted = await _apiService.deleteRecipe(recipeId);
      if (deleted) {
        setState(() {
          recipes.removeWhere((recipe) => recipe.id == recipeId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete recipe: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleAddRecipe() async {
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only Admin can add recipes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );
    
    if (result == true && mounted) {
      _loadRecipes();
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
                : recipes.isEmpty
                    ? const Center(
                        child: Text(
                          'No recipes found',
                          style: TextStyle(
                            color: AppColors.darkOliveGreen,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : RecipeGrid(
                        recipes: recipes,
                        isAdmin: isAdmin,
                        onDeleteRecipe: isAdmin ? _handleDeleteRecipe : null,
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddRecipe,
        backgroundColor: AppColors.buttonColor,
        label: const Text(
          'Add Recipe',
          style: TextStyle(color: AppColors.honeydew),
        ),
        icon: const Icon(
          Icons.add,
          color: AppColors.honeydew,
        ),
      ),
    );
  }
}