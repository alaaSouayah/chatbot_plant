import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chaatbot_detection/models/user.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if the code exists in Firestore

  // Check if the code exists in Firestore
  // Future<bool> checkCode(String sensorId) async {
  //   QuerySnapshot querySnapshot = await _firestore
  //       .collection('sensors')
  //       .where('sensorId', isEqualTo: sensorId)
  //       .where('isUsed', isEqualTo: false)
  //       .get();
  //   return querySnapshot.docs.isNotEmpty;
  // }

  // Sign in user
  Future<String?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        return "Please verify your email before signing in.";
      }

      // Update emailVerified status in Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({'emailVerified': true});

      return "User signed in successfully!";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  // Sign out user
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user data from Firestore
  Future<Users?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return Users(
          email: doc['email'],
          fullName: doc['fullName'],
          password: doc['password'],
          role: doc['role'] ?? 'user',
          // sensorIds: List<String>.from(doc['sensorIds'] ?? []),
          imageUrl: doc['profilePic'] ?? 'assets/images/default.jpg',
        );
      }
    }
    return null;
  }

  // Extra signup method (not really needed if you already have registerUser)
  Future<String?> signUpUser(
      String email, String password, String fullName) async {
    try {
      // Check if sensorId is empty
      // if (sensorId.trim().isEmpty) {
      //   return "Error: Sensor ID is required.";
      // }

      // // Check if the sensor ID exists and is not used
      // bool isCodeValid = await checkCode(sensorId);
      // if (!isCodeValid) {
      //   return "Error: Invalid or already used sensor ID.";
      // }

      // Create the user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Create user with the provided sensorId
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'password': password,
        'role': 'user',
        // 'sensorIds': [sensorId],
        'profilePic': 'assets/images/default.jpg',
        'emailVerified': false,
      });

      // Update the sensor document
      // QuerySnapshot sensorQuery = await _firestore
      //     .collection('sensors')
      //     .where('sensorId', isEqualTo: sensorId)
      //     .get();

      // if (sensorQuery.docs.isNotEmpty) {
      //   await _firestore
      //       .collection('sensors')
      //       .doc(sensorQuery.docs.first.id)
      //       .update({
      //     'isUsed': true,
      //     'userId': userCredential.user!.uid,
      //   });
      // }

      return "User registered successfully! Please check your email for verification.";
    } catch (e) {
      print("Error during sign up: $e");
      return "Error: ${e.toString()}";
    }
  }

  // Add a method to check email verification status
  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  // Add reset password method
  // Future<String?> resetPassword(String email) async {
  //   try {
  //     // Validate if email exists in Firebase Auth
  //     var methods = await _auth.fetchSignInMethodsForEmail(email);
  //     if (methods.isEmpty) {
  //       return "No account found with this email address.";
  //     }

  // Send password reset email
  //   await _auth.sendPasswordResetEmail(email: email);
  //   return "success";
  // } on FirebaseAuthException catch (e) {
  //   switch (e.code) {
  //     case 'invalid-email':
  //       return "Invalid email address format.";
  //     case 'user-not-found':
  //       return "No account found with this email address.";
  //     default:
  //       return "An error occurred. Please try again later.";
  //   }
  // } catch (e) {
  //   return "An unexpected error occurred.";
  // }
}

