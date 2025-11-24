import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:plants/ui/screens/profile/sensor.dart';
import 'firebase_options.dart';
import 'ui/screens/signing/onboarding_screen.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Gemini.init(apiKey: "AIzaSyAjgNzZrAUeNvav1tU_dFDEVPImWXNjdkg");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboarding Screen',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
