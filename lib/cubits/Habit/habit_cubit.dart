import 'package:bloc/bloc.dart';

part 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitState());
}
