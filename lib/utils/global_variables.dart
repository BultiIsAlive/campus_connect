import 'package:campus_connect/screens/add_post_screen.dart';
import 'package:campus_connect/screens/feed_screen.dart';
import 'package:campus_connect/screens/profile_screen.dart';
import 'package:campus_connect/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  // const Text('Notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
