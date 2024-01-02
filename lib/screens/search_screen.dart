import 'package:campus_connect/screens/profile_screen.dart';
import 'package:campus_connect/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'Username',
                    isGreaterThanOrEqualTo: searchController.text.toLowerCase(),
                  )
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    (snapshot.data! as QuerySnapshot).docs.isEmpty) {
                  return Center(
                    child: Text('No matching users found'),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    var userData = (snapshot.data! as QuerySnapshot)
                        .docs[index]
                        .data() as Map<String, dynamic>;
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: userData['Uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userData['PhotoUrl']),
                        ),
                        title: Text(
                          userData['Username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    (snapshot.data! as QuerySnapshot).docs.isEmpty) {
                  return Center(
                    child: Text('No posts yet'),
                  );
                }

                // Shuffle the list of posts to get random suggested posts
                var posts = (snapshot.data! as QuerySnapshot).docs;
                posts.shuffle();

                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: posts.length,
                  itemBuilder: (context, index) => Image.network(
                    posts[index]['PostUrl'],
                    fit: BoxFit.cover,
                  ),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
