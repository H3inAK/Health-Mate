import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/habit_model.dart';
import '../constants/app_assets.dart';

class HabitDetailPage extends StatefulWidget {
  final Habit habit;

  const HabitDetailPage({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitDetailPage> createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  late String _selectedIcon;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.habit.icon;
  }

  void _showIconSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: AppAssets.allTaskIcons.length,
            itemBuilder: (context, index) {
              final iconPath = AppAssets.allTaskIcons[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_tapCount == 0) {
                      _tapCount++;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _tapCount = 0;
                      });
                    } else if (_tapCount == 1) {
                      _tapCount = 0;
                      _selectedIcon = iconPath;
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedIcon == iconPath
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => _showIconSelectionSheet(context),
                  child: CircleAvatar(
                    radius: 100,
                    child: _selectedIcon.isNotEmpty
                        ? SvgPicture.asset(
                            _selectedIcon,
                            width: 100,
                            height: 100,
                          )
                        : Text(
                            widget.habit.title.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.habit.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Priority: ${widget.habit.priority}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Repeat: ${widget.habit.repeat}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                widget.habit.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
