// lib/home/screens/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipeNameController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final List<TextEditingController> _instructionControllers = [];
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _addInstructionStep();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final userRole = await storage.read(key: 'userRole');
      setState(() {
        _isAdmin = userRole == 'admin';
      });
      
      if (!_isAdmin && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only Admin can add recipes'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error checking admin status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error checking permissions'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _addInstructionStep() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstructionStep(int index) {
    setState(() {
      _instructionControllers[index].dispose();
      _instructionControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        backgroundColor: AppColors.darkOliveGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _recipeNameController,
                label: 'Recipe Name',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter recipe name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cookingTimeController,
                label: 'Cooking Time (e.g., 30 minutes)',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter cooking time' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _servingsController,
                label: 'Servings (e.g., 4 servings)',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter servings' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _ingredientsController,
                label: 'Ingredients (comma separated)',
                maxLines: 3,
                helperText: 'Enter ingredients separated by commas',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter ingredients' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter image URL' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkOliveGreen,
                ),
              ),
              const SizedBox(height: 8),
              ..._buildInstructionFields(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addInstructionStep,
                icon: const Icon(Icons.add),
                label: const Text('Add Step'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sageGreen,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.honeydew)
                    : const Text(
                        'Add Recipe',
                        style: TextStyle(fontSize: 16, color: AppColors.honeydew),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInstructionFields() {
    return List.generate(_instructionControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _instructionControllers[index],
                decoration: InputDecoration(
                  labelText: 'Step ${index + 1}',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter instruction' : null,
              ),
            ),
            if (_instructionControllers.length > 1)
              IconButton(
                icon: const Icon(Icons.remove_circle),
                color: Colors.red,
                onPressed: () => _removeInstructionStep(index),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    int maxLines = 1,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        List<Map<String, dynamic>> instructions = [];
        for (int i = 0; i < _instructionControllers.length; i++) {
          instructions.add({
            'step_number': i + 1,
            'description': _instructionControllers[i].text,
          });
        }

        final result = await ApiService().addRecipe({
          'recipe_name': _recipeNameController.text,
          'cooking_time': _cookingTimeController.text,
          'servings': _servingsController.text,
          'ingredients_list': _ingredientsController.text,
          'image_url': _imageUrlController.text,
          'instructions_list': instructions.map((i) => i['description']).toList(),
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _cookingTimeController.dispose();
    _servingsController.dispose();
    _ingredientsController.dispose();
    _imageUrlController.dispose();
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}