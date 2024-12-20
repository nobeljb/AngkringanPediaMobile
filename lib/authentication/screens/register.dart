import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:angkringan_pedia/authentication/screens/login.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _gender = 'M'; // Default gender
  XFile? _profileImage;
  bool _isAdmin = false;

  final ImagePicker _picker = ImagePicker();

  // Method untuk memilih image dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
    });
  }

  Future<void> _registerUser() async {
    final String username = _usernameController.text;
    final String password1 = _passwordController.text;
    final String password2 = _confirmPasswordController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String gender = _gender;

    try {
      final dio = Dio();

      MultipartFile? profileImageFile;
      if (_profileImage != null) {
        final fileBytes = await _profileImage!.readAsBytes();
        profileImageFile = MultipartFile.fromBytes(
          fileBytes,
          filename: _profileImage!.name,
          contentType: MediaType('image', 'jpeg'),
        );
      }

      final formData = FormData.fromMap({
        'username': username,
        'password1': password1,
        'password2': password2,
        'email': email,
        'phone_number': phone,
        'gender': gender,
        'is_admin': _isAdmin.toString(),
        if (profileImageFile != null) 'profile_image': profileImageFile,
      });

      final response = await dio.post(
        "http://127.0.0.1:8000/authentication/register-flutter/",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to register: ${response.data['message'] ?? 'Unknown error'}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-z0-9]')), // Hanya huruf kecil dan angka
                    ],
                  ),

                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')), // Hanya huruf kecil dan angka
                    ],
                  ),

                  const SizedBox(height: 12.0),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'M',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'F',
                        child: Text('Female'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),
                  CheckboxListTile(
                    title: const Text('Register as Admin'),
                    value: _isAdmin,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAdmin = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  const SizedBox(height: 12.0),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library,
                        color: Colors.white), // Ikon putih
                    label: const Text('Pick Profile Image',
                        style: TextStyle(color: Colors.white)), // Teks putih
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  if (_profileImage != null)
                    Center(
                      child: Text(
                        'Image selected: ${_profileImage!.name}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),

                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      // Validasi empty field
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Field cannot be empty.')),
                        );
                        return;
                      }

                      // Validasi email format
                      final emailRegex = RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                      if (!emailRegex.hasMatch(_emailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please enter a valid email address.')),
                        );
                        return;
                      }

                      // Validasi phone number
                      final phoneRegex = RegExp(
                          r'^[0-9]{10,15}$'); // Hanya angka, panjang 10-15 digit
                      if (!phoneRegex.hasMatch(_phoneController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please enter a valid phone number.')),
                        );
                        return;
                      }

                      // Validasi password
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Password doesn\'t match.')),
                        );
                        return;
                      }

                      // Validasi Admin
                      if (_isAdmin &&
                          (_passwordController.text != 'kadalganteng' ||
                              _confirmPasswordController.text !=
                                  'kadalganteng')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid Admin password.')),
                        );
                        return;
                      }

                      // Panggil fungsi registrasi user jika validasi lolos
                      _registerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
