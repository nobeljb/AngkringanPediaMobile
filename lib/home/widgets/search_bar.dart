// lib/home/widgets/search_bar.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String, String) onSearch;

  const CustomSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'none';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.honeydew,
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkOliveGreen.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
                  hintText: 'Search recipes...',
                  hintStyle: TextStyle(
                    color: AppColors.darkOliveGreen.withOpacity(0.5),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.darkOliveGreen,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onSubmitted: (value) => widget.onSearch(value, _selectedFilter),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.buttonColor,
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
                const PopupMenuItem(
                  value: 'none',
                  child: Text(
                    'No Filter',
                    style: TextStyle(color: AppColors.darkOliveGreen),
                  ),
                ),
                const PopupMenuItem(
                  value: 'name',
                  child: Text(
                    'By Name',
                    style: TextStyle(color: AppColors.darkOliveGreen),
                  ),
                ),
                const PopupMenuItem(
                  value: 'ingredient',
                  child: Text(
                    'By Ingredient',
                    style: TextStyle(color: AppColors.darkOliveGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}