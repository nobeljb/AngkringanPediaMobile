import 'package:angkringan_pedia/foodcatalog/screens/add_rating_review.dart';
import 'package:angkringan_pedia/home/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/details.dart';
import '../../home/theme/app_theme.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RecipeDetails extends StatelessWidget {
  final int recipeId; // Tambahkan parameter recipeId

  const RecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme, // Terapkan tema
      child: RecipeScreen(recipeId: recipeId),
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
  int? userId;
  bool hasUserReview = false;
  bool isAdmin = false;
  final storage = FlutterSecureStorage();

  // Fungsi untuk mengambil userId dari FlutterSecureStorage dan mengonversinya ke integer
  Future<int?> getUserIdFromStorage() async {
    String? idStr = await storage.read(key: 'id');
    return idStr != null ? int.tryParse(idStr) : null;  // Mengonversi string ke int
  }

  // Ambil data dari API berdasarkan ID
  Future<Recipe> fetchRecipe() async {
    final request = context.read<CookieRequest>();
    final response = await request.get("http://127.0.0.1:8000/catalog/${widget.recipeId}/json");
    username = await storage.read(key: 'username');
    userId = await getUserIdFromStorage();
    isAdmin = await storage.read(key: 'isAdmin') == 'true';

    // Periksa apakah pengguna sudah memberikan ulasan
    if (username != null) {
      hasUserReview = response['ratings'].any(
        (rating) => rating['username'] == username,
      );
    }

    return recipeFromJson(jsonEncode(response));
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

  void checkReview(List<dynamic> ratings) {
    if (username == null) {
      // Tampilkan dialog jika pengguna belum login
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: AppTheme.theme, // Terapkan tema kustom untuk dialog
          child: AlertDialog(
            title: const Text('Not Logged In'),
            content: const Text('You need to log in to leave a review.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Cari review pengguna berdasarkan username
      final userReview = ratings.firstWhere(
        (rating) => rating['username'] == username,
        orElse: () => null,
      );

      if (userReview != null) {
        // Jika sudah mereview, navigasikan ke form dengan data yang ada
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Theme(
              data: AppTheme.theme, // Terapkan tema kustom untuk RatingReviewForm
              child: RatingReviewForm(
                recipeId: recipeId!,
                reviewId: userReview['id'], // Kirim ID review ke form
                userId: userId!,
                initialRating: userReview['score'].toDouble(),
                initialReview: userReview['content'],
                hasReviewed: true, // Tandai bahwa pengguna telah memberikan ulasan
              ),
            ),
          ),
        );
      } else {
        // Jika belum memberikan review, navigasikan ke form untuk menambahkan ulasan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Theme(
              data: AppTheme.theme, // Terapkan tema kustom untuk RatingReviewForm
              child: RatingReviewForm(
                recipeId: recipeId!,
                userId: userId!,
                hasReviewed: false, // Tandai bahwa belum ada ulasan
              ),
            ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ikon panah balik
          onPressed: () {
            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
            );
          },
        ),
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
                          final isUserReview = rating["username"] == username; // Cek apakah ulasan milik pengguna saat ini

                          return Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding untuk memperindah tampilan
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${rating["username"]}:',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        rating["score"],
                                        (index) => const Icon(Icons.star, color: Colors.orange, size: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        rating["content"],
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    if (isUserReview || isAdmin) // Tampilkan tombol hanya untuk ulasan pengguna yang sedang login
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            // Navigasi ke form untuk mengedit ulasan
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Theme(
                                                  data: AppTheme.theme,
                                                  child: RatingReviewForm(
                                                    recipeId: recipeId!,
                                                    reviewId: rating["id"], // Kirim ID ulasan ke form
                                                    userId: userId!,
                                                    initialRating: rating["score"].toDouble(),
                                                    initialReview: rating["content"],
                                                    hasReviewed: true,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.edit, color: Colors.blue, size: 18.0),
                                          label: const Text(
                                            "Edit",
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Divider(), // Tambahkan pembatas antara ulasan
                            ],
                          );
                        },
                      ),
                      if (!hasUserReview && !isAdmin)
                        ElevatedButton(
                          onPressed: () => checkReview(recipe.ratings),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkOliveGreen,
                          ),
                          child: const Text('Add A Review'),
                        ),
                    ]else ...[
                      Column(
                        children: [
                          if (!isAdmin) ...[
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Mengatur posisi ke kiri
                              children: [
                                Text(
                                  "No ratings yet",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkOliveGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Mengatur posisi ke kiri
                              children: [
                                Text(
                                  "Be the first to leave a review!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.darkOliveGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Mengatur posisi ke kiri
                              children: [
                                ElevatedButton(
                                  onPressed: () => checkReview(recipe.ratings),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkOliveGreen,
                                  ),
                                  child: const Text('Add A Review'),
                                ),
                              ],
                            ),
                          ],
                        ],
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