// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    String model;
    int pk;
    Fields fields;

    Profile({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String username;
    String email;
    String phoneNumber;
    String gender;
    String isAdmin;
    String profileImage;

    Fields({
        required this.user,
        required this.username,
        required this.email,
        required this.phoneNumber,
        required this.gender,
        required this.isAdmin,
        required this.profileImage,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        gender: json["gender"],
        isAdmin: json["is_admin"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "is_admin": isAdmin,
        "profile_image": profileImage,
    };
}
