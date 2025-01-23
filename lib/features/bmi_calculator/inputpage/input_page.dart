import 'package:flutter/material.dart';

import '../bottombar/pacman_slider.dart';
import '../bottombar/transition_dot.dart';
import '../fade_route.dart';
import '../resultpage/result_page.dart';
import '../utils/widget_utils.dart' show screenAwareSize;
import 'gender/gender.dart';
import 'gender/gender_card.dart';
import 'height/height_card.dart';
import 'inputsummary/input_summary_card.dart';
import 'weight/weight_card.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return InputPageState();
  }
}

class InputPageState extends State<InputPage> with TickerProviderStateMixin {
  Gender gender = Gender.other;
  int height = 170;
  int weight = 70;

  AnimationController? submitAnimationController;

  @override
  void initState() {
    super.initState();
    submitAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    submitAnimationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToResultPage().then((_) => submitAnimationController!.reset());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text("BMI Calculator"),
            centerTitle: true,
          ),
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(
          //     appBarHeight(context),
          //   ),
          //   child: const BmiAppBar(),
          // ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InputSummaryCard(
                gender: gender,
                weight: weight,
                height: height,
              ),
              Expanded(
                child: _buildCards(context),
              ),
              _buildBottom(context),
            ],
          ),
        ),
        TransitionDot(animation: submitAnimationController!),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(16.0, context),
        right: screenAwareSize(16.0, context),
        bottom: screenAwareSize(22.0, context),
        top: screenAwareSize(14.0, context),
      ),
      child: SizedBox(
        height: screenAwareSize(52.0, context),
        child: PacmanSlider(
          onSubmit: onPacmanSubmit,
          submitAnimationController: submitAnimationController,
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: HeightCard(
            height: height,
            onChanged: (val) => setState(() => height = val),
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: GenderCard(
                  initialGender: gender,
                  onChanged: (val) => setState(() => gender = val),
                ),
              ),
              Expanded(
                child: WeightCard(
                  initialWeight: weight,
                  onChanged: (val) => setState(() => weight = val),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onPacmanSubmit() {
    submitAnimationController!.forward();
  }

  _goToResultPage() async {
    return Navigator.of(context).push(
      FadeRoute(
        builder: (context) => ResultPage(
          weight: weight,
          height: height,
          gender: gender,
        ),
      ),
    );
  }

  @override
  void dispose() {
    submitAnimationController!.dispose();
    super.dispose();
  }
}
