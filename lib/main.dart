import 'dart:io';

import 'package:campus_connect/providers/user_provider.dart';
import 'package:campus_connect/responsive/mobile_screen_layout.dart';
import 'package:campus_connect/responsive/responsive_layout_screen.dart';
import 'package:campus_connect/responsive/web_screen_layout.dart';
import 'package:campus_connect/screens/login_screen.dart';
import 'package:campus_connect/screens/signup_screen.dart';
import 'package:campus_connect/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyABj4miVbbgoG4f7fzst_YGPyMYZ_SGis8',
        appId: '1:151791657367:web:e9e19b43a97f3b7f3ca4d2',
        messagingSenderId: '151791657367',
        projectId: 'campusconnect-7d166',
        storageBucket: 'campusconnect-7d166.appspot.com',
      ),
    );
  } else {
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: 'AIzaSyAY3NfmUGu4E9UQ7WVQzjVQsqmTm9wgFaE',
              appId: '1:151791657367:android:3ae1cdb46dd30e383ca4d2',
              messagingSenderId: '151791657367',
              projectId: 'campusconnect-7d166',
              storageBucket: 'campusconnect-7d166.appspot.com',
            ),
          )
        : await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Campus Connect',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
