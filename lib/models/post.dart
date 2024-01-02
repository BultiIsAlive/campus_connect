import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "Description": description,
        "Uid": uid,
        "Username": username,
        "PostId": postId,
        "DatePublished": datePublished,
        "PostUrl": postUrl,
        "ProfImage": profImage,
        "Likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['Description'],
      uid: snapshot['Uid'],
      username: snapshot['Username'],
      postId: snapshot['PostId'],
      datePublished: snapshot['DatePublished'],
      postUrl: snapshot['PostUrl'],
      profImage: snapshot['ProfImage'],
      likes: snapshot['Likes'],
    );
  }
}
