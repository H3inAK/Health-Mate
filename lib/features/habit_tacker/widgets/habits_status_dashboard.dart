import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../database/habit_db.dart';
import '../models/habit_model.dart';

class HabitsStatusDashboard extends StatefulWidget {
  const HabitsStatusDashboard({super.key});

  @override
  State<HabitsStatusDashboard> createState() => _HabitsStatusDashboardState();
}

class _HabitsStatusDashboardState extends State<HabitsStatusDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[900]!,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 2,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                width: 75,
                height: 75,
                color: Colors.white,
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 70,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Habit>>(
      future: HabitDatabase.instance.readAllHabits(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmerEffect();
        }

        final habits = snapshot.data!;
        final total = habits.length;
        final completed = habits.where((h) => h.completed).toList().length;
        final active = total - completed;

        // Calculate the completion percentage
        final completionPercentage = total > 0 ? (completed / total) : 0.0;

        // if (total == 0) {
        //   return const SizedBox.shrink();
        // }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Card(
              elevation:
                  Theme.of(context).brightness == Brightness.light ? 0.5 : 1,
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: total == 0
                    ? const Text(
                        "No habits created yet\nCreate new one to see the status board",
                        style: TextStyle(fontSize: 18),
                      )
                    : Row(
                        children: [
                          CircularPercentIndicator(
                            radius: 38.6,
                            lineWidth: 8.0,
                            percent: completionPercentage,
                            center: Text(
                              "${(completionPercentage * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            progressColor:
                                Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  completed == 0
                                      ? "Nothing just completed yet"
                                      : "$completed/$total Completed Today",
                                  style: completed == 0
                                      ? const TextStyle(fontSize: 15)
                                      : Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  active == 0
                                      ? "Congratulations 🎉🎉🎉\nYou've completed all"
                                      : active == 1
                                          ? "Only one habit is left \nLet's do it! 🔥🔥🔥"
                                          : "$active habits left to have done\nKeep it up! 🔥🔥🔥",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
