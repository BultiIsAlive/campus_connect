import 'dart:async';
import 'dart:typed_data';
import 'package:campus_connect/models/user.dart' as model;
import 'package:campus_connect/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // Signing Up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required String registration,
    required String enrollment,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      // Validate username format
      if (!isValidUsername(username)) {
        return 'Invalid username format. Username can only contain lowercase alphabets, dots, underscores, and numbers.';
      }

      // Validate email format
      if (!isValidEmail(email)) {
        return 'Invalid email format. Email must end with @gmail.com.';
      }
      // Validate registration format
      if (!isValidRegistration(registration)) {
        return 'Invalid registration number format.';
      }
      // Validate enrollment format
      if (!isValidEnrollment(enrollment)) {
        return 'Invalid enrollment number format.';
      }

      // Check if the username is already taken
      bool isUsernameTaken = await isFieldAlreadyExists('Username', username);
      if (isUsernameTaken) {
        return 'Username is already taken';
      }

      // Check if the email is already taken
      bool isEmailTaken = await isFieldAlreadyExists('Email', email);
      if (isEmailTaken) {
        return 'Email is already taken';
      }

      // Check if the registration number is already taken
      bool isRegistrationTaken =
          await isFieldAlreadyExists('Registration', registration);
      if (isRegistrationTaken) {
        return 'Registration number is already taken';
      }

      // Check if the enrollment number is already taken
      bool isEnrollmentTaken =
          await isFieldAlreadyExists('Enrollment', enrollment);
      if (isEnrollmentTaken) {
        return 'Enrollment number is already taken';
      }

      // If all checks pass, proceed with user registration
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          registration.isNotEmpty ||
          enrollment.isNotEmpty ||
          file != null) {
        // Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // Add user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          registration: registration,
          enrollment: enrollment,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "Success";
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  bool isValidUsername(String username) {
    // Define a regular expression pattern for valid usernames
    RegExp regex = RegExp(r'^[a-z0-9_.]+$');

    // Check if the username matches the pattern
    return regex.hasMatch(username);
  }

  bool isValidEmail(String email) {
    return email.toLowerCase().endsWith('@gmail.com');
  }

  bool isValidRegistration(String registration) {
    // Define a regular expression pattern for valid usernames
    RegExp regex = RegExp(r'^[A-Z][0-9]{2}[A-Z][0-9]{6}$');

    // Check if the username matches the pattern
    return regex.hasMatch(registration);
  }

  bool isValidEnrollment(String enrollment) {
    // Define a regular expression pattern for valid usernames
    RegExp regex = RegExp(r'^[0-9]{2}[A-Z]/[0-9]{5}$');

    // Check if the username matches the pattern
    return regex.hasMatch(enrollment);
  }

  Future<bool> isFieldAlreadyExists(String field, String value) async {
    // Check if the provided field value already exists in the database
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where(field, isEqualTo: value)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Logging In User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
