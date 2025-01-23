import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/habit/habit_bloc.dart';

class ToggleButtonWidget extends StatefulWidget {
  const ToggleButtonWidget({super.key});

  @override
  State<ToggleButtonWidget> createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  List<String> options = ['All', 'Active', 'Done'];
  FilterOptions filterOptions = FilterOptions.all;

  String current = 'All';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          AppinioAnimatedToggleTab(
            callback: (int i) {
              setState(() {
                current = options[i];
                if (current == 'All') {
                  filterOptions = FilterOptions.all;
                } else if (current == 'Active') {
                  filterOptions = FilterOptions.active;
                } else if (current == 'Done') {
                  filterOptions = FilterOptions.completed;
                }
              });

              context.read<HabitBloc>().add(FilterHabits(filterOptions));
            },
            tabTexts: options,
            height: 50,
            width: 250,
            duration: const Duration(milliseconds: 200),
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            animatedBoxDecoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.5),
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            activeStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15.4,
            ),
            inactiveStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(Icons.sort_rounded),
          ),
        ],
      ),
    );
  }
}
