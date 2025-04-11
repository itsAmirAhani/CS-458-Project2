import 'package:flutter/material.dart';
import '../components/google_login.dart';
import '../components/normal_login.dart';
import 'survey_page.dart'; 
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  void navigateToSurveyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SurveyPage()),
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
            NormalLogin(loading: loading, onSuccess: navigateToSurveyPage),
            SizedBox(height: 20),
            GoogleLoginComponent(onSuccess: navigateToSurveyPage),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
