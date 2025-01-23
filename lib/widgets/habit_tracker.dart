import 'package:flutter/material.dart';

import '../features/bmi_calculator/utils/widget_utils.dart';

class TrackHabitsWidget extends StatelessWidget {
  const TrackHabitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(
          screenAwareSize(16.0, context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border(
                      top: BorderSide(width: 10),
                      left: BorderSide(width: 10),
                      right: BorderSide(width: 10),
                      bottom: BorderSide(width: 10),
                    ),
                  ),
                  child: Text(
                    "80%",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "5/7 of habits completed today",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Track Habits",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
