import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;
  // ضبط وضع التطوير للتعامل مع البيانات المحلية بدلاً من الاتصال بالإنترنت
  final bool _isDevelopmentMode = true; // تعيين هذا إلى true للتطوير المحلي
  
  Future<dynamic> get(String endpoint) async {
    if (_isDevelopmentMode) {
      // إرجاع بيانات وهمية للتطوير المحلي
      return _getMockResponse(endpoint);
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<dynamic> post(String endpoint, dynamic body) async {
    if (_isDevelopmentMode) {
      // إرجاع بيانات وهمية للتطوير المحلي
      return _getMockResponse(endpoint);
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<dynamic> put(String endpoint, dynamic body) async {
    if (_isDevelopmentMode) {
      // إرجاع بيانات وهمية للتطوير المحلي
      return _getMockResponse(endpoint);
    }
    
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<dynamic> delete(String endpoint) async {
    if (_isDevelopmentMode) {
      // إرجاع بيانات وهمية للتطوير المحلي
      return _getMockResponse(endpoint);
    }
    
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add authentication token if needed
  };
  
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorizedException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
      default:
        throw ServerException(
          'Error occurred with status code: ${response.statusCode}',
        );
    }
  }
  
  dynamic _handleError(dynamic error) {
    if (error is http.ClientException) {
      throw NetworkException('No internet connection');
    }
    return error;
  }
  
  // إضافة طريقة لإرجاع بيانات وهمية حسب الـ endpoint
  dynamic _getMockResponse(String endpoint) {
    // تأخير افتراضي لمحاكاة طلب الشبكة
    Future.delayed(const Duration(milliseconds: 300));
    
    // يمكن تخصيص البيانات الوهمية حسب الـ endpoint
    if (endpoint.contains('/auth/login')) {
      return {
        'token': 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_1',
          'name': 'مستخدم فيلورا',
          'email': 'user@velora.com',
          'profile_image_url': null,
          'completed_trips': 5,
          'saved_trips': 3,
          'achievements': 2,
          'preferred_language': 'ar',
          'created_at': DateTime.now().toIso8601String(),
        }
      };
    }
    
    if (endpoint.contains('/auth/register')) {
      return {
        'token': 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_2',
          'name': 'مستخدم جديد',
          'email': 'newuser@velora.com',
          'profile_image_url': null,
          'completed_trips': 0,
          'saved_trips': 0,
          'achievements': 0,
          'preferred_language': 'ar',
          'created_at': DateTime.now().toIso8601String(),
        }
      };
    }
    
    if (endpoint.contains('/user/profile')) {
      return {
        'id': 'user_1',
        'name': 'مستخدم فيلورا',
        'email': 'user@velora.com',
        'profile_image_url': null,
        'completed_trips': 5,
        'saved_trips': 3,
        'achievements': 2,
        'preferred_language': 'ar',
        'created_at': DateTime.now().toIso8601String(),
      };
    }
    
    if (endpoint.contains('/auth/logout')) {
      return {
        'status': 'success',
        'message': 'Logged out successfully'
      };
    }
    
    // إرجاع استجابة افتراضية إذا لم يتم العثور على نمط مطابق
    return {'status': 'success', 'message': 'Mock response for $endpoint'};
  }
}

// Custom Exceptions
class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = '', this.prefix]);

  @override
  String toString() {
    return '$prefix$message';
  }
}

class BadRequestException extends AppException {
  BadRequestException([String message = '']) : super(message, 'Invalid Request: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = '']) : super(message, 'Unauthorized: ');
}

class NotFoundException extends AppException {
  NotFoundException([String message = '']) : super(message, 'Not Found: ');
}

class ServerException extends AppException {
  ServerException([String message = '']) : super(message, 'Server Error: ');
}

class NetworkException extends AppException {
  NetworkException([String message = '']) : super(message, 'Network Error: ');
}