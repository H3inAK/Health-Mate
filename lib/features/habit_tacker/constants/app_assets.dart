import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  // system UI
  static const check = 'assets/habit_svgs/check.svg';
  static const plus = 'assets/habit_svgs/plus.svg';
  static const threeDots = 'assets/habit_svgs/three-dots.svg';
  static const delete = 'assets/habit_svgs/delete.svg';
  static const navigationClose = 'assets/habit_svgs/navigation-close.svg';
  static const navigationBack = 'assets/habit_svgs/navigation-back.svg';

  // tasks
  static const basketball = 'assets/habit_svgs/basketball-ball.svg';
  static const beer = 'assets/habit_svgs/beer.svg';
  static const bike = 'assets/habit_svgs/bike.svg';
  static const book = 'assets/habit_svgs/book.svg';
  static const carrot = 'assets/habit_svgs/carrot.svg';
  static const chef = 'assets/habit_svgs/chef.svg';
  static const dentalFloss = 'assets/habit_svgs/dental-floss.svg';
  static const dog = 'assets/habit_svgs/dog.svg';
  static const dumbell = 'assets/habit_svgs/dumbell.svg';
  static const guitar = 'assets/habit_svgs/guitar.svg';
  static const homework = 'assets/habit_svgs/homework.svg';
  static const html = 'assets/habit_svgs/html-coding.svg';
  static const karate = 'assets/habit_svgs/karate.svg';
  static const mask = 'assets/habit_svgs/mask.svg';
  static const meditation = 'assets/habit_svgs/meditation.svg';
  static const painting = 'assets/habit_svgs/paint-board-and-brush.svg';
  static const phone = 'assets/habit_svgs/phone.svg';
  static const pushups = 'assets/habit_svgs/pushups-man.svg';
  static const rest = 'assets/habit_svgs/rest.svg';
  static const run = 'assets/habit_svgs/run.svg';
  static const smoking = 'assets/habit_svgs/smoking.svg';
  static const stretching = 'assets/habit_svgs/stretching-exercises.svg';
  static const sun = 'assets/habit_svgs/sun.svg';
  static const swimmer = 'assets/habit_svgs/swimmer.svg';
  static const toothbrush = 'assets/habit_svgs/toothbrush.svg';
  static const vitamins = 'assets/habit_svgs/vitamins.svg';
  static const washHands = 'assets/habit_svgs/wash-hands.svg';
  static const water = 'assets/habit_svgs/water.svg';

  // bmi
  static const male = 'assets/bmi_assets/male.svg';
  static const female = 'assets/bmi_assets/female.svg';
  static const other = 'assets/bmi_assets/other.svg';
  static const genderArrow = 'assets/bmi_assets/gender_arrow.svg';
  static const pacman = 'assets/bmi_assets/pacman.svg';
  static const person = 'assets/bmi_assets/person.svg';
  static const user = 'assets/bmi_assets/user.svg';
  static const weightArrow = 'assets/bmi_assets/weight_arrow.svg';

  // logos
  static const google = 'assets/logo_svgs/google_logo.svg';

  static const allIcons = [
    basketball,
    beer,
    bike,
    book,
    carrot,
    chef,
    dentalFloss,
    dog,
    dumbell,
    guitar,
    homework,
    html,
    karate,
    mask,
    meditation,
    painting,
    phone,
    pushups,
    rest,
    run,
    smoking,
    stretching,
    sun,
    swimmer,
    toothbrush,
    vitamins,
    washHands,
    water,
    male,
    female,
    other,
    genderArrow,
    pacman,
    person,
    user,
    weightArrow,
    google,
  ];

  static const allTaskIcons = [
    basketball,
    beer,
    bike,
    book,
    carrot,
    chef,
    dentalFloss,
    dog,
    dumbell,
    guitar,
    homework,
    html,
    karate,
    mask,
    meditation,
    painting,
    phone,
    pushups,
    rest,
    run,
    smoking,
    stretching,
    sun,
    swimmer,
    toothbrush,
    vitamins,
    washHands,
    water,
  ];

  static Future<void> preloadSVGs() async {
    final assets = [
      // system UI
      check,
      plus,
      threeDots,
      delete,
      navigationClose,
      navigationBack,
      // tasks
      ...allIcons,
    ];
    for (final asset in assets) {
      final loader = SvgAssetLoader(asset);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      // lower flutter_svg version, use it
      // await precachePicture(
      //   ExactAssetPicture(SvgPicture.svgStringDecoder, asset),
      //   null,
      // );
    }
  }
}
