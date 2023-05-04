import 'package:flutter/material.dart';

class CirclePhoto extends StatelessWidget {
  final String imageUrl;
  final double radius;

  CirclePhoto({
    required this.imageUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}
