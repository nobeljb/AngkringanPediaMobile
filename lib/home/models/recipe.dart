class Recipe {
  final int id;
  final String recipeName;
  final String cookingTime;
  final String servings;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.id,
    required this.recipeName,
    required this.cookingTime,
    required this.servings,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      recipeName: json['recipe_name'],
      cookingTime: json['cooking_time'],
      servings: json['servings'],
      imageUrl: json['image_url'],
      ingredients: List<String>.from(json['ingredients'].map((i) => i['name'])),
      instructions: json['instructions'],
    );
  }
}