class ApiEndpoints {
  static const String baseUrl = "http://localhost:8000";
  
  // Auth Endpoints
  static const String login = "/auth/login/";
  static const String register = "/auth/register/";
  static const String refresh = "/auth/refresh/";
  static const String logout = "/auth/logout/";
  static const String profile = "/auth/profile/";

  // Document Endpoints
  static const String documents = "/documents/";
  static const String uploadDocument = "/documents/upload/";

  // Analysis Endpoints
  static const String analyze = "/analysis/analyze/";
  static const String results = "/analysis/results/";
}
