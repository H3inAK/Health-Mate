import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/habit/habit_bloc.dart';
import '../constants/app_assets.dart';
import '../models/habit_model.dart';

class CreateHabitPage extends StatefulWidget {
  final Habit? habit;

  const CreateHabitPage({Key? key, this.habit}) : super(key: key);

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _priority = 'Low';
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _titleController.text = widget.habit!.title;
      _descriptionController.text = widget.habit!.description;
      _priority = widget.habit!.priority;
      _selectedIcon = widget.habit!.icon.isNotEmpty ? widget.habit!.icon : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.habit == null ? 'Create Habit' : 'Edit Habit'),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter habit title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.title),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Write down your note... (optional)',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      prefixIcon: Container(
                        transform: Matrix4.identity()
                          ..translate(0.0, -25.0, 0.0),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: const Icon(Icons.description),
                      ),
                      alignLabelWithHint: widget.habit == null ? true : false,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        // borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.priority_high),
                      // filled: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Icon',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: AppAssets.allTaskIcons.length,
                    itemBuilder: (context, index) {
                      final iconPath = AppAssets.allTaskIcons[index];
                      final isSelected = _selectedIcon == iconPath;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIcon = null;
                            } else {
                              _selectedIcon = iconPath;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            iconPath,
                            colorFilter: ColorFilter.mode(
                              isSelected ? Colors.white : Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 120,
                          vertical: 14,
                        ),
                      ),
                      onPressed: _saveHabit,
                      child: Text(
                        widget.habit == null ? 'Save Habit' : 'Update Habit',
                        style: TextStyle(
                          fontSize: 16.8,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: widget.habit?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        priority: _priority,
        icon: _selectedIcon ?? '',
        repeat: 'Daily',
        completed: widget.habit?.completed ?? false,
        createdAt: widget.habit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.habit == null) {
        context.read<HabitBloc>().add(AddHabit(newHabit));
      } else {
        context.read<HabitBloc>().add(UpdateHabit(newHabit));
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
