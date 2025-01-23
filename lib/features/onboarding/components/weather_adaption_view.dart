import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class WeatherAdaptionView extends StatefulWidget {
  const WeatherAdaptionView({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  State<WeatherAdaptionView> createState() => _WeatherAdaptionViewState();
}

class _WeatherAdaptionViewState extends State<WeatherAdaptionView> {
  late final Animation<Offset> _firstHalfAnimation;
  late final Animation<Offset> _secondHalfAnimation;
  late final Animation<Offset> _weatherAdaptionFirstHalfAnimation;
  late final Animation<Offset> _weatherAdaptionSecondHalfAnimation;
  late final Animation<Offset> _imageFirstHalfAnimation;
  late final Animation<Offset> _imageSecondHalfAnimation;

  @override
  void initState() {
    _firstHalfAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
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
    _secondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 0.0),
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

    _weatherAdaptionFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: const Offset(0.0, 0.0),
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
    _weatherAdaptionSecondHalfAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-2.0, 0.0),
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

    _imageFirstHalfAnimation = Tween<Offset>(
      begin: const Offset(4.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          bmiCalculatorView,
          weatherAdaptionView,
          curve: Curves.fastOutSlowIn, //
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
          weatherAdaptionView,
          aiChatView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _weatherAdaptionFirstHalfAnimation,
              child: SlideTransition(
                position: _weatherAdaptionSecondHalfAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    "Personalized Tips \nBased on Weather",
                    style: GoogleFonts.alice(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64, right: 64),
              child: Text(
                "Receive health tips tailored to the current weather. \nStay healthy and comfortable, whatever the forecast.",
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
              position: _imageFirstHalfAnimation,
              child: SlideTransition(
                position: _imageSecondHalfAnimation,
                child: Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  constraints: BoxConstraints(
                    maxWidth: Platform.isWindows ? 260 : 300,
                    maxHeight: Platform.isWindows ? 200 : 240,
                  ),
                  child: Image.asset("assets/images/well_being.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
