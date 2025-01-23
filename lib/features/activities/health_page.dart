import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  List<HealthDataPoint> _healthDataList = [];
  // int? _steps;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
  }

  // Future<void> _requestPermissions() async {
  //   // Request all necessary permissions
  //   var status = await [
  //     Permission.activityRecognition,
  //     Permission.sensors,
  //     // Add other necessary permissions
  //   ].request();

  //   // Check the status of each permission
  //   if (status[Permission.activityRecognition]!.isGranted &&
  //       status[Permission.sensors]!.isGranted) {
  //     // All permissions are granted
  //     _fetchHealthData();
  //   } else {
  //     // Permissions are not granted, handle accordingly
  //     debugPrint("Permissions not granted");
  //   }
  // }

  Future<void> _fetchHealthData() async {
    // await Permission.activityRecognition.request();
    await Permission.location.request();

    Health().configure(useHealthConnectIfAvailable: true);

    var types = [
      HealthDataType.STEPS,
      // HealthDataType.BLOOD_GLUCOSE,
    ];

    _isAuthorized = await Health().requestAuthorization(types);

    if (_isAuthorized) {
      var now = DateTime.now();
      // _healthDataList = await Health().getHealthDataFromTypes(
      //     now.subtract(Duration(days: 1)), now, types);
      print("HealthDataList");
      _healthDataList = await Health().getHealthDataFromTypes(
        types: types,
        startTime: now.subtract(
          const Duration(days: 1),
        ),
        endTime: now,
      );

      print("Midnight");
      // Fetch total steps for today
      // var midnight = DateTime(now.year, now.month, now.day);
      // _steps = await Health().getTotalStepsInInterval(midnight, now);

      setState(() {});
    } else {
      // Handle the case where permission is not granted
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions not granted')),
      );
    }
  }

  Future<void> _writeHealthData() async {
    if (_isAuthorized) {
      var now = DateTime.now();
      // Write steps and blood glucose data
      // bool success =
      //     await Health().writeHealthData(10, HealthDataType.STEPS, now, now);
      bool success = await Health().writeHealthData(
        value: 10,
        type: HealthDataType.STEPS,
        startTime: now,
      );
      // success = await Health()
      //     .writeHealthData(3.1, HealthDataType.BLOOD_GLUCOSE, now, now);
      success = await Health().writeHealthData(
        value: 3.1,
        type: HealthDataType.BLOOD_GLUCOSE,
        startTime: now,
      );

      if (success) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data written successfully')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to write data')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchHealthData,
              child: const Text('Fetch Health Data'),
            ),
            ElevatedButton(
              onPressed: _writeHealthData,
              child: const Text('Write Health Data'),
            ),
            // if (_steps != null) Text('Steps today: $_steps'),
            Expanded(
              child: ListView.builder(
                itemCount: _healthDataList.length,
                itemBuilder: (context, index) {
                  var data = _healthDataList[index];
                  return ListTile(
                    title: Text('${data.typeString}: ${data.value}'),
                    subtitle: Text('${data.dateFrom} - ${data.dateTo}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() => runApp(HealthApp());

// class HealthApp extends StatefulWidget {
//   @override
//   _HealthAppState createState() => _HealthAppState();
// }

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTHORIZED,
//   AUTH_NOT_GRANTED,
//   DATA_ADDED,
//   DATA_DELETED,
//   DATA_NOT_ADDED,
//   DATA_NOT_DELETED,
//   STEPS_READY,
//   HEALTH_CONNECT_STATUS,
// }

// class _HealthAppState extends State<HealthApp> {
//   List<HealthDataPoint> _healthDataList = [];
//   AppState _state = AppState.DATA_NOT_FETCHED;
//   int _nofSteps = 0;

//   List<HealthDataType> get types => (Platform.isAndroid)
//       ? dataTypesAndroid
//       : (Platform.isIOS)
//           ? dataTypesIOS
//           : [];

//   List<HealthDataAccess> get permissions =>
//       types.map((e) => HealthDataAccess.READ).toList();

//   @override
//   void initState() {
//     super.initState();
//     Health().configure(useHealthConnectIfAvailable: true);
//   }

//   Future<void> authorize() async {
//     try {
//       await Permission.activityRecognition.request();
//       await Permission.location.request();

//       bool? hasPermissions =
//           await Health().hasPermissions(types, permissions: permissions);

//       hasPermissions = false;

//       if (!hasPermissions) {
//         bool authorized = await Health()
//             .requestAuthorization(types, permissions: permissions);
//         setState(() => _state =
//             authorized ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
//       }
//     } catch (error) {
//       debugPrint("Error during authorization: $error");
//       setState(() => _state = AppState.AUTH_NOT_GRANTED);
//     }
//   }

//   Future<void> fetchData() async {
//     setState(() => _state = AppState.FETCHING_DATA);
//     final now = DateTime.now();
//     final yesterday = now.subtract(Duration(hours: 24));

//     _healthDataList.clear();

//     try {
//       List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
//         types: types,
//         startTime: yesterday,
//         endTime: now,
//       );

//       _healthDataList.addAll(
//           (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
//       _healthDataList = Health().removeDuplicates(_healthDataList);
//       setState(() {
//         _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
//       });
//     } catch (error) {
//       debugPrint("Error fetching data: $error");
//       setState(() => _state = AppState.NO_DATA);
//     }
//   }

//   Future<void> addData() async {
//     final now = DateTime.now();
//     final earlier = now.subtract(Duration(minutes: 20));

//     try {
//       bool success = true;
//       success &= await Health().writeHealthData(
//         value: 1.925,
//         type: HealthDataType.HEIGHT,
//         startTime: earlier,
//         endTime: now,
//       );
//       // Add more data points as needed...

//       setState(() {
//         _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
//       });
//     } catch (error) {
//       debugPrint("Error adding data: $error");
//       setState(() => _state = AppState.DATA_NOT_ADDED);
//     }
//   }

//   Future<void> deleteData() async {
//     final now = DateTime.now();
//     final earlier = now.subtract(Duration(hours: 24));

//     try {
//       bool success = true;
//       for (HealthDataType type in types) {
//         success &= await Health().delete(
//           type: type,
//           startTime: earlier,
//           endTime: now,
//         );
//       }

//       setState(() {
//         _state = success ? AppState.DATA_DELETED : AppState.DATA_NOT_DELETED;
//       });
//     } catch (error) {
//       debugPrint("Error deleting data: $error");
//       setState(() => _state = AppState.DATA_NOT_DELETED);
//     }
//   }

//   Future<void> fetchStepData() async {
//     int? steps;
//     final now = DateTime.now();
//     final midnight = DateTime(now.year, now.month, now.day);

//     bool stepsPermission =
//         await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
//     if (!stepsPermission) {
//       stepsPermission =
//           await Health().requestAuthorization([HealthDataType.STEPS]);
//     }

//     if (stepsPermission) {
//       try {
//         steps = await Health().getTotalStepsInInterval(midnight, now);
//         debugPrint('Total number of steps: $steps');
//         setState(() {
//           _nofSteps = steps ?? 0;
//           _state = steps == null ? AppState.NO_DATA : AppState.STEPS_READY;
//         });
//       } catch (error) {
//         debugPrint("Error fetching steps: $error");
//         setState(() => _state = AppState.NO_DATA);
//       }
//     } else {
//       debugPrint("Authorization not granted for steps");
//       setState(() => _state = AppState.DATA_NOT_FETCHED);
//     }
//   }

//   Future<void> revokeAccess() async {
//     try {
//       await Health().revokePermissions();
//     } catch (error) {
//       debugPrint("Error revoking access: $error");
//     }
//   }

//   Future<void> getHealthConnectSdkStatus() async {
//     if (Platform.isAndroid) {
//       final status = await Health().getHealthConnectSdkStatus();
//       setState(() {
//         _state = AppState.HEALTH_CONNECT_STATUS;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Health Example'),
//         ),
//         body: Column(
//           children: [
//             Wrap(
//               spacing: 10,
//               children: [
//                 _buildButton('Authenticate', authorize),
//                 if (Platform.isAndroid)
//                   _buildButton('Check Health Connect Status',
//                       getHealthConnectSdkStatus),
//                 _buildButton('Fetch Data', fetchData),
//                 _buildButton('Add Data', addData),
//                 _buildButton('Delete Data', deleteData),
//                 _buildButton('Fetch Step Data', fetchStepData),
//                 _buildButton('Revoke Access', revokeAccess),
//               ],
//             ),
//             Divider(thickness: 3),
//             Expanded(child: Center(child: _content)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildButton(String text, VoidCallback onPressed) {
//     return TextButton(
//       onPressed: onPressed,
//       child: Text(text, style: TextStyle(color: Colors.white)),
//       style: ButtonStyle(
//           backgroundColor: MaterialStatePropertyAll(Colors.blue)),
//     );
//   }

//   Widget get _contentFetchingData => Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           CircularProgressIndicator(strokeWidth: 10),
//           Text('Fetching data...')
//         ],
//       );

//   Widget get _contentDataReady => ListView.builder(
//         itemCount: _healthDataList.length,
//         itemBuilder: (_, index) {
//           HealthDataPoint p = _healthDataList[index];
//           return ListTile(
//             title: Text("${p.typeString}: ${p.value}"),
//             trailing: Text('${p.unitString}'),
//             subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
//           );
//         },
//       );

//   Widget get _contentNoData => const Text('No Data to show');
//   Widget get _contentNotFetched => const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Press 'Authenticate' to get permissions."),
//           Text("Press 'Fetch Data' to get health data."),
//         ],
//       );
//   Widget get _authorized => const Text('Authorization granted!');
//   Widget get _authorizationNotGranted => const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Authorization not granted.'),
//         ],
//       );
//   Widget get _dataAdded => const Text('Data points inserted successfully.');
//   Widget get _dataDeleted => const Text('Data points deleted successfully.');
//   Widget get _stepsFetched => Text('Total number of steps: $_nofSteps.');
//   Widget get _dataNotAdded =>
//       const Text('Failed to add data.\nDo you have permissions to add data?');
//   Widget get _dataNotDeleted => const Text('Failed to delete data');
//   Widget get _content => switch (_state) {
//         AppState.DATA_READY => _contentDataReady,
//         AppState.DATA_NOT_FETCHED => _contentNotFetched,
//         AppState.FETCH
