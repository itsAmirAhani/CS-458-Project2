// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import '../components/google_login.dart';
import '../components/normal_login.dart';
import 'success_page.dart'; // Import the SuccessPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  void navigateToSuccessPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalLogin(loading: loading, onSuccess: navigateToSuccessPage),
            SizedBox(height: 20),
            GoogleLoginComponent(
              onSuccess: navigateToSuccessPage,
            ), // Pass the callback here
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
