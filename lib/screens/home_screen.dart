import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/chat_with_ai/screens/ai_chat_screen.dart';
import '../features/edu_blogs/pages/edu_blogs_page.dart';
import '../features/habit_tacker/pages/habit_list_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  void onBottomNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness:
      //     !kIsWeb && Platform.isAndroid ? Brightness.light : Brightness.dark,
      // systemNavigationBarColor:
      //     AdaptiveTheme.of(context).mode == AdaptiveThemeMode.system
      //         ? AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor
      //         : AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
      //             ? AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor
      //             : AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor,
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: false,
        onPageChanged: onPageChanged,
        children: [
          HomePage(
            key: UniqueKey(),
          ),
          const HabitListsPage(),
          const BlogsPage(),
          const ProfilePage(),
        ],
      ),
      floatingActionButton: selectedPage == 1
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              label: const Text('Ask AI'),
              icon: const Icon(Icons.telegram_outlined),
            ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: selectedPage,
        animationDuration: const Duration(milliseconds: 450),
        onItemSelected: onBottomNavTap,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        showElevation: false,
        height: 55,
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home_filled),
            title: Text(
              'Home',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.lightbulb),
            title: Text(
              'Habits',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.book),
            title: Text(
              'Blogs',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          FlashyTabBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: FirebaseAuth.instance.currentUser?.photoURL ?? '',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Icon(Icons.person, size: 24),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person, size: 24),
                  ),
                ),
              ),
            ),
            title: Text(
              'Me',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
