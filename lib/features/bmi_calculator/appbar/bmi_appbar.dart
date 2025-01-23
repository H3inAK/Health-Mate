import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/repositories/auth_repository.dart';
import '../utils/widget_utils.dart' show appBarHeight;
import '../utils/widget_utils.dart' show screenAwareSize;

class BmiAppBar extends StatelessWidget {
  final bool isInputPage;
  static const String wavingHandEmoji = "\uD83D\uDC4B";
  static const String whiteSkinTone = "\uD83C\uDFFB";

  const BmiAppBar({Key? key, this.isInputPage = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepository = context.watch<AuthRepository>();
    final currentUser = authRepository.userCredential;
    String name;

    if (currentUser != null) {
      name = currentUser.displayName!;
      if (name == '') {
        name = 'User!';
      }
    } else {
      name = 'User!';
    }

    return Material(
      elevation: 0.0,
      child: SizedBox(
        height: appBarHeight(context),
        child: Padding(
            padding: EdgeInsets.all(screenAwareSize(16.0, context)),
            child: isInputPage
                ? _buildLabel(context, name)
                : Text(
                    "Your BMI Result ${getEmoji(context)}",
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 28.0),
                  )),
      ),
    );
  }

  RichText _buildLabel(BuildContext context, name) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 28.0),
        children: [
          const TextSpan(
            text: "Hello, ",
            style: TextStyle(
              color: Color(0xFF00154F),
              fontSize: 22.0,
            ),
          ),
          TextSpan(
            // text: "User! ${getEmoji(context)}",
            text: name,
            style: const TextStyle(
              color: Color(0xFF00154F),
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }

  String getEmoji(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? wavingHandEmoji
        : wavingHandEmoji + whiteSkinTone;
  }
}
