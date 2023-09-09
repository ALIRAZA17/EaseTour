import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final myuser = auth.currentUser?.uid;
    return Scaffold(
      body: Center(
        child: Text(myuser ?? ""),
      ),
    );
  }
}
