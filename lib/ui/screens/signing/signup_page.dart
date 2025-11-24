import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:chaatbot_detection/ui/screens/signing/authentification.dart';
import 'package:chaatbot_detection/utils/constants.dart';
import 'package:chaatbot_detection/ui/screens/widgets/custom_textfield.dart';
import 'package:chaatbot_detection/ui/screens/signing/signin_page.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _codeController = TextEditingController();

  final AuthenticationService _authService =
      AuthenticationService(); // Use AuthenticationService

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _registerUser() async {
    // Validate all fields
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _fullNameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'All fields need it.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String? response = await _authService.signUpUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _fullNameController.text.trim(),
      // _codeController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (response!.contains("successfully")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          backgroundColor: Colors.green,
        ),
      );

      // Wait for a moment before navigating
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        PageTransition(
          child: const SignIn(),
          type: PageTransitionType.bottomToTop,
        ),
      );
    } else {
      setState(() {
        _errorMessage = response;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> _registerUser() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = '';
  //   });

  //   // Sign up the user using AuthenticationService
  //   String? response = await _authService.signUpUser(
  //     _emailController.text.trim(),
  //     _passwordController.text.trim(),
  //     _fullNameController.text.trim(),
  //     _codeController.text.trim(),
  //   );

  //   if (response == "User registered successfully!") {
  //     // Navigate to SignIn Page
  //     Navigator.pushReplacement(
  //       context,
  //       PageTransition(
  //         child: const SignIn(),
  //         type: PageTransitionType.bottomToTop,
  //       ),
  //     );
  //   } else {
  //     setState(() {
  //       _errorMessage = response ?? 'An unexpected error occurred.';
  //     });
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/signup.png'),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),

              // Email input
              CustomTextfield(
                controller: _emailController,
                obscureText: false,
                hintText: 'Enter Email',
                icon: Icons.alternate_email,
              ),

              // Full Name input
              CustomTextfield(
                controller: _fullNameController,
                obscureText: false,
                hintText: 'Enter Full Name',
                icon: Icons.person,
              ),

              // Password input
              CustomTextfield(
                controller: _passwordController,
                obscureText: true,
                hintText: 'Enter Password',
                icon: Icons.lock,
              ),
              // Password input
              // CustomTextfield(
              //   controller: _codeController,
              //   obscureText: false,
              //   hintText: 'Enter code',
              //   icon: Icons.code,
              // ),

              const SizedBox(height: 10),

              // Sign Up button
              GestureDetector(
                onTap: _registerUser,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // OR Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // Login button
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: const SignIn(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Have an Account? ',
                        style: TextStyle(color: Constants.blackColor),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: Constants.primaryColor),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
