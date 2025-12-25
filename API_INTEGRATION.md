# API Integration Guide

## Overview

This guide explains how to integrate your actual CRM system with the Call Info Manager application. Currently, the app uses a simulated CRM service for demonstration purposes.

## Current Implementation

The app includes a mock CRM service at `lib/services/crm_service.dart` that:
- Simulates API delays
- Returns sample customer data 70% of the time
- Throws "Customer not found" exception 30% of the time

## Integration Steps

### 1. Update CRM Service

Replace the simulated methods in `lib/services/crm_service.dart` with actual API calls.

#### Required Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0  # For HTTP requests
  dio: ^5.4.0   # Alternative HTTP client (recommended)
```

#### Example Implementation with Dio

```dart
import 'package:dio/dio.dart';
import '../models/crm_data_model.dart';

class CRMService {
  final Dio _dio;
  final String baseUrl = 'https://your-crm-api.com/api/v1';
  
  CRMService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Fetch customer data from CRM
  Future<CRMData?> fetchCustomerData(String phoneOrId) async {
    try {
      final response = await _dio.get(
        '/customers/search',
        queryParameters: {'query': phoneOrId},
      );

      if (response.statusCode == 200) {
        return CRMData.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Customer not found in CRM');
      } else {
        throw Exception('Failed to fetch customer data');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Customer not found in CRM');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // Save new customer information
  Future<bool> saveCustomerInfo(Map<String, dynamic> customerData) async {
    try {
      final response = await _dio.post(
        '/customers',
        data: customerData,
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to save customer: ${e.message}');
    }
  }

  // Update existing CRM data
  Future<bool> updateCRMData(
    String customerId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _dio.patch(
        '/customers/$customerId',
        data: updates,
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to update customer: ${e.message}');
    }
  }
  
  // Add call note to customer history
  Future<bool> addCallNote(
    String customerId,
    String notes,
    Duration callDuration,
  ) async {
    try {
      final response = await _dio.post(
        '/customers/$customerId/calls',
        data: {
          'notes': notes,
          'duration': callDuration.inSeconds,
          'timestamp': DateTime.now().toIso8601String(),
          'type': 'Incoming',
          'status': 'Completed',
        },
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to add call note: ${e.message}');
    }
  }
}
```

### 2. Authentication

If your CRM requires authentication, add an authentication interceptor:

```dart
class CRMService {
  final Dio _dio;
  String? _authToken;

  CRMService() : _dio = Dio() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token to all requests
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - refresh token
          if (error.response?.statusCode == 401) {
            await _refreshToken();
            // Retry the request
            return handler.resolve(await _retry(error.requestOptions));
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> authenticate(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      
      _authToken = response.data['token'];
    } catch (e) {
      throw Exception('Authentication failed');
    }
  }

  Future<void> _refreshToken() async {
    // Implement token refresh logic
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }
}
```

### 3. Environment Configuration

Create environment-specific configurations:

**lib/config/env_config.dart**:

```dart
class EnvConfig {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  static String get apiBaseUrl {
    switch (env) {
      case 'production':
        return 'https://api.yourcrm.com/v1';
      case 'staging':
        return 'https://staging-api.yourcrm.com/v1';
      default:
        return 'https://dev-api.yourcrm.com/v1';
    }
  }
  
  static String get apiKey {
    return const String.fromEnvironment('API_KEY', defaultValue: '');
  }
}
```

Run with environment variables:

```bash
flutter run --dart-define=ENV=production --dart-define=API_KEY=your_key
```

### 4. Data Mapping

Ensure your CRM data structure matches the app models. If not, create a mapper:

```dart
class CRMDataMapper {
  static CRMData fromApiResponse(Map<String, dynamic> json) {
    return CRMData(
      customerId: json['id'] ?? json['customer_id'],
      name: '${json['first_name']} ${json['last_name']}',
      email: json['email_address'],
      phone: json['phone_number'],
      // ... map other fields
    );
  }
}
```

### 5. Error Handling

Implement comprehensive error handling:

```dart
class CRMException implements Exception {
  final String message;
  final int? statusCode;
  
  CRMException(this.message, [this.statusCode]);
  
  @override
  String toString() => message;
}

class NetworkException extends CRMException {
  NetworkException(String message) : super(message);
}

class NotFoundException extends CRMException {
  NotFoundException(String message) : super(message, 404);
}

class UnauthorizedException extends CRMException {
  UnauthorizedException(String message) : super(message, 401);
}
```

## API Endpoints Reference

### Expected Endpoints

Your CRM should provide the following endpoints:

#### 1. Search Customer
```
GET /customers/search?query={phoneOrId}

Response 200:
{
  "customerId": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "address": "string",
  "customerType": "string",
  "lastContact": "ISO8601 date",
  "totalCalls": number,
  "callHistory": [...],
  "recentOrders": [...],
  "accountStatus": "string",
  "totalSpent": number,
  "preferredLanguage": "string",
  "notes": "string"
}

Response 404:
{
  "error": "Customer not found"
}
```

#### 2. Create Customer
```
POST /customers

Request Body:
{
  "firstName": "string",
  "lastName": "string",
  "email": "string",
  "phone": "string",
  "address": "string",
  "city": "string",
  "state": "string",
  "zipCode": "string",
  "country": "string",
  "customerType": "string",
  "notes": "string"
}

Response 201:
{
  "customerId": "string",
  "message": "Customer created successfully"
}
```

#### 3. Update Customer
```
PATCH /customers/{customerId}

Request Body:
{
  "field": "value",
  ...
}

Response 200:
{
  "message": "Customer updated successfully"
}
```

#### 4. Add Call Record
```
POST /customers/{customerId}/calls

Request Body:
{
  "notes": "string",
  "duration": number (seconds),
  "timestamp": "ISO8601 date",
  "type": "Incoming|Outgoing",
  "status": "Completed|Missed|Abandoned"
}

Response 201:
{
  "callId": "string",
  "message": "Call record added"
}
```

## Security Best Practices

### 1. Secure Storage

For storing sensitive data (tokens, API keys), use secure storage:

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

### 2. SSL Pinning

For production, implement SSL pinning to prevent man-in-the-middle attacks:

```dart
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

Dio createSecureDio() {
  final dio = Dio();
  
  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback = (cert, host, port) {
      // Verify certificate fingerprint
      return cert.sha1.toString() == 'YOUR_CERTIFICATE_SHA1';
    };
    return client;
  };
  
  return dio;
}
```

### 3. Request Encryption

For sensitive data, consider encrypting request payloads:

```dart
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final key = Key.fromUtf8('your-32-character-secret-key!!');
  final iv = IV.fromLength(16);
  
  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }
  
  String decrypt(String encrypted) {
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt64(encrypted, iv: iv);
  }
}
```

## Testing

### Unit Tests for CRM Service

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

void main() {
  group('CRMService', () {
    late CRMService service;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      service = CRMService(dio: mockDio);
    });

    test('fetchCustomerData returns customer when found', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
          data: {'customerId': 'test', 'name': 'Test User'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

      final result = await service.fetchCustomerData('+1234567890');
      
      expect(result, isNotNull);
      expect(result!.customerId, 'test');
    });

    test('fetchCustomerData throws when not found', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ));

      expect(
        () => service.fetchCustomerData('+1234567890'),
        throwsException,
      );
    });
  });
}
```

## Monitoring & Logging

Implement logging for debugging and monitoring:

```dart
import 'package:logger/logger.dart';

class CRMService {
  final Logger _logger = Logger();
  
  Future<CRMData?> fetchCustomerData(String phoneOrId) async {
    _logger.i('Fetching customer data for: $phoneOrId');
    
    try {
      final response = await _dio.get('/customers/search');
      _logger.d('Response: ${response.data}');
      return CRMData.fromJson(response.data);
    } catch (e) {
      _logger.e('Error fetching customer: $e');
      rethrow;
    }
  }
}
```

## Performance Optimization

### 1. Caching

Implement caching to reduce API calls:

```dart
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const _cacheExpiry = Duration(minutes: 15);
  
  Future<void> cacheCustomerData(String key, CRMData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data.toJson()));
    await prefs.setString('${key}_timestamp', DateTime.now().toIso8601String());
  }
  
  Future<CRMData?> getCachedCustomerData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString('${key}_timestamp');
    
    if (timestamp != null) {
      final cacheTime = DateTime.parse(timestamp);
      if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
        final data = prefs.getString(key);
        if (data != null) {
          return CRMData.fromJson(jsonDecode(data));
        }
      }
    }
    return null;
  }
}
```

### 2. Request Debouncing

For search functionality, implement debouncing:

```dart
import 'package:rxdart/rxdart.dart';

class SearchService {
  final _searchSubject = PublishSubject<String>();
  
  SearchService() {
    _searchSubject
      .debounceTime(const Duration(milliseconds: 500))
      .distinct()
      .listen((query) async {
        // Perform search
      });
  }
  
  void search(String query) {
    _searchSubject.add(query);
  }
  
  void dispose() {
    _searchSubject.close();
  }
}
```

## Troubleshooting

### Common Issues

1. **SSL Certificate Errors**
   - Verify your API's SSL certificate is valid
   - Check if you need to add custom certificates

2. **CORS Issues** (Web platform)
   - Configure CORS headers on your backend
   - Add allowed origins

3. **Timeout Errors**
   - Increase timeout durations
   - Check network connectivity
   - Verify API endpoint availability

4. **Authentication Failures**
   - Verify credentials
   - Check token expiry
   - Implement token refresh logic

## Support

For additional help with integration:
- Check your CRM API documentation
- Contact your CRM provider's support
- Review Flutter HTTP client documentation
