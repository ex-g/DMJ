import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  // Future<UserCredential?> signInWithGoogle() async {
  //   // Create a new provider
  //   GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //   googleProvider
  //       .addScope('https://www.googleapis.com/auth/contacts.readonly');
  //   googleProvider.addScope("https://www.googleapis.com/auth/calendar");
  //   googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  //   // Once signed in, return the UserCredential
  //   UserCredential user =
  //       await FirebaseAuth.instance.signInWithPopup(googleProvider);

  //   if (user == false) {
  //     return null;
  //   }

  //   collectionReference.doc(user.user?.uid).set({
  //     "username": "${user.user?.displayName}",
  //     "id": user.user?.uid,
  //     "money": 0,
  //     "basicTurn": 1
  //   });

  //   return user;
  //   // Or use signInWithRedirect
  //   // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  // }

  // Android & IOS
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signInSilently();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: signInWithGoogle, child: const Text("구글로 회원가입")),
      ),
    );
  }
}
