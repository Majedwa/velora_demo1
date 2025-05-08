// lib/data/repositories/user_repository.dart
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  late final StorageService _storageService;

  UserRepository() {
    _initStorageService();
  }

  Future<void> _initStorageService() async {
    _storageService = await StorageService.getInstance();
  }

  Future<UserModel?> getCurrentUser() async {
    final token = _storageService.getString(AppConstants.userTokenKey);
    if (token == null) return null;

    try {
      final response = await _apiService.get('/user/profile');
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final token = response['token'];
      final user = UserModel.fromJson(response['user']);

      await _storageService.saveString(AppConstants.userTokenKey, token);
      
      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final token = response['token'];
      final user = UserModel.fromJson(response['user']);

      await _storageService.saveString(AppConstants.userTokenKey, token);
      
      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout', {});
      await _storageService.remove(AppConstants.userTokenKey);
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
  
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final response = await _apiService.put('/user/profile', user.toJson());
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
}