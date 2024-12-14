import 'package:angkringan_pedia/foodcatalog/screens/add_rating_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/details.dart'; // Pastikan model Recipe berada di sini
import '../../home/theme/app_theme.dart'; // Import tema aplikasi

class RecipeDetails extends StatelessWidget {
  final int recipeId; // Tambahkan parameter recipeId

  const RecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme, // Terapkan tema kustom
      home: RecipeScreen(recipeId: recipeId), // Teruskan recipeId
    );
  }
}

class RecipeScreen extends StatefulWidget {
  final int recipeId; // Parameter ID

  const RecipeScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late Future<Recipe> recipe;
  String? username; // Simpan nama pengguna yang sedang login
  int? recipeId;
  final storage = FlutterSecureStorage();

  // Ambil data dari API berdasarkan ID
  Future<Recipe> fetchRecipe() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/catalog/${widget.recipeId}/json'), // Gunakan widget.recipeId
    );

    if (response.statusCode == 200) {
      username = await storage.read(key: 'username');
      return recipeFromJson(response.body);
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  @override
  void initState() {
    super.initState();
    recipe = fetchRecipe();
  }

  // Fungsi untuk membuat ikon bintang berdasarkan rating
  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor(); // Jumlah bintang penuh
    bool hasHalfStar = (rating - fullStars) >= 0.5; // Cek apakah ada bintang setengah

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.orange); // Bintang penuh
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.orange); // Bintang setengah
        } else {
          return const Icon(Icons.star_border, color: Colors.orange); // Bintang kosong
        }
      }),
    );
  }

  // Fungsi untuk mengecek apakah pengguna sudah memberikan ulasan
  void checkReview(List<dynamic> ratings) {
    if (username == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Not Logged In'),
          content: const Text('You need to log in to leave a review.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final hasReviewed = ratings.any((rating) => rating['username'] == username);
      if (hasReviewed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Already Reviewed'),
            content: const Text('You have already reviewed this recipe.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Jika belum memberikan review, pindahkan ke halaman untuk menambahkan review
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RatingReviewForm(recipeId: recipeId!), // Halaman untuk menambahkan ulasan
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        backgroundColor: AppColors.darkOliveGreen,
      ),
      body: FutureBuilder<Recipe>(
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final recipe = snapshot.data!;
            recipeId = recipe.id; // Simpan ID resep
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Resep
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkOliveGreen,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Gambar Resep
                    Container(
                      width: double.infinity, // Atur gambar agar memenuhi lebar layar
                      height: 200, // Tentukan tinggi gambar
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // Berikan border radius
                        color: Colors.grey[200], // Background placeholder saat gambar belum dimuat
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Sesuaikan dengan border Container
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover, // Atur bagaimana gambar diisi dalam area
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Waktu Memasak dan Porsi
                    Text(
                      "Cooking Time: ${recipe.cookingTime}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Servings: ${recipe.servings}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Rating Rata-Rata
                    if (recipe.averageRating != null) ...[
                      const Text(
                        "Average Rating:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkOliveGreen,
                        ),
                      ),
                      buildRatingStars(recipe.averageRating),
                      const SizedBox(height: 8),
                    ],

                    // Bahan-Bahan
                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = recipe.ingredients[index];
                        return ListTile(
                          leading:
                              Icon(Icons.check, color: AppColors.sageGreen),
                          title: Text(ingredient.name),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Instruksi
                    const Text(
                      "Instructions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.instructions.length,
                      itemBuilder: (context, index) {
                        final instruction = recipe.instructions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(instruction.stepNumber.toString()),
                            backgroundColor: AppColors.darkOliveGreen,
                          ),
                          title: Text(instruction.description),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Rating dan Review
                    if (recipe.ratings.isNotEmpty) ...[
                      const Text(
                        "Ratings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.ratings.length,
                        itemBuilder: (context, index) {
                          final rating = recipe.ratings[index];
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  '${rating["username"]}:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(
                                    rating["score"],
                                    (index) => const Icon(Icons.star,
                                        color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(rating["content"]),
                          );
                        },
                      ),
                      // Tombol untuk mengecek ulasan
                      ElevatedButton(
                        onPressed: () => checkReview(recipe.ratings),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkOliveGreen,
                        ),
                        child: const Text('Check My Review'),
                      ),
                    ]else ...[
                      const Text(
                        "No ratings yet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Be the first to leave a review!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tombol untuk menambahkan review jika tidak ada rating
                      ElevatedButton(
                        onPressed: () {
                          // Arahkan ke halaman untuk menambahkan rating dan review
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RatingReviewForm(recipeId: recipeId!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkOliveGreen,
                        ),
                        child: const Text('Add a Review'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const RecipeDetails(recipeId: 1)); // Contoh penggunaan dengan ID 1
}
