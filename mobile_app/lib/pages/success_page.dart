// lib/pages/success_page.dart

import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Success")),
      body: Center(
        child: Text("Login Successful!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
