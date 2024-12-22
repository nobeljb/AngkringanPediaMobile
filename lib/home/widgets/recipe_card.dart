import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:angkringan_pedia/foodcatalog/screens/recipe_details.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final Function()? onDelete;

  const RecipeCard({
    Key? key, 
    required this.recipe,
    this.onDelete,
  }) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isAdmin = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final adminStatus = await storage.read(key: 'isAdmin');
    setState(() {
      isAdmin = adminStatus == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to recipe details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipeId: widget.recipe.id),
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
                    widget.recipe.imageUrl,
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
                        widget.recipe.recipeName,
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
                              widget.recipe.cookingTime,
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
                              widget.recipe.servings,
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
            // Only show delete button if user is admin and onDelete callback exists
            if (isAdmin && widget.onDelete != null)
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
                            content: Text('Are you sure you want to delete ${widget.recipe.recipeName}?'),
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
                                  widget.onDelete!();
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