import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
import 'package:flutter/material.dart';
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
  bool _deleteProfileImage = false; // Tambahkan ini
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
        _deleteProfileImage = false; // Jika pilih gambar, nonaktifkan delete
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dio = Dio();
        final url =
            "http://127.0.0.1:8000/authentication/edit-user-flutter/${widget.profile.fields.user}/";

        FormData formData = FormData.fromMap({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phone_number': _phoneNumberController.text,
          'delete_profile_image': _deleteProfileImage ? 'true' : 'false',
        });

        // menambahkan gambar profil jika dipilih
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              const SizedBox(height: 10),

              // email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty
                    ? 'Please enter an email'
                    : !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)
                        ? 'Please enter a valid email address'
                        : null,
              ),
              const SizedBox(height: 10),

              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a phone number' : null,
              ),
              const SizedBox(height: 10),

              // Delete Profile image
              CheckboxListTile(
                title: const Text('Delete Profile Image'),
                value: _deleteProfileImage,
                onChanged: (value) {
                  setState(() {
                    _deleteProfileImage = value!;
                    if (_deleteProfileImage) _profileImage = null;
                  });
                },
              ),

              // pick new profpic
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick New Profile Image'),
              ),
              if (_profileImage != null)
                Center(
                  child: Text(
                    'Image selected: ${_profileImage!.name}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              // if (_profileImage != null)
              //   Text('Selected Image: ${_profileImage!.name}'),
              const SizedBox(height: 20),

              // submit button
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
