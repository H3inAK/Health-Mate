import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../cubits/app_theme/app_theme_cubit.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  static const routeName = '/theme-selection-page';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Theme'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: screenWidth < 400 ? 80 : 100,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: themeColorSeeds.length,
                itemBuilder: (context, index) {
                  final themeColorSeed = themeColorSeeds[index];
                  final currentThemeColorSeed =
                      context.watch<AppThemeCubit>().state.themeColorSeed;
                  final isSelected =
                      themeColorSeed.name == currentThemeColorSeed.name;

                  return BlocBuilder<AppThemeCubit, AppThemeState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          AdaptiveTheme.of(context).setTheme(
                            light: ThemeData(
                              useMaterial3: true,
                              brightness: Brightness.light,
                              colorScheme: ColorScheme.fromSeed(
                                seedColor: themeColorSeed.seedColor,
                              ),
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                            dark: ThemeData(
                              useMaterial3: true,
                              brightness: Brightness.dark,
                              // colorScheme: ColorScheme.fromSeed(
                              //   seedColor: themeColorSeed.seedColor,
                              // ),
                              colorSchemeSeed: themeColorSeed.seedColor,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          );
                          context
                              .read<AppThemeCubit>()
                              .changeThemeColorScheme(themeColorSeed);
                        },
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : themeColorSeed.seedColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 36,
                                    )
                                  : Text(
                                      themeColorSeed.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth < 400 ? 8 : 12,
                  horizontal: screenWidth < 400 ? 24 : 40,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                final defaultTheme =
                    themeColorSeeds.firstWhere((seed) => seed.name == 'Indigo');
                AdaptiveTheme.of(context).setTheme(
                  light: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: defaultTheme.seedColor,
                    ),
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  dark: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    // colorScheme: ColorScheme.fromSeed(
                    //   seedColor: defaultTheme.seedColor,
                    // ),
                    colorSchemeSeed: defaultTheme.seedColor,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                );
                context
                    .read<AppThemeCubit>()
                    .changeThemeColorScheme(defaultTheme);
              },
              label: Text(
                'Reset to Default (Indigo)',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../constants.dart';
// import '../cubits/app_theme/app_theme_cubit.dart';

// class ThemeSelectionPage extends StatelessWidget {
//   const ThemeSelectionPage({super.key});

//   static const routeName = '/theme-selection-page';

//   @override
//   Widget build(BuildContext context) {
//     print(MediaQuery.of(context).size.width);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Theme'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             GridView.builder(
//               padding: const EdgeInsets.all(10),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 100,
//                 crossAxisSpacing: 22,
//                 mainAxisSpacing: 20,
//                 childAspectRatio: 1.1,
//               ),
//               itemCount: themeColorSeeds.length,
//               itemBuilder: (context, index) {
//                 final themeColorSeed = themeColorSeeds[index];
//                 final currentThemeColorSeed =
//                     context.watch<AppThemeCubit>().state.themeColorSeed;
//                 final isSelected =
//                     themeColorSeed.name == currentThemeColorSeed.name;

//                 return BlocBuilder<AppThemeCubit, AppThemeState>(
//                   builder: (context, state) {
//                     return GestureDetector(
//                       onTap: () {
//                         AdaptiveTheme.of(context).setTheme(
//                           light: ThemeData(
//                             useMaterial3: true,
//                             brightness: Brightness.light,
//                             colorScheme: ColorScheme.fromSeed(
//                               seedColor: themeColorSeed.seedColor,
//                             ),
//                             fontFamily: GoogleFonts.poppins().fontFamily,
//                           ),
//                           dark: ThemeData(
//                             useMaterial3: true,
//                             brightness: Brightness.dark,
//                             colorSchemeSeed: themeColorSeed.seedColor,
//                           ),
//                         );
//                         context
//                             .read<AppThemeCubit>()
//                             .changeThemeColorScheme(themeColorSeed);
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? Theme.of(context).colorScheme.primaryFixed
//                               : themeColorSeed.seedColor,
//                           shape: BoxShape.circle,
//                           border: isSelected
//                               ? Border.all(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   width: 6,
//                                 )
//                               : null,
//                         ),
//                         alignment: Alignment.center,
//                         child: isSelected
//                             ? const Icon(
//                                 Icons.check,
//                                 color: Colors.white,
//                                 size: 35,
//                               )
//                             : Text(
//                                 themeColorSeed.name,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.refresh),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 40,
//                   ),
//                   elevation: 1.2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 onPressed: () {
//                   final defaultTheme = themeColorSeeds
//                       .firstWhere((seed) => seed.name == 'Deep Purple');
//                   AdaptiveTheme.of(context).setTheme(
//                     light: ThemeData(
//                       useMaterial3: true,
//                       brightness: Brightness.light,
//                       colorScheme: ColorScheme.fromSeed(
//                         seedColor: defaultTheme.seedColor,
//                       ),
//                       fontFamily: GoogleFonts.poppins().fontFamily,
//                     ),
//                     dark: ThemeData(
//                       useMaterial3: true,
//                       brightness: Brightness.dark,
//                       colorSchemeSeed: defaultTheme.seedColor,
//                     ),
//                   );
//                   context
//                       .read<AppThemeCubit>()
//                       .changeThemeColorScheme(defaultTheme);
//                 },
//                 label: Text(
//                   'Reset to Default (Deep Purple)',
//                   style: GoogleFonts.getFont(
//                     'Poppins',
//                     fontWeight: FontWeight.w400,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }