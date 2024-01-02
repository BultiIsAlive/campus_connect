import 'dart:typed_data';

import 'package:campus_connect/models/post.dart';
import 'package:campus_connect/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'Likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'Likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'ProfilePic': profilePic,
          'Name': name,
          'Uid': uid,
          'Text': text,
          'CommentId': commentId,
          'DatePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  // Delete Post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot userSnap =
          await _firestore.collection('users').doc(uid).get();
      DocumentSnapshot followUserSnap =
          await _firestore.collection('users').doc(followId).get();

      List<String> following =
          List<String>.from((userSnap.data()! as dynamic)['Following']);
      List<String> followers =
          List<String>.from((userSnap.data()! as dynamic)['Followers']);

      if (following.contains(followId)) {
        // Unfollow
        await _firestore.collection('users').doc(uid).update({
          'Following': FieldValue.arrayRemove([followId]),
        });

        await _firestore.collection('users').doc(followId).update({
          'Followers': FieldValue.arrayRemove([uid]),
        });
      } else {
        // Follow
        await _firestore.collection('users').doc(uid).update({
          'Following': FieldValue.arrayUnion([followId]),
        });

        await _firestore.collection('users').doc(followId).update({
          'Followers': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
