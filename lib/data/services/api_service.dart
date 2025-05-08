import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;
  
  Future<dynamic> get(String endpoint) async {
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