import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TopBackSkipView extends StatefulWidget {
  const TopBackSkipView({
    super.key,
    required this.animationController,
    required this.onBackClick,
    required this.onSkipClick,
  });

  final AnimationController animationController;
  final VoidCallback onBackClick;
  final VoidCallback onSkipClick;

  @override
  State<TopBackSkipView> createState() => _TopBackSkipViewState();
}

class _TopBackSkipViewState extends State<TopBackSkipView> {
  late final Animation<Offset> _moveDownAnimation;
  late final Animation<Offset> _skipButtonnAnimatin;

  @override
  void initState() {
    _moveDownAnimation = Tween<Offset>(
      begin: const Offset(0.0, -2.0),
      end: const Offset(0.0, 0.2),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _skipButtonnAnimatin = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(1.3, 0.0),
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
      position: _moveDownAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: widget.onBackClick,
              icon: const Icon(
                CupertinoIcons.back,
              ),
            ),
            SlideTransition(
              position: _skipButtonnAnimatin,
              child: TextButton(
                onPressed: widget.onSkipClick,
                child: const Text('Skip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
