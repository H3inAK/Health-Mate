import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/blogs_list.dart';
import '../widgets/categories.dart';
import '../widgets/search_bar.dart';

class BlogsPage extends StatelessWidget {
  const BlogsPage({super.key});

  static const String routeName = '/edu-blogs';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 6,
          left: 16,
          right: 16,
        ),
        child: const Column(
          children: [
            SearchBarWidget(),
            SizedBox(height: 4),
            Categories(),
            Expanded(
              child: BlogsList(),
            ),
          ],
        ),
      ),
    );
  }
}
