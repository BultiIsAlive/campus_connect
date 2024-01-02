import 'package:campus_connect/resources/auth_methods.dart';
import 'package:campus_connect/responsive/mobile_screen_layout.dart';
import 'package:campus_connect/responsive/responsive_layout_screen.dart';
import 'package:campus_connect/responsive/web_screen_layout.dart';
import 'package:campus_connect/screens/signup_screen.dart';
import 'package:campus_connect/utils/colors.dart';
import 'package:campus_connect/utils/global_variables.dart';
import 'package:campus_connect/utils/utils.dart';
import 'package:campus_connect/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  // Login Button
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Log In'),
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

                  // SignUp Transition
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Don't have an account? "),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                          child: const Text(
                            "Sign Up",
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
