import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => isLoading = true);
    // TODO: Implement API call to fetch recipes
    setState(() => isLoading = false);
  }

  Future<void> _handleSearch(String query, String filter) async {
    setState(() => isLoading = true);
    // TODO: Implement search functionality
    setState(() => isLoading = false);
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
                ? Center(
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
        label: Text(
          'Add Recipe',
          style: TextStyle(color: AppColors.honeydew),
        ),
        icon: Icon(Icons.add, color: AppColors.honeydew),
      ),
    );
  }
}
