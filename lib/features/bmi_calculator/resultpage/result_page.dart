import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../calculator.dart' as calculator;
import '../inputpage/gender/gender.dart';

class ResultPage extends StatefulWidget {
  final int? height;
  final int? weight;
  final Gender? gender;

  const ResultPage({Key? key, this.height, this.weight, this.gender})
      : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    _saveResults();
  }

  Future<void> _saveResults() async {
    final prefs = await SharedPreferences.getInstance();
    final bmi = calculator.calculateBMI(
      height: widget.height!,
      weight: widget.weight!,
    );
    final comment = _getComment(bmi);

    await prefs.setDouble('bmi_result', bmi);
    await prefs.setString('bmi_comment', comment);
  }

  String _getComment(double bmi) {
    if (bmi < 18.5) {
      return 'Need Some 🥛🥙🥩';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Keep It up 😍🔥';
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return 'Need Healthy Food 🥕🍅🍆';
    } else {
      return 'Workout 🏃‍💪🏋️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your BMI Result',
          style: GoogleFonts.getFont('Poppins', letterSpacing: 1.0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ResultCard(
            bmi: calculator.calculateBMI(
              height: widget.height!,
              weight: widget.weight!,
            ),
            minWeight:
                calculator.calculateMinNormalWeight(height: widget.height!),
            maxWeight:
                calculator.calculateMaxNormalWeight(height: widget.height!),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 52.0,
            width: 300.0,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                elevation: WidgetStateProperty.all(1.0),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.refresh,
                size: 28.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: const Text("Re-Calculate"),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  comment(double bmi) {
    if (bmi < 18.5) {
      return const Column(
        children: <Widget>[
          Text(
            'You Are Kinda Skinny',
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            'You Need Some 🥛🥙🥩',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return const Column(
        children: <Widget>[
          Text(
            'You In A Great Shape',
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            'Keep It up 😍🔥',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return const Column(
        children: <Widget>[
          Text(
            'It Ok But Pay Attention',
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            'You Need Healthy Food 🥕🍅🍆',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    if (bmi >= 30) {
      return const Column(
        children: <Widget>[
          Text(
            'Get Your Self Up Now',
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            'And Workout 🏃‍💪🏋️',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }

  final double? bmi;
  final double? minWeight;
  final double? maxWeight;

  const ResultCard({Key? key, this.bmi, this.minWeight, this.maxWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            comment(bmi!),
            Text(
              bmi!.toStringAsFixed(1),
              style:
                  const TextStyle(fontSize: 140.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'BMI = ${bmi!.toStringAsFixed(2)} kg/m²',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Normal BMI weight range for the height:\n${minWeight!.round()}kg - ${maxWeight!.round()}kg',
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
