import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String filterType = 'none';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.darkOliveGreen,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo2.png',
                height: 40,
              ),
              const SizedBox(width: 12),
              Text(
                'AngkringanPedia',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.honeydew,
                ),
              ),
            ],
          ),
          actions: [
            HoverIconButton(
              icon: Icons.favorite_border,
              onPressed: () {},
            ),
            HoverIconButton(
              icon: Icons.person,
              onPressed: () {},
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            onSearch: (query, filter) {
              setState(() {
                searchQuery = query;
                filterType = filter;
              });
              _loadRecipes();
            },
          ),
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