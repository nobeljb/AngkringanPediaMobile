// lib/home/widgets/header.dart

import 'package:angkringan_pedia/authentication/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
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
  bool _isSearchExpanded = false;

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final request = context.read<CookieRequest>();
                  final response = await request.logout(
                      "https://malvin-scafi-angkringanpedia.pbp.cs.ui.ac.id/authentication/logout-flutter/");

                  if (response['status']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "${response['message']} Sampai jumpa, ${response['username']}."),
                      ),
                    );
                    final storage = FlutterSecureStorage();
                    await storage.deleteAll();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  } else {
                    _showErrorMessage(context, response["message"]);
                  }
                } catch (e) {
                  _showErrorMessage(context, "Logout failed. Please try again.");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getSearchHint() {
    switch (_selectedFilter) {
      case 'name':
        return 'Search by recipe name...';
      case 'ingredient':
        return 'Search by ingredient...';
      case 'servings':
        return 'Search by number of servings...';
      case 'cooking_time':
        return 'Search by cooking time...';
      default:
        return 'Search recipes...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      color: AppColors.darkOliveGreen,
      child: Column(
        children: [
          // Top bar with logo, title, and action buttons
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 16,
              vertical: isMobile ? 8 : 12,
            ),
            child: Row(
              children: [
                // Logo and Title
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo2.png',
                        height: isMobile ? 32 : 40,
                      ),
                      const SizedBox(width: 8),
                      if (!isMobile || !_isSearchExpanded)
                        Text(
                          'AngkringanPedia',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.honeydew,
                          ),
                        ),
                    ],
                  ),
                ),
                // Mobile search toggle button
                if (isMobile)
                  IconButton(
                    icon: Icon(
                      _isSearchExpanded ? Icons.close : Icons.search,
                      color: AppColors.honeydew,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchExpanded = !_isSearchExpanded;
                        if (!_isSearchExpanded) {
                          _searchController.clear();
                          widget.onSearch('', 'none'); // Reset search
                        }
                      });
                    },
                  ),
                // Action buttons (visible on desktop or when search is collapsed on mobile)
                if (!isMobile || !_isSearchExpanded)
                  Row(
                    children: [
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
                      HoverIconButton(
                        icon: Icons.logout,
                        onPressed: () => _handleLogout(context),
                        defaultColor: AppColors.honeydew,
                        hoverColor: Colors.red[300]!,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Search bar section
          if (!isMobile || _isSearchExpanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 16,
                vertical: 8,
              ),
              decoration: isMobile
                  ? BoxDecoration(
                      color: AppColors.darkOliveGreen.withOpacity(0.95),
                    )
                  : null,
              child: Row(
                children: [
                  // Search TextField
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
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppColors.darkOliveGreen),
                        decoration: InputDecoration(
                          hintText: _getSearchHint(),
                          hintStyle: TextStyle(
                            color: AppColors.darkOliveGreen.withOpacity(0.5),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.darkOliveGreen,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: (value) => widget.onSearch(value, _selectedFilter),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        _buildFilterItem('servings', 'By Servings'),
                        _buildFilterItem('cooking_time', 'By Cooking Time'),
                      ],
                    ),
                  ),
                ],
              ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

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
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }
}