import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/individual_habit/individual_habit_bloc.dart';
import '../models/habit_model.dart';

class HabitWidget extends StatefulWidget {
  final Habit habit;

  const HabitWidget({
    Key? key,
    required this.habit,
  }) : super(key: key);

  @override
  State<HabitWidget> createState() => _HabitWidgetState();
}

class _HabitWidgetState extends State<HabitWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.deepOrange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getDescriptionBackgroundColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.orange.withOpacity(0.2);
      case 'medium':
        return Colors.yellow.withOpacity(0.2);
      case 'low':
        return Colors.green.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualHabitBloc, IndividualHabitState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _toggleExpand,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Card(
              color: widget.habit.completed
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: widget.habit.icon.isNotEmpty
                          ? widget.habit.icon.startsWith('assets')
                              ? SvgPicture.asset(
                                  widget.habit.icon,
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Text(
                                  widget.habit.icon,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                          : Text(
                              widget.habit.title.substring(0, 1),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    title: Text(
                      widget.habit.title,
                      style: TextStyle(
                        decoration: widget.habit.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getPriorityColor(widget.habit.priority),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.habit.priority,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    axisAlignment: -1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getDescriptionBackgroundColor(
                            widget.habit.priority),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: widget.habit.description.isEmpty
                          ? null
                          : Text(
                              widget.habit.description,
                              style: const TextStyle(fontSize: 14),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
