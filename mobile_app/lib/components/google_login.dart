// lib/components/google_login.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GoogleLoginComponent extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final VoidCallback onSuccess;

  GoogleLoginComponent({super.key, required this.onSuccess});

  Future<void> handleGoogleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser  = await _googleSignIn.signIn();
      if (googleUser  != null) {
        Fluttertoast.showToast(
          msg: "✅ Welcome, ${googleUser .displayName}!",
          toastLength: Toast.LENGTH_SHORT,
        );
        onSuccess();
      } else {
        Fluttertoast.showToast(
          msg: "❌ Google Login Failed: No credential received.",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      Fluttertoast.showToast(
        msg: "❌ Google Login Failed: $error",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handleGoogleLogin(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, // Text color
        backgroundColor: Colors.white, // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          side: BorderSide(color: Colors.grey.shade300), // Border color
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0), // Padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using a simple text instead of an image
          Text(
            "Login with Google",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}