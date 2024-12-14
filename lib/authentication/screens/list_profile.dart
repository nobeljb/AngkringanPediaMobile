import 'package:angkringan_pedia/authentication/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:angkringan_pedia/authentication/models/profile.dart';
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
    final response = await request.get('http://127.0.0.1:8000/authentication/json/');
    List<Profile> profiles = [];

    for (var data in response) {
      profiles.add(Profile.fromJson(data));
    }
    return profiles;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Profiles'),
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
            return const Center(child: Text('Belum ada data user pada Angkringan Pedia.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final profile = snapshot.data[index];
                final imageUrl = "http://127.0.0.1:8000/${profile.fields.profileImage}"; 
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  title: Text(profile.fields.username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetailPage(profile: profile),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
