import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for the form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  File? _profileImage; // Image file for profile image
  final storage = FlutterSecureStorage(); // Secure storage instance

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page loads
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to fetch user data from server
  Future<void> fetchUserData() async {
    final id = await storage.read(key: 'id'); // Get user ID from secure storage
    // final id = await storage.read(key: 'id');
    if (id == null) {
      print("Error: User ID not found in secure storage");
      return;
    } else {
      print("id: $id");
    }

    final response = await http
        .get(Uri.parse("http://127.0.0.1:8000/authentication/user-detail/$id"));

    // final response = await http
    //     .get(Uri.parse("http://127.0.0.1:8000/authentication/user-detail/$id"));
    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _usernameController.text = data['username'];
        _emailController.text = data['email'];
        _phoneNumberController.text = data['phone_number'];
      });
    } else {
      // print("Failed to fetch user data: ${response.body}");
    }
  }

  // Function to submit updated user data
  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      final id = await storage.read(key: 'id'); // Get user ID
      final uri = Uri.parse(
          "http://127.0.0.1:8000/authentication/edit-user-flutter/$id");

      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['username'] = _usernameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneNumberController.text;

      // Add profile image if picked
      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', _profileImage!.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pop(context); // Navigate back after success
      } else {
        print("Failed to update profile");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                    child: _profileImage == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 10),

              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a phone number' : null,
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitData,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
