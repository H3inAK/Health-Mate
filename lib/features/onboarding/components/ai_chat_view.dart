import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  late final Animation<Offset> _firstHalftAnimation;
  late final Animation<Offset> _secondHalfAnimation;
  late final Animation<Offset> _aiChatFirstHalfAnimation;
  late final Animation<Offset> _aiChatSecondHalfAnimation;
  late final Animation<Offset> _imageFirstHalfAnimation;
  late final Animation<Offset> _imageSecondHalfAnimation;

  @override
  void initState() {
    _firstHalftAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          weatherAdaptionView,
          aiChatView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _secondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 0.0),
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

    _aiChatFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          weatherAdaptionView,
          aiChatView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _aiChatSecondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-2.0, 0.0),
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

    _imageFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(4.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          weatherAdaptionView,
          aiChatView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _imageSecondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-4.0, 0.0),
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
      position: _firstHalftAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _imageFirstHalfAnimation,
              child: SlideTransition(
                position: _imageSecondHalfAnimation,
                child: Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  constraints: BoxConstraints(
                    maxWidth: Platform.isWindows ? 260 : 300,
                    maxHeight: Platform.isWindows ? 200 : 240,
                  ),
                  child: Image.asset("assets/images/ai_assistant2.png"),
                ),
              ),
            ),
            SlideTransition(
              position: _aiChatFirstHalfAnimation,
              child: SlideTransition(
                position: _aiChatSecondHalfAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    "AI Chat Assistant",
                    style: GoogleFonts.alice(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Ask our AI anything about health and wellness.\nGet instant answers and advice \nat your fingertips.",
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
          ],
        ),
      ),
    );
  }
}
