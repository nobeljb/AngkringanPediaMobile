import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
import 'package:flutter/material.dart';
import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:angkringan_pedia/authentication/screens/edit_profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfileDetailPage extends StatelessWidget {
  final Profile profile;

  const ProfileDetailPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.fields.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://127.0.0.1:8000/authentication${profile.fields.profileImage}"),
                radius: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Username: ${profile.fields.username}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Email: ${profile.fields.email}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Phone Number: ${profile.fields.phoneNumber}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Gender: ${profile.fields.gender}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Role: ${profile.fields.isAdmin}",
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 40),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 40),
                    onPressed: () async {
                      final url =
                          "http://127.0.0.1:8000/authentication/adminkudeleteflutter/${profile.fields.user}";

                      final response = await http.delete(Uri.parse(url));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListProfilePage()),
                      );

                      // if (response.statusCode == 200) {
                      //   print("User deleted successfully: ${response.body}");
                      // } else {
                      //   print("Failed to delete user: ${response.statusCode}");
                      // }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
