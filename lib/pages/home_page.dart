import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../features/authentication/repositories/auth_repository.dart';
import '../features/bmi_calculator/pages/bmi_calculator.dart';
import '../features/habit_challenages/widgets/habit_challenages_widget.dart';
import '../features/habit_tacker/widgets/habits_status_dashboard.dart';
import '../features/mindfulness/pages/mindfulness_page.dart';
import '../features/mindfulness/utils/assets.dart';
import '../features/mindfulness/widgets/mindfulness_card_widget.dart';
import '../features/themes/cubits/app_theme/app_theme_cubit.dart';
import '../features/weather/widgets/weather_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
          ),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const GreetingMessage(),
                        const SizedBox(height: 20),
                        const WeatherInfoCard(),
                        const SizedBox(height: 10),
                        const CalculateBMIWidget(),
                        const HabitsStatusDashboard(),
                        const HabitChallenagesWidget(),
                        const MindfulnessListView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MindfulnessListView extends StatelessWidget {
  const MindfulnessListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Mindfulness Audios",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const MindfulnessPage(),
                  ),
                );
              },
              child: const Text("View All"),
            ),
          ],
        ),
        SizedBox(
          height: 186,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: kMindFullnessAssets.length - 2,
              itemBuilder: (context, index) {
                final asset = kMindFullnessAssets[index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1000),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: MindfulnessCardWidget(
                          asset: asset,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class GreetingMessage extends StatelessWidget {
  const GreetingMessage({super.key});

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Hey there,',
        style: GoogleFonts.getFont(
          'Poppins',
          letterSpacing: 1,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        '${getGreetingMessage()}, ${context.read<AuthRepository>().userCredential?.displayName == null ? 'User' : context.read<AuthRepository>().userCredential!.displayName}!',
        style: GoogleFonts.getFont(
          'Poppins',
          letterSpacing: 1,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class CalculateBMIWidget extends StatefulWidget {
  const CalculateBMIWidget({super.key});

  @override
  State<CalculateBMIWidget> createState() => _CalculateBMIWidgetState();
}

class _CalculateBMIWidgetState extends State<CalculateBMIWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String latestResult = '23.4 kg/m2';
  String comment = 'Calculate BMI Here';

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      latestResult = prefs.getDouble('bmi_result')?.toStringAsFixed(1) ?? '';
      comment = prefs.getString('bmi_comment') ?? 'Calculate BMI Here';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          elevation: Theme.of(context).brightness == Brightness.light ? 0.5 : 1,
          margin: EdgeInsets.zero,
          child: ListTile(
            title: Text(comment),
            subtitle: latestResult.isEmpty
                ? null
                : Text("latest result: $latestResult kg/m2"),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(BMIScreen.routeName);
              },
              child: Text("Calculate",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
        ),
      ),
    );
  }
}
