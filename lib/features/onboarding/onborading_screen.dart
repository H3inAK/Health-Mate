import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'components/views.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/onboarding-screen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _animationController.addListener(() {});
    _animationController.animateTo(splashView);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (_animationController.value > splashView) {
            if (details.velocity.pixelsPerSecond.dx < 0) {
              _onNextButtonClick();
            } else if (details.velocity.pixelsPerSecond.dx > 0) {
              _onBackClick();
            }
          }
        },
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController,
            ),
            TopBackSkipView(
              animationController: _animationController,
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
            ),
            HabitTrackerView(
              animationController: _animationController,
            ),
            BMICalculatorView(
              animationController: _animationController,
            ),
            WeatherAdaptionView(
              animationController: _animationController,
            ),
            AIChatView(
              animationController: _animationController,
            ),
            WelcomeView(
              animationController: _animationController,
            ),
            NextButton(
              animationController: _animationController,
              onClick: _onNextButtonClick,
            ),
          ],
        ),
      ),
    );
  }

  void _onBackClick() {
    if (_animationController.value == habitTrackerView) {
      _animationController.animateTo(splashView);
    } else if (_animationController.value > habitTrackerView &&
        _animationController.value <= bmiCalculatorView) {
      _animationController.animateTo(habitTrackerView);
    } else if (_animationController.value > bmiCalculatorView &&
        _animationController.value <= weatherAdaptionView) {
      _animationController.animateTo(bmiCalculatorView);
    } else if (_animationController.value > weatherAdaptionView &&
        _animationController.value <= aiChatView) {
      _animationController.animateTo(weatherAdaptionView);
    } else if (_animationController.value > aiChatView &&
        _animationController.value <= welcomeView) {
      _animationController.animateTo(aiChatView);
    }
  }

  void _onSkipClick() {
    _animationController.animateTo(
      welcomeView,
      duration: const Duration(milliseconds: 350),
    );
  }

  void _onNextButtonClick() {
    if (_animationController.value == splashView) {
      _animationController.animateTo(habitTrackerView);
    } else if (_animationController.value > splashView &&
        _animationController.value <= habitTrackerView) {
      _animationController.animateTo(bmiCalculatorView);
    } else if (_animationController.value > habitTrackerView &&
        _animationController.value <= bmiCalculatorView) {
      _animationController.animateTo(weatherAdaptionView);
    } else if (_animationController.value > bmiCalculatorView &&
        _animationController.value <= weatherAdaptionView) {
      _animationController.animateTo(aiChatView);
    } else if (_animationController.value > weatherAdaptionView &&
        _animationController.value <= aiChatView) {
      _animationController.animateTo(welcomeView);
    }
  }
}
