import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final String registration;
  final String enrollment;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.registration,
    required this.enrollment,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "Username": username,
        "Uid": uid,
        "Email": email,
        "Bio": bio,
        "PhotoUrl": photoUrl,
        "Registration": registration,
        "Enrollment": enrollment,
        "Followers": followers,
        "Following": following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['Username'],
      uid: snapshot['Uid'],
      email: snapshot['Email'],
      photoUrl: snapshot['PhotoUrl'],
      bio: snapshot['Bio'],
      registration: snapshot['Registration'],
      enrollment: snapshot['Enrollment'],
      followers: snapshot['Followers'],
      following: snapshot['Following'],
    );
  }
}
