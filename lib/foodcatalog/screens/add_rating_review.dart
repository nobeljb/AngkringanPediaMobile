import 'dart:convert';

import 'package:angkringan_pedia/foodcatalog/screens/recipe_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../home/theme/app_theme.dart'; // Import your custom theme
import 'package:http/http.dart' as http;

class RatingReviewForm extends StatefulWidget {
  final double initialRating; // Initial rating passed as argument
  final String initialReview; // Initial review passed as argument
  final int recipeId; // Recipe ID passed as argument
  final int userId; // User ID passed as argument

  const RatingReviewForm({
    Key? key,
    this.initialRating = 0.0, // Default value if no rating is passed
    this.initialReview = '', // Default value if no review is passed
    required this.recipeId, // Recipe ID is required
    required this.userId, // User ID is required
  }) : super(key: key);

  @override
  _RatingReviewFormState createState() => _RatingReviewFormState();
}

class _RatingReviewFormState extends State<RatingReviewForm> {
  final _formKey = GlobalKey<FormState>();
  late double _rating;
  late TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    // Initialize the rating and review controller with passed values
    _rating = widget.initialRating;
    _reviewController = TextEditingController(text: widget.initialReview);
  }

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      // Check if rating is valid (greater than 0)
      if (_rating == 0.0) {
        // Show an error if rating is 0
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a rating')),
        );
        return;
      }

      // Prepare the data to send to Django
      final reviewData = {
        'user_id': widget.userId,
        'recipe_id': widget.recipeId,
        'score': _rating.toInt(),
        'content': _reviewController.text,
      };

      // Send HTTP POST request to Django
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/catalog/flutter/create/'), // Replace with your Django server URL
          headers: {
            'Content-Type': 'application/json',
            // You may need to add an Authorization header for user authentication if needed
          },
          body: json.encode(reviewData),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Review Submitted Successfully!')),
            );
            // Navigate back to RecipeDetails page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetails(recipeId: widget.recipeId),
              ),
            );
          }
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit review.')),
          );
        }
      } catch (e) {
        // Handle network error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error, please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate & Review'),
        backgroundColor: AppColors.darkOliveGreen, // Custom theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rate the Recipe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false, // Prevent half ratings
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Write a Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a review';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkOliveGreen, // Custom theme color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
