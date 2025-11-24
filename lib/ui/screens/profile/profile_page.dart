import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chaatbot_detection/utils/constants.dart';
import 'package:chaatbot_detection/ui/screens/signing/signin_page.dart';
import 'package:chaatbot_detection/ui/screens/widgets/profile_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'terms_page.dart'; // <- create this

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        fullName = doc.data()?['fullName'] ?? 'Unknown';
        email = user.email ?? '';
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  void shareApp() {
    Share.share('Check out this awesome plant app! 🌱');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile photo
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: ExactAssetImage('assets/images/profile.jpg'),
                ),
              ),

              const SizedBox(height: 10),

              // Name + Verified
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 24,
                    child: Image.asset("assets/images/verified.png"),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Email
              Text(
                email,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // Options
              SizedBox(
                height: size.height * .6,
                width: size.width,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const TermsPage(),
                        ));
                      },
                      child: const ProfileWidget(
                        icon: Icons.help_outline,
                        title: 'FAQs / Terms of Use',
                      ),
                    ),
                    GestureDetector(
                      onTap: shareApp,
                      child: const ProfileWidget(
                        icon: Icons.share,
                        title: 'Share',
                      ),
                    ),
                   
                
                    // GestureDetector(
                    //   onTap: () async {
                    //     final uid = FirebaseAuth.instance.currentUser?.uid;
                    //     if (uid == null) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //             content: Text('Please sign in first')),
                    //       );
                    //       return;
                    //     }

                    //     final qs = await FirebaseFirestore.instance
                    //         .collection('sensors')
                    //         .where('userId', isEqualTo: uid)
                    //         .where('isUsed', isEqualTo: true)
                    //         .limit(1)
                    //         .get(); // one-shot fetch for a docId [web:100]

                    //     if (qs.docs.isEmpty) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //             content:
                    //                 Text('No sensors linked to your account')),
                    //       );
                    //       return;
                    //     }

                        
                    //   },
                   
                    // ),

                    
                    GestureDetector(
                      onTap: logout,
                      child: const ProfileWidget(
                        icon: Icons.logout,
                        title: 'Log Out',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
