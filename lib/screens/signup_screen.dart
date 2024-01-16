import 'dart:typed_data';

import 'package:campus_connect/resources/auth_methods.dart';
import 'package:campus_connect/screens/login_screen.dart';
import 'package:campus_connect/utils/colors.dart';
import 'package:campus_connect/utils/utils.dart';
import 'package:campus_connect/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _registrationController.dispose();
    _enrollmentController.dispose();
  }

  Future<Uint8List> getDefaultImage() async {
    ByteData data = await rootBundle.load('assets/DefaultProfile.png');
    return data.buffer.asUint8List();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // Set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    Uint8List defaultImage =
        await getDefaultImage(); // Implement a method to load the default image

    Uint8List selectedImage = _image ?? defaultImage;

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      registration: _registrationController.text,
      enrollment: _enrollmentController.text,
      file: selectedImage,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),

                // Logo SVG Image
                SvgPicture.asset(
                  'assets/CampusConnectLogo.svg',
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  height: 60,
                ),
                const SizedBox(
                  height: 15,
                ),
                // Upload Image as Profile
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          )
                        : CircleAvatar(
                            radius: 64,
                            child: Image.asset(
                              'assets/DefaultProfile.png', // Replace with your asset path
                              fit: BoxFit.cover,
                            ), // backgroundImage: NetworkImage(
                            //     'https://drive.google.com/file/d/1pmPxogWipvU79SvbdvBsiKycJGmoTFUt/view?usp=sharing'),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                    Positioned(
                      bottom: -8,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                // Username Input TextArea
                TextFieldInput(
                  hintText: 'Username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),

                const SizedBox(
                  height: 24,
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

                // Password Input TextArea
                TextFieldInput(
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),

                const SizedBox(
                  height: 24,
                ),

                // Bio Input TextArea
                TextFieldInput(
                  hintText: 'Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),

                const SizedBox(
                  height: 24,
                ),

                // Registration Number Input TextArea
                TextFieldInput(
                  hintText: 'Registration Number',
                  textInputType: TextInputType.text,
                  textEditingController: _registrationController,
                ),

                const SizedBox(
                  height: 24,
                ),

                // Enrollment Number Input TextArea
                TextFieldInput(
                  hintText: 'Enrollment Number',
                  textInputType: TextInputType.text,
                  textEditingController: _enrollmentController,
                  isPass: true,
                ),

                const SizedBox(
                  height: 24,
                ),

                // Sign Up Button
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Sign Up'),
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
    );
  }
}
