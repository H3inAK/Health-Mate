import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthmate/features/edu_blogs/constants/constants.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/custom_error.dart';
import '../../../habit_tacker/models/habit_model.dart';

part 'habit_challenages_state.dart';

class HabitChallenagesCubit extends Cubit<HabitChallenagesState> {
  HabitChallenagesCubit() : super(HabitChallenagesState.initial());

  Future<void> getHabits() async {
    emit(state.copyWith(status: HabitChallenagesStatus.loading));
    try {
      final response = await http.get(Uri.parse('$apiHost/goodhabits'));

      if (response.statusCode == 400) {
        print('Bad request');
        return;
      }

      if (response.statusCode == 500) {
        throw const CustomError(
          code: 'Server Exception',
          message: 'Internal Server Error',
          plugin: 'flutter_error/server_error',
        );
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final List<dynamic> habitsDynamicList = jsonResponse['data']['habits'];

        final List<Habit> challengeHabits = habitsDynamicList.map((e) {
          return Habit(
            title: e['title'] as String,
            description: e['description'] as String,
            priority: e['priority'] as String,
            icon: e['icon'] as String,
            repeat: 'Daily',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }).toList();

        emit(state.copyWith(
          status: HabitChallenagesStatus.loaded,
          habits: challengeHabits,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: HabitChallenagesStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }
}
