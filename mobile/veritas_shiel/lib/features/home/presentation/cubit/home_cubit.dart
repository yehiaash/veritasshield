import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void fetchData() async {
    emit(HomeLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      emit(const HomeLoaded("Data fetched successfully!"));
    } catch (e) {
      emit(const HomeError("Failed to fetch data"));
    }
  }
}
