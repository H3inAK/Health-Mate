import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class HabitTrackerView extends StatefulWidget {
  const HabitTrackerView({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  State<HabitTrackerView> createState() => _HabitTrackerViewState();
}

class _HabitTrackerViewState extends State<HabitTrackerView> {
  late final Animation<Offset> _fastHalfAnimation;
  late final Animation<Offset> _secondHalfAnimation;
  late final Animation<Offset> _habitTrackerAnimation;
  late final Animation<Offset> _textAnimation;
  late final Animation<Offset> _imageAnimation;

  @override
  void initState() {
    _fastHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          splashView,
          habitTrackerView,
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
          habitTrackerView,
          bmiCalculatorView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _habitTrackerAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-2.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          habitTrackerView,
          bmiCalculatorView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-2.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          habitTrackerView,
          bmiCalculatorView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _imageAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-4.0, 0.0),
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        habitTrackerView,
        bmiCalculatorView,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _fastHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _habitTrackerAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "Track Your Habits",
                  style: GoogleFonts.alice(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _textAnimation,
              child: Padding(
                padding: const EdgeInsets.only(left: 64, right: 64),
                child: Text(
                  "Keep an eye on your daily habits and progress. Build good routines and break the bad ones.",
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
            ),
            SlideTransition(
              position: _imageAnimation,
              child: Container(
                padding: const EdgeInsets.only(top: 20.0),
                constraints: BoxConstraints(
                  maxWidth: Platform.isWindows ? 260 : 300,
                  maxHeight: Platform.isWindows ? 200 : 240,
                ),
                child: Image.asset("assets/images/track_habits.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
