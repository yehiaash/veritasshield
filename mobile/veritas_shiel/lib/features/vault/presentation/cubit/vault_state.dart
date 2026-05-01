import '../../data/models/document_model.dart';

abstract class VaultState {}

class VaultInitial extends VaultState {}

class VaultLoading extends VaultState {}

class VaultLoaded extends VaultState {
  final List<DocumentModel> documents;
  VaultLoaded(this.documents);
}

class VaultError extends VaultState {
  final String message;
  VaultError(this.message);
}

class DocumentUploading extends VaultState {}

class DocumentUploaded extends VaultState {
  final DocumentModel document;
  DocumentUploaded(this.document);
}
