import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Import the config file
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  Future<void> fetchMessage() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl'),
      ); // Use the config value

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          message = json.decode(response.body)[0];
        });
      } else {
        setState(() {
          message = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        message = "Failed to connect";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("FastAPI + Flutter")),
        body: Center(child: Text(message)),
      ),
    );
  }
}
