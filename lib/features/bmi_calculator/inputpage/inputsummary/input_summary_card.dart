import 'package:flutter/material.dart';

import '../gender/gender.dart';
import '../../utils/widget_utils.dart' show screenAwareSize;

class InputSummaryCard extends StatelessWidget {
  final Gender? gender;
  final int? height;
  final int? weight;

  const InputSummaryCard({Key? key, this.gender, this.weight, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(screenAwareSize(16.0, context)),
      child: SizedBox(
        height: screenAwareSize(32.0, context),
        child: Row(
          children: <Widget>[
            Expanded(child: _text("${height}cm", context)),
            _divider(context),
            Expanded(child: _genderText(context)),
            _divider(context),
            Expanded(child: _text("${weight}kg", context)),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 2.0,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
    );
  }

  Widget _genderText(BuildContext context) {
    String genderText = gender == Gender.other
        ? '-'
        : (gender == Gender.male ? 'Male' : 'Female');
    return _text(genderText, context);
  }

  Widget _text(String text, BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        // color: Theme.of(context).primaryColor,
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
