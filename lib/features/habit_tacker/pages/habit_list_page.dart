import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../blocs/habit/habit_bloc.dart';
import '../models/habit_model.dart';
import '../widgets/habit_widget.dart';
import 'create_habit_page.dart';

class HabitListsPage extends StatefulWidget {
  const HabitListsPage({Key? key}) : super(key: key);

  @override
  State<HabitListsPage> createState() => _HabitListsPageState();
}

class _HabitListsPageState extends State<HabitListsPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHabitsForSelectedDate();
  }

  void _loadHabitsForSelectedDate() {
    context.read<HabitBloc>().add(LoadHabits(selectedDate: _selectedDate));
    BlocProvider.of<HabitBloc>(context).add(
      const SortHabits(SortOptions.date),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return child!;
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _loadHabitsForSelectedDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Habits'),
            actions: [
              Row(
                children: [
                  Text(_formatDate(_selectedDate)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(width: 2),
              const SortHabitsWidget(),
              const SizedBox(width: 4),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SegmentedTabControl(
                  height: 50,
                  barDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  indicatorDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  tabTextColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  selectedTabTextColor: Theme.of(context).colorScheme.onPrimary,
                  tabs: const [
                    SegmentTab(label: 'All Habits'),
                    SegmentTab(label: 'Completed'),
                    SegmentTab(label: 'Incomplete'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: TabBarView(
                  children: [
                    _buildHabitList(),
                    _buildHabitList(filter: true),
                    _buildHabitList(filter: false),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateHabitPage(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitList({bool? filter}) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state.status == HabitStatus.loading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(60.0),
              child: LinearProgressIndicator(),
            ),
          );
        } else if (state.status == HabitStatus.failure) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final habits = state.habits.where((habit) {
          if (filter == null) return true;
          return filter ? habit.completed : !habit.completed;
        }).toList();

        if (habits.isEmpty) {
          return Center(
            child: Text(
              filter == true
                  ? 'Nothing have done yet! 😥😥😥'
                  : filter == false
                      ? 'Congrations! 🎉🎉🎉\nAll habits are completed.'
                      : 'No habits found.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          );
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 350),
                child: SlideAnimation(
                  horizontalOffset: 16.0,
                  child: FadeInAnimation(
                    child: Slidable(
                      key: ValueKey(habit.id),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) =>
                                _showEditHabitDialog(context, habit),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) =>
                                _showDeleteHabitDialog(context, habit),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) =>
                                _markHabitCompleted(context, habit),
                            backgroundColor: habit.completed
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.primary,
                            foregroundColor: habit.completed
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            icon: Icons.check,
                            label: habit.completed ? 'Incomplete' : 'Complete',
                          ),
                        ],
                      ),
                      child: HabitWidget(habit: habit),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteHabitDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: const Text('Are you sure you want to delete this habit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                context.read<HabitBloc>().add(DeleteHabit(habit));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Habit deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateHabitPage(habit: habit),
      ),
    );
  }

  void _markHabitCompleted(BuildContext context, Habit habit) {
    context.read<HabitBloc>().add(
        UpdateCompletedStatus(habit.copyWith(completed: !habit.completed)));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(habit.completed
            ? 'Habit marked as incomplete'
            : 'Habit marked as complete'),
      ),
    );
  }
}

class SortHabitsWidget extends StatelessWidget {
  const SortHabitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOptions>(
      icon: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.sort),
      ),
      onSelected: (SortOptions sortType) {
        BlocProvider.of<HabitBloc>(context).add(
          SortHabits(sortType),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOptions>>[
        const PopupMenuItem<SortOptions>(
          value: SortOptions.date,
          child: Text('By Date'),
        ),
        const PopupMenuItem<SortOptions>(
          value: SortOptions.priority,
          child: Text('By Priority'),
        ),
        const PopupMenuItem<SortOptions>(
          value: SortOptions.completed,
          child: Text('By Completion'),
        ),
        const PopupMenuItem<SortOptions>(
          value: SortOptions.alphabetical,
          child: Text('By Alphabetical'),
        ),
      ],
    );
  }
}
