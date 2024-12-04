import 'package:angkringan_pedia/home/models/recipe.dart';
import 'package:angkringan_pedia/home/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatefulWidget {
  final Function(String, String) onSearch;

  const Header({Key? key, required this.onSearch}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'none';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkOliveGreen,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Logo and Title
          Row(
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
          const SizedBox(width: 24),
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.search,
                    color: AppColors.darkOliveGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppColors.darkOliveGreen),
                      decoration: InputDecoration(
                        hintText: 'Search recipes...',
                        hintStyle: TextStyle(
                          color: AppColors.darkOliveGreen.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onSubmitted: (value) => widget.onSearch(value, _selectedFilter),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filter Button
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.oliveDrab,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.filter_list,
                color: AppColors.honeydew,
              ),
              color: AppColors.honeydew,
              onSelected: (String value) {
                setState(() => _selectedFilter = value);
                widget.onSearch(_searchController.text, value);
              },
              itemBuilder: (BuildContext context) => [
                _buildFilterItem('none', 'No Filter'),
                _buildFilterItem('name', 'By Name'),
                _buildFilterItem('ingredient', 'By Ingredient'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Action Buttons
          HoverIconButton(
            icon: Icons.favorite_border,
            onPressed: () {},
            defaultColor: AppColors.honeydew,
            hoverColor: AppColors.sageGreen,
          ),
          HoverIconButton(
            icon: Icons.person,
            onPressed: () {},
            defaultColor: AppColors.honeydew,
            hoverColor: AppColors.sageGreen,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildFilterItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        text,
        style: const TextStyle(color: AppColors.darkOliveGreen),
      ),
    );
  }
}

// Updated HoverIconButton
class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color defaultColor;
  final Color hoverColor;

  const HoverIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.defaultColor,
    required this.hoverColor,
  }) : super(key: key);

  @override
  _HoverIconButtonState createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: IconButton(
        icon: Icon(
          widget.icon,
          color: isHovered ? widget.hoverColor : widget.defaultColor,
        ),
        onPressed: widget.onPressed,
        splashRadius: 24,
      ),
    );
  }
}

// Update the HomePage to use the new Header
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  bool isLoading = false;

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