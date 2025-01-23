import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late final Animation<Offset> _slideAnimation;
  late final Animation<Offset> _aiChatAnimation;
  late final Animation<Offset> _imageAnimation;

  @override
  void initState() {
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          aiChatView,
          welcomeView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _aiChatAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          aiChatView,
          welcomeView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _imageAnimation = Tween<Offset>(
      begin: const Offset(4.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          aiChatView,
          welcomeView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _aiChatAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "Welcome to\nHealthmate",
                style: GoogleFonts.alice(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 64, right: 64),
            child: Text(
              "Your companion in health and wellness. Let's start making positive changes together!",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white70,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SlideTransition(
            position: _imageAnimation,
            child: Container(
              padding: const EdgeInsets.only(top: 16.0),
              constraints: BoxConstraints(
                maxWidth: Platform.isWindows ? 260 : 300,
                maxHeight: Platform.isWindows ? 200 : 240,
              ),
              child: Image.asset("assets/images/welcome.png"),
            ),
          ),
        ],
      ),
    );
  }
}
