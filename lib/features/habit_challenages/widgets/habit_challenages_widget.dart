import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/habit_challenages/habit_challenages_cubit.dart';
import '../pages/good_habits_challenages_page.dart';

class HabitChallenagesWidget extends StatefulWidget {
  const HabitChallenagesWidget({super.key});

  @override
  State<HabitChallenagesWidget> createState() => _HabitChallenagesWidgetState();
}

class _HabitChallenagesWidgetState extends State<HabitChallenagesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _hoverAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();

    Future.delayed(Duration.zero).then((_) {
      context.read<HabitChallenagesCubit>().getHabits();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // void _onButtonTapDown(TapDownDetails details) {
  //   _animationController.forward();
  // }

  // void _onButtonTapUp(TapUpDetails details) {
  //   _animationController.reverse();
  // }

  // void _onButtonTapCancel() {
  //   _animationController.reverse();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _hoverAnimation,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => GoodHabitsChallenagesPage(),
                    ),
                  );
                },
                // onTapDown: _onButtonTapDown,
                // onTapUp: _onButtonTapUp,
                // onTapCancel: _onButtonTapCancel,
                child: Card(
                  elevation: Theme.of(context).brightness == Brightness.light
                      ? 0.5
                      : 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Today Challenges',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        GoodHabitsChallenagesPage(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '  Check',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ],
                    ),
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
