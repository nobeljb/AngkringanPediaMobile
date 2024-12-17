// To parse this JSON data, do
//
//     final recipe = recipeFromJson(jsonString);

import 'dart:convert';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
    int id;
    String name;
    String imageUrl;
    String cookingTime;
    String servings;
    List<Ingredient> ingredients;
    List<Instruction> instructions;
    List<dynamic> ratings;
    dynamic averageRating;
    bool hasReviewed;

    Recipe({
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.cookingTime,
        required this.servings,
        required this.ingredients,
        required this.instructions,
        required this.ratings,
        required this.averageRating,
        required this.hasReviewed,
    });

    factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
        cookingTime: json["cooking_time"],
        servings: json["servings"],
        ingredients: List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
        instructions: List<Instruction>.from(json["instructions"].map((x) => Instruction.fromJson(x))),
        ratings: List<dynamic>.from(json["ratings"].map((x) => x)),
        averageRating: json["average_rating"],
        hasReviewed: json["has_reviewed"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
        "cooking_time": cookingTime,
        "servings": servings,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
        "instructions": List<dynamic>.from(instructions.map((x) => x.toJson())),
        "ratings": List<dynamic>.from(ratings.map((x) => x)),
        "average_rating": averageRating,
        "has_reviewed": hasReviewed,
    };
}

class Ingredient {
    int id;
    String name;

    Ingredient({
        required this.id,
        required this.name,
    });

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Instruction {
    int id;
    int stepNumber;
    String description;

    Instruction({
        required this.id,
        required this.stepNumber,
        required this.description,
    });

    factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        id: json["id"],
        stepNumber: json["step_number"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "step_number": stepNumber,
        "description": description,
    };
}
