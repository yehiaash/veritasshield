import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/vault_repository.dart';
import 'vault_state.dart';

class VaultCubit extends Cubit<VaultState> {
  final VaultRepository _vaultRepository;

  VaultCubit(this._vaultRepository) : super(VaultInitial());

  Future<void> getDocuments() async {
    emit(VaultLoading());
    final result = await _vaultRepository.getDocuments();
    result.fold(
      (failure) => emit(VaultError(failure.message)),
      (documents) => emit(VaultLoaded(documents)),
    );
  }

  Future<void> uploadDocument(String filePath, String title) async {
    emit(DocumentUploading());
    final result = await _vaultRepository.uploadDocument(filePath, title);
    result.fold(
      (failure) => emit(VaultError(failure.message)),
      (document) {
        emit(DocumentUploaded(document));
        getDocuments(); // Refresh list after upload
      },
    );
  }
}
