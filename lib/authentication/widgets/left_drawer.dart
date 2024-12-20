import 'dart:convert';
import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:angkringan_pedia/authentication/screens/edit_profile.dart';
import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
import 'package:angkringan_pedia/authentication/screens/login.dart';
import 'package:angkringan_pedia/authentication/screens/register.dart';
import 'package:angkringan_pedia/home/screens/home_page.dart';
import 'package:angkringan_pedia/home/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // cookie request
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
          _buildDrawerItem(
            context: context,
            icon: Icons.home_work,
            title: 'Admin Page',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ListProfilePage()),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            title: 'Home Page',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.edit,
            title: 'Edit my profile',
            onTap: () async {
              final storage = FlutterSecureStorage();
              final userId = await storage.read(key: 'id');

              final response = await http.get(Uri.parse(
                  'http://127.0.0.1:8000/authentication/user-detail/$userId'));

              if (response.statusCode == 200) {
                final profileData = jsonDecode(response.body);
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
          _buildDrawerItem(
            context: context,
            icon: Icons.delete,
            title: 'Delete my account',
            onTap: () async {
              final storage = FlutterSecureStorage();
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
                final response = await http.delete(Uri.parse(url));

                if (response.statusCode == 200) {
                  await storage.deleteAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Account deleted successfully.')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Failed to delete account: ${response.body}'),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.add,
            title: 'Add new user',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
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

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkOliveGreen),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.darkOliveGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
