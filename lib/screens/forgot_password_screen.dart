import 'package:campus_connect/screens/login_screen.dart';
import 'package:campus_connect/utils/colors.dart';
import 'package:campus_connect/utils/global_variables.dart';
import 'package:campus_connect/utils/utils.dart';
import 'package:campus_connect/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void navigateToLogin() {
    Navigator.of(context).pop(); // Go back to the login screen
  }

  void ResetPassword() {
    String email = _emailController.text;

    // Reference to the users collection in Firestore
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Check if the email exists in the users collection
    users.where('Email', isEqualTo: email).get().then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        // Email is not registered
        showSnackBar('Email is not registered', context);
      } else {
        // Email is registered, send reset password email
        _auth.sendPasswordResetEmail(email: email).then((value) {
          showSnackBar('Email Sent', context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        }).onError((error, stackTrace) {
          showSnackBar(error.toString(), context);
        });
      }
    }).onError((error, stackTrace) {
      // Handle error querying the users collection
      showSnackBar('Error checking email registration: $error', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo SVG Image
                  SvgPicture.asset(
                    'assets/CampusConnectLogo.svg',
                    colorFilter:
                        ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 60,
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  // Email Input TextArea
                  TextFieldInput(
                    hintText: 'E-mail',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // Reset Password Button
                  InkWell(
                    onTap: ResetPassword,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Reset Password'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: blueColor,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // Login Transition
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Already have an account? "),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
