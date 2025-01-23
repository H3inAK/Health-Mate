import 'package:flutter/material.dart';

import '../constants.dart';

class DotDatPageView extends StatelessWidget {
  const DotDatPageView({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        int selectedIndex = 0;

        if (animationController.value >= 0.9) {
          selectedIndex = 4;
        } else if (animationController.value >= 0.7) {
          selectedIndex = 3;
        } else if (animationController.value >= 0.5) {
          selectedIndex = 2;
        } else if (animationController.value >= 0.3) {
          selectedIndex = 1;
        } else if (animationController.value >= 0.1) {
          selectedIndex = 0;
        }

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: animationController.value >= habitTrackerView &&
                  animationController.value <= aiChatView
              ? 1.0
              : 0.0,
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 1.4),
                  padding: EdgeInsets.symmetric(
                      horizontal: selectedIndex == index ? 10.0 : 5.0),
                  // width: selectedIndex == index ? 20.0 : 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(10),
                    color: selectedIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
