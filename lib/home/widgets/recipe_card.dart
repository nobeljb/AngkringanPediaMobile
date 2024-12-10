// Update the RecipeCard class in recipe_card.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isAdmin;
  final Function()? onDelete;

  const RecipeCard({
    Key? key, 
    required this.recipe,
    required this.isAdmin,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to empty page when card is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(recipe.recipeName),
                backgroundColor: AppColors.darkOliveGreen,
              ),
              body: const Center(
                child: Text('Empty Page'),
              ),
            ),
          ),
        );
      },
      child: Card(
        color: AppColors.honeydew,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: AppColors.sageGreen.withOpacity(0.2),
                        child: Icon(
                          Icons.restaurant,
                          size: 40,
                          color: AppColors.darkOliveGreen.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.recipeName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkOliveGreen,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.buttonColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              recipe.cookingTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: AppColors.buttonColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              recipe.servings,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Recipe'),
                          content: Text('Are you sure you want to delete ${recipe.recipeName}?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                if (onDelete != null) {
                                  onDelete!();
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}