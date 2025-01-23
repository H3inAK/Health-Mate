import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class BMICalculatorView extends StatefulWidget {
  const BMICalculatorView({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  State<BMICalculatorView> createState() => _BMICalculatorViewState();
}

class _BMICalculatorViewState extends State<BMICalculatorView> {
  late final Animation<Offset> _fastHalfAnimation;
  late final Animation<Offset> _secondHalfAnimation;
  late final Animation<Offset> _bmiFirstHalfAnimation;
  late final Animation<Offset> _bmiSecondHalfAnimation;
  late final Animation<Offset> _imageFirstHalfAnimation;
  late final Animation<Offset> _imageSecondHalfAnimation;

  @override
  void initState() {
    _fastHalfAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
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
    _secondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          bmiCalculatorView,
          weatherAdaptionView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _bmiFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(2, 0),
      end: const Offset(0, 0),
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
    _bmiSecondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-2.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          bmiCalculatorView,
          weatherAdaptionView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _imageFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(4, 0),
      end: const Offset(0, 0),
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
    _imageSecondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-4.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          bmiCalculatorView,
          weatherAdaptionView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

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
              position: _imageFirstHalfAnimation,
              child: SlideTransition(
                position: _imageSecondHalfAnimation,
                child: Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  constraints: BoxConstraints(
                    maxWidth: Platform.isWindows ? 260 : 300,
                    maxHeight: Platform.isWindows ? 200 : 240,
                  ),
                  child: Image.asset("assets/images/bmi.png"),
                ),
              ),
            ),
            SlideTransition(
              position: _bmiFirstHalfAnimation,
              child: SlideTransition(
                position: _bmiSecondHalfAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    "Calculate Your BMI",
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
              padding: const EdgeInsets.only(left: 64, right: 64),
              child: Text(
                "Monitor your Body Mass Index with ease. Get personalized insights to maintain a healthy weight.",
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
