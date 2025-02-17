import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/widget_utils.dart' show screenAwareSize;
import 'gender.dart';

double _circleSize(BuildContext context) {
  return screenAwareSize(80.0, context);
}

const double _defaultIconAngel = math.pi / 4;

const Map<Gender, double> genderAngels = {
  Gender.female: -_defaultIconAngel,
  Gender.other: 0,
  Gender.male: _defaultIconAngel
};

class GenderIconTranslated extends StatelessWidget {
  static final Map<Gender, String> genderImages = {
    Gender.male: "assets/bmi_assets/male.svg",
    Gender.other: "assets/bmi_assets/other.svg",
    Gender.female: "assets/bmi_assets/female.svg"
  };

  bool get _isOtherGender => gender == Gender.other;

  String? get _assertName => genderImages[gender!];

  double _iconSize(BuildContext context) {
    return screenAwareSize(_isOtherGender ? 22.0 : 16.0, context);
  }

  double _genderLeftPadding(BuildContext context) {
    return screenAwareSize(_isOtherGender ? 8.0 : 0.0, context);
  }

  final Gender? gender;

  const GenderIconTranslated({Key? key, this.gender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon = Padding(
      padding: EdgeInsets.only(
        left: _genderLeftPadding(context),
      ),
      child: SvgPicture.asset(
        _assertName!,
        width: _iconSize(context),
        height: _iconSize(context),
      ),
    );

    Widget rotateIcon = Transform.rotate(
      angle: genderAngels[gender!]!,
      child: icon,
    );

    Widget iconWithAline = Padding(
      padding: EdgeInsets.only(bottom: _circleSize(context) / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          rotateIcon,
          SizedBox(
            height: screenAwareSize(4.0, context),
          )
          // const GenderLine(),
        ],
      ),
    );

    Widget rotatedIconWithALine = Transform.rotate(
      alignment: Alignment.bottomCenter,
      angle: genderAngels[gender!]!,
      child: iconWithAline,
    );

    Widget centeredIconWithALine = Padding(
      padding: EdgeInsets.only(bottom: _circleSize(context) / 2),
      child: rotatedIconWithALine,
    );

    return centeredIconWithALine;
  }
}
