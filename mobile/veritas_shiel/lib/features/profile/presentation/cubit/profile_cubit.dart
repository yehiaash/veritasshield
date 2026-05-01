import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final result = await _profileRepository.getProfile();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(ProfileLoading());
    final result = await _profileRepository.updateProfile(data);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
