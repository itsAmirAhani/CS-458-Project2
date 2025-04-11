// lib/components/normal_login.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Import the config file

class NormalLogin extends StatefulWidget {
  final bool loading;
  final VoidCallback onSuccess; // Add a callback for successful login

  const NormalLogin({
    super.key,
    required this.loading,
    required this.onSuccess,
  });

  @override
  _NormalLoginState createState() => _NormalLoginState();
}

class _NormalLoginState extends State<NormalLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> handleSubmit() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Call the login function and show toast based on the result
    try {
      await login(email, password); // Call the login function directly
      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
      );
      widget.onSuccess(); // Call the onSuccess callback to navigate
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login'); // Use the base URL from config

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Response status: ${response.statusCode}'); // Debugging line
    print('Response body: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      // Handle successful login
      final responseData = json.decode(response.body);
      return responseData; // Return any data if needed
    } else {
      // Handle error response
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Login",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            key: Key('email_field'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            obscureText: true,
            key: Key('password_field'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                widget.loading
                    ? null
                    : () async {
                      await handleSubmit(); // Call handleSubmit directly
                    },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ), // Button color
            ),
            child: Text(
              widget.loading ? "Logging in..." : "Login",
              style: TextStyle(fontSize: 16),
            ),
            key: Key('login_button'),
          ),
        ],
      ),
    );
  }
}
