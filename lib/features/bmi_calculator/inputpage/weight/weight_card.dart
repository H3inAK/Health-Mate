import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widget/card_title.dart';
import 'weight_slider.dart';
import '../../utils/widget_utils.dart' show screenAwareSize;

class WeightCard extends StatefulWidget {
  final int? initialWeight;
  final ValueChanged<int>? onChanged;

  const WeightCard({Key? key, this.initialWeight, this.onChanged})
      : super(key: key);

  @override
  State<WeightCard> createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  late int weight;

  @override
  void initState() {
    weight = widget.initialWeight ?? 70;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(8.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CardTitle(
                "Weight",
                subTitle: " (kg)",
              ),
              Padding(
                padding: EdgeInsets.only(top: screenAwareSize(20.0, context)),
                child: _drawWeightSlider(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawWeightSlider(BuildContext context) {
    return WeightBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSlider(
                  minValue: 30,
                  maxValue: 110,
                  value: weight,
                  onChanged: _onChanged,
                  width: constraints.maxWidth,
                );
        },
      ),
    );
  }

  _onChanged(int val) {
    weight = val;
    widget.onChanged!(val);
  }
}

class WeightBackground extends StatelessWidget {
  final Widget? child;

  const WeightBackground({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: screenAwareSize(20, context),
          ),
          height: screenAwareSize(100.0, context),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(
              screenAwareSize(100.0, context),
            ),
          ),
          child: child,
        ),
        SvgPicture.asset(
          "assets/bmi_assets/weight_arrow.svg",
          // ignore: deprecated_member_use
          color: Theme.of(context).primaryColorLight,
          // theme: SvgTheme(currentColor: Theme.of(context).primaryColorLight),
          height: screenAwareSize(10.0, context),
          width: screenAwareSize(18.0, context),
        )
      ],
    );
  }
}
