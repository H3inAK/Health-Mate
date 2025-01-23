import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

import '../../habit_tacker/database/habit_db.dart';
import '../../habit_tacker/models/habit_model.dart';
import '../cubits/habit_challenages/habit_challenages_cubit.dart';

class GoodHabitsChallenagesPage extends StatefulWidget {
  final HabitDatabase habitDatabase = HabitDatabase.instance;

  GoodHabitsChallenagesPage({super.key});

  @override
  State<GoodHabitsChallenagesPage> createState() =>
      _GoodHabitsChallenagesPageState();
}

class _GoodHabitsChallenagesPageState extends State<GoodHabitsChallenagesPage> {
  late final ScrollController _scrollController;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // User is scrolling up, hide the FAB
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // User is scrolling down, show the FAB
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Today Challenges'),
          centerTitle: true,
        ),
        body: BlocBuilder<HabitChallenagesCubit, HabitChallenagesState>(
          builder: (context, state) {
            if (state.status == HabitChallenagesStatus.loading) {
              // Show shimmer effect while loading
              return ListView.builder(
                controller: _scrollController,
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[300]!
                        : Colors.grey[900]!,
                    highlightColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[100]!
                            : Colors.grey[800]!,
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                      ),
                      title: Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == HabitChallenagesStatus.loaded) {
              final habits = state.habits;

              return AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 240),
                      child: SlideAnimation(
                        horizontalOffset: 14.0,
                        child: FadeInAnimation(
                          child: _buildHabitItem(context, habit),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state.status == HabitChallenagesStatus.error) {
              return const Center(child: Text('Error loading habits'));
            } else {
              return const Center(child: Text('No habits found.'));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isFabVisible
            ? FloatingActionButton.extended(
                onPressed: () => _importAllHabits(context),
                label: const Text('Take All Challenges'),
                icon: const Icon(Icons.add_task),
              )
            : null,
      ),
    );
  }

  Widget _buildHabitItem(BuildContext context, Habit habit) {
    return ListTile(
      leading: CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        child: Text(
          habit.icon,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      title: Text(habit.title),
      subtitle: Text(habit.description),
      trailing: IconButton(
        icon: const Icon(Icons.swap_horiz),
        onPressed: () => _importHabit(context, habit),
      ),
    );
  }

  Future<void> _importHabit(BuildContext context, Habit habit) async {
    final existingHabits = await widget.habitDatabase.readAllHabits();
    final habitExists = existingHabits.any((h) => h.title == habit.title);

    if (habitExists) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Habit "${habit.title}" already exists!')),
      );
      return;
    }

    await widget.habitDatabase.create(habit);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).clearSnackBars();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit imported successfully!')),
    );
  }

  Future<void> _importAllHabits(BuildContext context) async {
    final state = context.read<HabitChallenagesCubit>().state;
    final habits = state.habits;

    final existingHabits = await widget.habitDatabase.readAllHabits();
    final existingTitles = existingHabits.map((h) => h.title).toSet();

    for (final habit in habits) {
      if (!existingTitles.contains(habit.title)) {
        await widget.habitDatabase.create(habit);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit "${habit.title}" already exists!')),
        );
      }
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).clearSnackBars();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('All non-existing habits imported successfully!')),
    );
  }
}
