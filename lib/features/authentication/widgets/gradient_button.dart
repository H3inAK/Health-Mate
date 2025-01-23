// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double width;
  final double height;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    width,
    height,
    borderRadius,
  })  : width = width ?? 300,
        height = height ?? 60,
        borderRadius = borderRadius ?? 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 2),
            spreadRadius: 1,
            blurRadius: 8,
            color: const Color.fromARGB(255, 255, 97, 147).withOpacity(0.7),
          )
        ],
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 240, 65, 124),
            Color.fromARGB(255, 232, 42, 105),
            Color.fromARGB(255, 220, 31, 94),
          ],
          // colors: [
          //   Color(0xFF7B61FF),
          //   Color(0xFF7B61FF),
          //   Color.fromARGB(255, 91, 73, 178),
          // ],
          stops: [0.3, 0.56, 1.0],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: MaterialButton(
        elevation: 12,
        // padding: const EdgeInsets.symmetric(
        //   vertical: 20.0,
        //   horizontal: 80.0,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
