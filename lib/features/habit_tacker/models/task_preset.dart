import '../constants/app_assets.dart';

class HabitPreset {
  const HabitPreset({required this.name, required this.iconName});
  final String name;
  final String iconName;

  @override
  String toString() => 'HabitPreset($name, $iconName)';

  static const List<HabitPreset> allPresets = [
    HabitPreset(name: 'Eat a Healthy Meal', iconName: AppAssets.carrot),
    HabitPreset(name: 'Walk the Dog', iconName: AppAssets.dog),
    HabitPreset(name: 'Do Some Coding', iconName: AppAssets.html),
    HabitPreset(name: 'Meditate', iconName: AppAssets.meditation),
    HabitPreset(name: 'Do 10 Pushups', iconName: AppAssets.pushups),
    HabitPreset(name: 'Sleep 8 Hours', iconName: AppAssets.rest),
    HabitPreset(name: 'Take Vitamins', iconName: AppAssets.vitamins),
    HabitPreset(name: 'Cycle to Work', iconName: AppAssets.bike),
    HabitPreset(name: 'Wash Your Hands', iconName: AppAssets.washHands),
    HabitPreset(name: 'Wear a Mask', iconName: AppAssets.mask),
    HabitPreset(name: 'Brush Your Teeth', iconName: AppAssets.toothbrush),
    HabitPreset(name: 'Floss Your Teeth', iconName: AppAssets.dentalFloss),
    HabitPreset(name: 'Drink Water', iconName: AppAssets.water),
    HabitPreset(name: 'Practice Instrument', iconName: AppAssets.guitar),
    HabitPreset(name: 'Read for 10 Minutes', iconName: AppAssets.book),
    HabitPreset(name: 'Don\'t Smoke', iconName: AppAssets.smoking),
    HabitPreset(name: 'Don\'t Drink Alcohol', iconName: AppAssets.beer),
    HabitPreset(name: 'Decrease Screen Time', iconName: AppAssets.phone),
    HabitPreset(name: 'Do a Workout', iconName: AppAssets.dumbell),
    HabitPreset(name: 'Do Karate', iconName: AppAssets.karate),
    HabitPreset(name: 'Go Running', iconName: AppAssets.run),
    HabitPreset(name: 'Go Swimming', iconName: AppAssets.swimmer),
    HabitPreset(name: 'Do Some Stretches', iconName: AppAssets.stretching),
    HabitPreset(name: 'Play Sports', iconName: AppAssets.basketball),
    HabitPreset(name: 'Spend Time Outside', iconName: AppAssets.sun),
  ];
}
