import 'package:flutter/material.dart';
import 'package:angkringan_pedia/authentication/models/profile.dart';

class ProfileDetailPage extends StatelessWidget {
  final Profile profile;

  const ProfileDetailPage({Key? key, required this.profile}) : super(key: key);

  // Function to delete the profile
  Future<void> deleteProfile(BuildContext context) async {
    // Call the API to delete the profile (this needs to be implemented)
    // Assuming you have a function `deleteProfileAPI` to delete the profile
    // final response = await deleteProfileAPI(profile.id);

    // Show a snackbar or handle the response
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile deleted successfully.')),
    );

    // Optionally, navigate back to the previous page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.fields.username),
        actions: [
          // You can remove the delete button in the app bar
          // or leave it if you want both buttons.
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage("http://127.0.0.1:8000/authentication${profile.fields.profileImage}"),
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
            const Spacer(), // Spacer to push the delete button to the bottom
            Align(
              alignment: Alignment.bottomCenter, // Make sure the delete button is at the bottom
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 40), // Delete icon
                onPressed: () async {
                  // Confirm the deletion with a dialog
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Profile'),
                        content: const Text('Are you sure you want to delete this profile?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDelete == true) {
                    // Proceed with the deletion
                    await deleteProfile(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
