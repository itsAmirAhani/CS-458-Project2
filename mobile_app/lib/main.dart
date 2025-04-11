import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Import the LoginPage
import 'pages/survey_page.dart'; // Import the SurveyPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastAPI + Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Set the LoginPage as the home
      routes: {
        '/survey': (context) => SurveyPage(), // Updated to SurveyPage
      },
    );
  }
}
