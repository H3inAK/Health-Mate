import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeThemeModePage extends StatelessWidget {
  const ChangeThemeModePage({super.key});

  static const String routeName = '/change-thememode-page';

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
      appBar: AppBar(
        title: const Text("Theme Modes"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: AdaptiveTheme.getThemeMode(),
        builder: (builder, snapshot) {
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
            systemNavigationBarColor: Theme.of(context).brightness ==
                    Brightness.dark
                ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
                : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ));

          if (snapshot.hasData) {
            final themeMode = snapshot.data as AdaptiveThemeMode;

            return Column(
              children: [
                GestureDetector(
                  onTap: () => AdaptiveTheme.of(context).setLight(),
                  child: ListTile(
                    title: const Text("Light"),
                    trailing: themeMode == AdaptiveThemeMode.light
                        ? const Icon(Icons.check)
                        : null,
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () => AdaptiveTheme.of(context).setDark(),
                  child: ListTile(
                    title: const Text("Dark"),
                    trailing: themeMode == AdaptiveThemeMode.dark
                        ? const Icon(Icons.check)
                        : null,
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () => AdaptiveTheme.of(context).setSystem(),
                  child: ListTile(
                    title: const Text("System"),
                    trailing: themeMode == AdaptiveThemeMode.system
                        ? const Icon(Icons.check)
                        : null,
                  ),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error getting theme mode"),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
