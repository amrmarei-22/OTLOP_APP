import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final String title;
  final String price;

  const RowWidget({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
        ),
        Spacer(),
        Text(
          price,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
