// import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:angkringan_pedia/authentication/models/profile.dart';
// import 'package:angkringan_pedia/authentication/screens/edit_profile.dart';
// import 'package:http/http.dart' as http;

// class ProfileDetailPage extends StatelessWidget {
//   final Profile profile;

//   const ProfileDetailPage({Key? key, required this.profile}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(profile.fields.username),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Image
//             Center(
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "http://127.0.0.1:8000/${profile.fields.profileImage}"),
//                 radius: 50,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Profile Details
//             Text(
//               "Username: ${profile.fields.username}",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 8),

//             Text(
//               "Email: ${profile.fields.email}",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 8),

//             Text(
//               "Phone Number: ${profile.fields.phoneNumber}",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 8),

//             Text(
//               "Gender: ${profile.fields.gender == 'F' ? 'Female' : 'Male'}",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 8),

//             Text(
//               "Role: ${profile.fields.isAdmin}",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const Spacer(),

//             // Action Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Edit Button
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 40),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EditProfilePage(profile: profile),
//                       ),
//                     );
//                   },
//                 ),

//                 // Delete Button
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red, size: 40),
//                   onPressed: () async {
//                     final url =
//                         "http://127.0.0.1:8000/authentication/adminkudeleteflutter/${profile.fields.user}";

//                     final response = await http.delete(Uri.parse(url));

//                     if (response.statusCode == 200) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text("User deleted successfully!")),
//                       );
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ListProfilePage(),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Failed to delete user.")),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:angkringan_pedia/authentication/screens/list_profile.dart';
import 'package:flutter/material.dart';
import 'package:angkringan_pedia/authentication/models/profile.dart';
import 'package:angkringan_pedia/authentication/screens/edit_profile.dart';
import 'package:http/http.dart' as http;

class ProfileDetailPage extends StatelessWidget {
  final Profile profile;

  const ProfileDetailPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile.fields.username,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center( // Center everything in the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              // Profile Image (Enlarged)
              CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://127.0.0.1:8000/${profile.fields.profileImage}"),
                radius: 100, // Increased radius for a larger profile image
                backgroundColor: primaryColor.withOpacity(0.2),
              ),
              const SizedBox(height: 30),

              // Profile Details Card (Enlarged)
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Larger radius for card corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0), // Increased padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username: ${profile.fields.username}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Email: ${profile.fields.email}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Phone Number: ${profile.fields.phoneNumber}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Gender: ${profile.fields.gender == 'F' ? 'Female' : 'Male'}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Role: ${profile.fields.isAdmin}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Action Buttons (Enlarged and Centered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Edit Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(profile: profile),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 30, color: Colors.white), // Enlarged icon
                    label: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 18, color: Colors.white), // Larger font size
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Enlarged button size
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24), // Space between buttons
                  // Delete Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final url =
                          "http://127.0.0.1:8000/authentication/adminkudeleteflutter/${profile.fields.user}";

                      final response = await http.delete(Uri.parse(url));

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User deleted successfully!")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListProfilePage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to delete user.")),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete, size: 30, color: Colors.white), // Enlarged icon
                    label: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 18, color: Colors.white), // Larger font size
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Enlarged button size
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

