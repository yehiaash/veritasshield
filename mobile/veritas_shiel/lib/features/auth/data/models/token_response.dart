import 'package:equatable/equatable.dart';

class TokenResponse extends Equatable {
  final String access;
  final String refresh;

  const TokenResponse({
    required this.access,
    required this.refresh,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }

  @override
  List<Object?> get props => [access, refresh];
}
