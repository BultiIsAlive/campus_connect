import 'package:campus_connect/models/user.dart';
import 'package:campus_connect/providers/user_provider.dart';
import 'package:campus_connect/screens/chat_list_screen.dart';
import 'package:campus_connect/utils/colors.dart';
import 'package:campus_connect/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/CampusConnectLogo.svg',
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          height: 32,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) =>
        //               ChatListScreen(), // Create a new chat screen
        //         ),
        //       );
        //     },
        //     icon: const Icon(
        //       Icons.messenger_outline,
        //     ),
        //   ),
        // ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<String> following =
              List<String>.from(userSnapshot.data!['Following'] ?? []);

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Filter posts only from the user(s) whom the current user is following
              List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredPosts =
                  snapshot.data!.docs.where((post) {
                return following.contains(post['Uid']);
              }).toList();

              if (filteredPosts.isEmpty) {
                return Container(
                  child: Text(
                      "You are not following anyone or there are no posts from the users you are following."),
                  padding: EdgeInsets.all(50),
                );
              }

              return ListView.builder(
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  var postData = filteredPosts[index].data();
                  return PostCard(
                    snap: postData,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
