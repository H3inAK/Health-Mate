import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authentication/blocs.dart';
import 'features/authentication/repositories/auth_repository.dart';
import 'features/authentication/repositories/profile_repository.dart';
import 'features/authentication/screens/forgot_password_screen.dart';
import 'features/authentication/screens/signin_screen.dart';
import 'features/authentication/screens/signup_screen.dart';
import 'features/authentication/screens/splash_screen.dart';
import 'features/bmi_calculator/pages/bmi_calculator.dart';
import 'features/chat_with_ai/screens/ai_chat_screen.dart';
import 'features/edu_blogs/cubits/blogs/blogs_cubit.dart';
import 'features/edu_blogs/cubits/categories/blog_categories_cubit.dart';
import 'features/edu_blogs/repositories/blogs_repository.dart';
import 'features/habit_challenages/cubits/habit_challenages/habit_challenages_cubit.dart';
import 'features/habit_tacker/blocs/habit/habit_bloc.dart';
import 'features/habit_tacker/blocs/individual_habit/individual_habit_bloc.dart';
import 'features/habit_tacker/constants/app_assets.dart';
import 'features/habit_tacker/database/habit_db.dart';
import 'features/mindfulness/pages/home.dart';
import 'features/onboarding/data_persistence.dart';
import 'features/onboarding/onborading_screen.dart';
import 'features/themes/cubits/app_theme/app_theme_cubit.dart';
import 'features/themes/pages/change_theme_mode_page.dart';
import 'features/themes/pages/themes_selection_page.dart';
import 'features/weather/blocs/blocs.dart';
import 'features/weather/repositories/weather_repository.dart';
import 'features/weather/services/location_service.dart';
import 'features/weather/services/weather_api_service.dart';
import 'screens/home_screen.dart';

import 'firebase_options.dart';

Future<void> setPreferredWindowsSize() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    Size size = await DesktopWindow.getWindowSize();
    debugPrint(size.toString());

    await DesktopWindow.setWindowSize(const Size(800, 950));
    await DesktopWindow.setMinWindowSize(const Size(400, 400));
    await DesktopWindow.setMaxWindowSize(const Size(800, 700));
  }
}

Future<void> saveTodayDate() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();
  await prefs.setString('lastOpenedDate', today.toIso8601String());
}

Future<bool> isNewDay() async {
  final prefs = await SharedPreferences.getInstance();
  final lastOpenedDateStr = prefs.getString('lastOpenedDate');

  if (lastOpenedDateStr == null) {
    await saveTodayDate();
    return true;
  }

  final lastOpenedDate = DateTime.parse(lastOpenedDateStr);
  final today = DateTime.now();

  if (today.year != lastOpenedDate.year ||
      today.month != lastOpenedDate.month ||
      today.day != lastOpenedDate.day) {
    await saveTodayDate();
    return true;
  }

  return false;
}

Future<void> resetHabitsIfNewDay() async {
  final newDay = await isNewDay();
  if (newDay) {
    final db = await HabitDatabase.instance.database;
    await db!.update(
      'habits',
      {'completed': 0},
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  if (Platform.isWindows) await setPreferredWindowsSize();

  await dotenv.load(fileName: '.env');

  await SharedPrefsKeys.init();
  await resetHabitsIfNewDay();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AppAssets.preloadSVGs().then((_) => debugPrint("Loaded Assets"));

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.savedThemeMode,
  }) : super(key: key);

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: savedThemeMode == AdaptiveThemeMode.system ||
              savedThemeMode == AdaptiveThemeMode.light
          ? Colors.white
          : Colors.black,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            firebaseAuth: fbAuth.FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
          ),
        ),
        RepositoryProvider(
          create: (context) => BlogsRepository(
            httpClient: http.Client(),
          ),
        ),
        RepositoryProvider(
          create: (context) => WeatherRepository(
            LocationService(),
            weatherApiService: WeatherApiService(
              httpClient: http.Client(),
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepository(
            firebaseAuth: fbAuth.FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
            storage: FirebaseStorage.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AppThemeCubit(),
          ),
          BlocProvider(
            create: (context) => HabitBloc(),
          ),
          BlocProvider(
            create: (context) => IndividualHabitBloc(),
          ),
          BlocProvider(
            create: (context) => WeatherBloc(
              context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BlogsCubit(
              context.read<BlogsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BlogCategoriesCubit(
              context.read<BlogsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HabitChallenagesCubit(),
          )
        ],
        child: BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, appThemeState) {
            return AdaptiveTheme(
              light: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                colorSchemeSeed: appThemeState.themeColorSeed.seedColor,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              dark: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorSchemeSeed: appThemeState.themeColorSeed.seedColor,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              initial: savedThemeMode ?? AdaptiveThemeMode.system,
              builder: (theme, darkTheme) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Health Mate',
                theme: theme,
                darkTheme: darkTheme,
                initialRoute: SplashScreen.routeName,
                routes: {
                  SplashScreen.routeName: (context) => const SplashScreen(),
                  HomeScreen.routeName: (context) => const HomeScreen(),
                  OnBoardingScreen.routeName: (context) =>
                      const OnBoardingScreen(),
                  SignInScreen.routeName: (context) => const SignInScreen(),
                  SignUpScreen.routeName: (context) => const SignUpScreen(),
                  ForgotPasswordScreen.routeName: (context) =>
                      ForgotPasswordScreen(),
                  BMIScreen.routeName: (context) => const BMIScreen(),
                  ChatScreen.routeName: (context) => const ChatScreen(),
                  ChangeThemeModePage.routeName: (context) =>
                      const ChangeThemeModePage(),
                  ThemeSelectionPage.routeName: (context) =>
                      const ThemeSelectionPage(),
                  MindfullnessPage.routeName: (context) =>
                      const MindfullnessPage(),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
