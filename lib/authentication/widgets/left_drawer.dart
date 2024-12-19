import 'dart:convert';

import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:angkringan_pedia/authentication/screens/edit_profile.dart';
import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
import 'package:angkringan_pedia/authentication/screens/login.dart';
import 'package:angkringan_pedia/authentication/screens/register.dart';
import 'package:angkringan_pedia/home/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // cookie request
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get request dari provider
    final request = context.watch<CookieRequest>();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Angkringan Pedia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Ngopi Santai, Cemilan Asyik",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text('Admin Page'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ListProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit my profile'),
            onTap: () async {
              final storage = FlutterSecureStorage();

              // Ambil user ID dari storage
              final userId = await storage.read(key: 'id');

              // Ambil profil user dari backend
              final response = await http.get(Uri.parse(
                  'http://127.0.0.1:8000/authentication/user-detail/$userId'));

              if (response.statusCode == 200) {
                final profileData = jsonDecode(response.body);

                // Buat objek Profile dari response
                final userProfile = Profile.fromJson(profileData);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(profile: userProfile),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete my account'),
            onTap: () async {
              final storage = FlutterSecureStorage(); // Inisialisasi storage

              // Ambil id user dari FlutterSecureStorage
              final id = await storage.read(key: 'id');
              if (id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: User ID not found.')),
                );
                return;
              }

              final url =
                  "http://127.0.0.1:8000/authentication/adminkudeleteflutter/$id";

              try {
                // Kirim request DELETE ke server
                final response = await http.delete(Uri.parse(url));

                if (response.statusCode == 200) {
                  // Hapus data lokal (logout)
                  await storage.deleteAll();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Account deleted successfully.')),
                  );

                  // Arahkan user ke halaman login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Failed to delete account: ${response.body}')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add new user'),
          
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            // Handle logout operation
            onTap: () async {
              final response = await request.logout(
                  "http://127.0.0.1:8000/authentication/logout-flutter/");
              String message = response["message"];
              if (context.mounted) {
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  final storage = FlutterSecureStorage();

                  // Hapus semua data
                  await storage.deleteAll();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
