import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/screens/chat_screen/widgets/chat_messages.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final controller = TextEditingController();

  AppBar buildAppBar() => AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Column(
            children: [
              const Text(
                "Ali Raza",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Online",
                style: Styles.displayXSLightStyle,
              ),
            ],
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 60,
                child: AppTextField(
                  label: "Add Message",
                  keyboardType: TextInputType.text,
                  controller: controller,
                  validator: (data) {
                    return null;
                  },
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 320,
                  right: 0,
                  child: GestureDetector(
                    child: Text(
                      "Send",
                      style: Styles.displaySmNormalStyle
                          .copyWith(color: Colors.green),
                    ),
                    onTap: () {},
                  )),
            ],
          ),
        ));
  }
}
