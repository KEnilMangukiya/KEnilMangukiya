class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://api.example.com');
}
