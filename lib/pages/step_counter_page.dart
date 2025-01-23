import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  List<HealthDataPoint> _stepData = [];

  @override
  void initState() {
    super.initState();
    _fetchStepData();
  }

  Future<void> _fetchStepData() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();
    // Configure the Health plugin
    Health().configure(useHealthConnectIfAvailable: true);

    try {
      List<HealthDataType> types = [
        HealthDataType.STEPS,
        HealthDataType.BLOOD_GLUCOSE,
      ];
      final authorized = await Health().requestAuthorization(types);

      if (authorized) {
        DateTime now = DateTime.now();
        DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);
        List<HealthDataPoint> stepData = await Health().getHealthDataFromTypes(
          startTime: start,
          endTime: now,
          types: types,
        );
        print(stepData);
        setState(() {
          _stepData = stepData;
        });
      } else {
        print("Not authorized");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
      ),
      body: ListView.builder(
        itemCount: _stepData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Steps: ${_stepData[index].value}'),
            subtitle: Text('Date: ${_stepData[index].dateTo}'),
          );
        },
      ),
    );
  }
}
