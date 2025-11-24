import 'package:chaatbot_detection/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:chaatbot_detection/ui/screens/signing/authentification.dart';
import 'package:chaatbot_detection/utils/constants.dart';
import 'package:chaatbot_detection/ui/screens/signing/forgot_password.dart';
import 'package:chaatbot_detection/ui/screens/rootage/root_page2.dart';
import 'package:chaatbot_detection/ui/screens/signing/signup_page.dart';
import 'package:chaatbot_detection/ui/screens/widgets/custom_textfield.dart';
import 'package:page_transition/page_transition.dart';
import 'package:chaatbot_detection/models/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _codeController = TextEditingController();

  final AuthenticationService _authService =
      AuthenticationService(); // Use AuthenticationService

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _signInUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Sign in the user using AuthenticationService
    String? response = await _authService.signInUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      // _codeController.text.trim(),
    );

    if (response == "User signed in successfully!") {
      Users? userData = await _authService.getUserData();

      if (userData != null) {
        void showSuccessSnackbar(BuildContext context, String message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Navigate based on user role
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: userData.role == 'user' ? const MyApp() : const RootPage2(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'User data not found.';

          void showErrorSnackbar(BuildContext context, String message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    } else {
      setState(() {
        _errorMessage = response ?? 'An unexpected error occurred.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

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
              Image.asset('assets/images/signin.png'),
              const Text(
                'Sign In',
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

              // Password input
              CustomTextfield(
                controller: _passwordController,
                obscureText: true,
                hintText: 'Enter Password',
                icon: Icons.lock,
              ),

              const SizedBox(height: 10),

              // Sign-in button
              GestureDetector(
                onTap: _signInUser,
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
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Forgot Password
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const ForgotPassword(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Forgot Password? ',
                        style: TextStyle(color: Constants.blackColor),
                      ),
                      TextSpan(
                        text: 'Reset Here',
                        style: TextStyle(color: Constants.primaryColor),
                      ),
                    ]),
                  ),
                ),
              ),

              const SizedBox(height: 80),

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

              // Register button
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const SignUp(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'New to Planty? ',
                        style: TextStyle(color: Constants.blackColor),
                      ),
                      TextSpan(
                        text: 'Register',
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
