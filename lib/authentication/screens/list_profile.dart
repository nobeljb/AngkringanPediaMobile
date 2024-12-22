import 'package:angkringan_pedia/authentication/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'profile_detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ListProfilePage extends StatefulWidget {
  const ListProfilePage({super.key});

  @override
  State<ListProfilePage> createState() => _ListProfilePageState();
}

class _ListProfilePageState extends State<ListProfilePage> {
  Future<List<Profile>> fetchProfiles(CookieRequest request) async {
    final response =
        await request.get('https://malvin-scafi-angkringanpedia.pbp.cs.ui.ac.id/authentication/json/');
    List<Profile> profiles = [];

    final storage = FlutterSecureStorage();

    final String? idString = await storage.read(key: 'id');
    final int? userId = idString != null ? int.tryParse(idString) : null;

    for (var data in response) {
      final profile = Profile.fromJson(data);
      if (profile.fields.user != userId) {
        profiles.add(profile);
      }
    }

    return profiles;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Profiles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProfiles(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'Belum ada data user pada Angkringan Pedia.',
              style: TextStyle(fontSize: 16),
            ));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final profile = snapshot.data[index];
                final imageUrl =
                    "https://malvin-scafi-angkringanpedia.pbp.cs.ui.ac.id/${profile.fields.profileImage}";
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileDetailPage(profile: profile),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(imageUrl),
                            backgroundColor: primaryColor.withOpacity(0.1),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fields.username,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.fields.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
