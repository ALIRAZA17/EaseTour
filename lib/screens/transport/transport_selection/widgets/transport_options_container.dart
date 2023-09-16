import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:flutter/material.dart';

class TransportOptionsContainer extends StatelessWidget {
  const TransportOptionsContainer({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Styles.backgroundGrayColor,
          border: Border.all(
            color: Styles.primaryColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 26),
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/images/$image'),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  title,
                  style: Styles.displaySmNormalStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
