// lib/authentication/screens/edit_profile.dart

import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  const EditProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _profileImage;
  bool _deleteProfileImage = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _usernameController.text = widget.profile.fields.username;
    _emailController.text = widget.profile.fields.email;
    _phoneNumberController.text = widget.profile.fields.phoneNumber;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
      if (pickedFile != null)
        _deleteProfileImage = false; // Nonaktifkan delete jika ada gambar
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dio = Dio();
        final url =
            "https://malvin-scafi-angkringanpedia.pbp.cs.ui.ac.id/authentication/edit-user-flutter/${widget.profile.fields.user}/";

        FormData formData = FormData.fromMap({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'delete_profile_image': _deleteProfileImage ? 'true' : 'false',
        });

        if (_profileImage != null && !_deleteProfileImage) {
          final fileBytes = await _profileImage!.readAsBytes();
          final profileImageFile = MultipartFile.fromBytes(
            fileBytes,
            filename: _profileImage!.name,
            contentType: MediaType('image', 'jpeg'),
          );
          formData.files.add(MapEntry('profile_image', profileImageFile));
        }

        final response = await dio.post(url, data: formData);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListProfilePage()),
          );
        } else {
          final errorMessage =
              response.data['message'] ?? 'Failed to update profile.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $errorMessage")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-z0-9]')), // Hanya huruf kecil dan angka
                ],
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Hanya angka
                ],
              ),
              const SizedBox(height: 16),

              // Delete Profile Image Checkbox
              CheckboxListTile(
                title: const Text('Delete Profile Image'),
                value: _deleteProfileImage,
                onChanged: (value) {
                  setState(() {
                    _deleteProfileImage = value!;
                    if (_deleteProfileImage) _profileImage = null;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Theme.of(context).colorScheme.primary,
              ),

              // Pick New Profile Image Button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text(
                  'Pick New Profile Image',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
              if (_profileImage != null)
                Center(
                  child: Text(
                    'Image selected: ${_profileImage!.name}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 20),

              // Save Changes Button
              ElevatedButton(
                onPressed: () {
                  if (_usernameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _phoneNumberController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Field cannot be empty.')),
                    );
                    return;
                  }

                  final emailRegex = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                  if (!emailRegex.hasMatch(_emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid email address.')),
                    );
                    return;
                  }

                  final phoneRegex = RegExp(r'^[0-9]{10,15}$');
                  if (!phoneRegex.hasMatch(_phoneNumberController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid phone number.')),
                    );
                    return;
                  }

                  _submitData();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

