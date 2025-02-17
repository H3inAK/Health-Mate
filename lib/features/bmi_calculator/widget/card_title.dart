import 'package:flutter/material.dart';

import '..//utils/widget_utils.dart' show screenAwareSize;

const TextStyle _titleStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  // color: Colors.purple,
);

const TextStyle _subTitleStyle = TextStyle(
  fontSize: 11.0,
  // color: Colors.purple,
);

class CardTitle extends StatelessWidget {
  final String title;

  final String? subTitle;

  const CardTitle(this.title, {Key? key, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: screenAwareSize(8.0, context),
              left: screenAwareSize(13.0, context),
              right: screenAwareSize(11.0, context),
              bottom: screenAwareSize(8.0, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: _titleStyle),
              Text(subTitle ?? "", style: _subTitleStyle),
            ],
          ),
        ),
        Divider(
          height: 1.0,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ],
    );
  }
}
