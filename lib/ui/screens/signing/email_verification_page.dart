// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:plants/authentification.dart';
// import 'package:plants/constants.dart';
// import 'package:plants/ui/screens/signin_page.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:plants/utils/custom_snackbar.dart';

// class EmailVerificationPage extends StatefulWidget {
//   final String email;

//   const EmailVerificationPage({Key? key, required this.email}) : super(key: key);

//   @override
//   State<EmailVerificationPage> createState() => _EmailVerificationPageState();
// }

// class _EmailVerificationPageState extends State<EmailVerificationPage> {
//   final AuthenticationService _authService = AuthenticationService();
//   Timer? _timer;
//   bool _isEmailVerified = false;
//   bool _canResendEmail = true;
//   int _resendTimeout = 60;

//   @override
//   void initState() {
//     super.initState();
//     _checkEmailVerification();
//   }

//   void _checkEmailVerification() {
//     _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
//       bool isVerified = await _authService.isEmailVerified();
//       if (isVerified) {
//         setState(() {
//           _isEmailVerified = true;
//         });
//         _timer?.cancel();
        
//         // Show success message and navigate
//         CustomSnackbar.showSuccess(message: "Email verified successfully!");
//         await Future.delayed(const Duration(seconds: 2));
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             PageTransition(
//               child: const SignIn(),
//               type: PageTransitionType.bottomToTop,
//             ),
//           );
//         }
//       }
//     });
//   }

//   Future<void> _resendVerificationEmail() async {
//     if (!_canResendEmail) return;

//     await _authService.sendEmailVerification();
//     setState(() {
//       _canResendEmail = false;
//     });

//     // Start countdown timer
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendTimeout > 0) {
//         setState(() {
//           _resendTimeout--;
//         });
//       } else {
//         setState(() {
//           _canResendEmail = true;
//           _resendTimeout = 60;
//         });
//         timer.cancel();
//       }
//     });

//     CustomSnackbar.showSuccess(message: "Verification email resent!");
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/email-verification.png',
//               height: 200,
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'Verify your email',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Constants.blackColor,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'We\'ve sent a verification email to:\n${widget.email}',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Constants.blackColor.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _canResendEmail ? _resendVerificationEmail : null,
//               style: ElevatedButton.styleFrom(
//                 primary: Constants.primaryColor,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 _canResendEmail
//                     ? 'Resend Email'
//                     : 'Resend in $_resendTimeout seconds',
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                     child: const SignIn(),
//                     type: PageTransitionType.bottomToTop,
//                   ),
//                 );
//               },
//               child: Text(
//                 'Back to Login',
//                 style: TextStyle(
//                   color: Constants.primaryColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }