import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  AppBar buildAppBar() => AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: const Row(
        children: [
          Column(
            children: [
              Text(
                "Ali Raza",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Online"),
            ],
          ),
        ],
      ));

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Center(
        child: Text("Centered Text"),
      ),
    );
  }
}
