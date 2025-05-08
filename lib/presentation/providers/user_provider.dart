// lib/presentation/providers/user_provider.dart
import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isGuest = false;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isGuest => _isGuest;
  
  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _repository.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    _isGuest = false;
    notifyListeners();
    
    try {
      _user = await _repository.login(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    _isGuest = false;
    notifyListeners();
    
    try {
      _user = await _repository.register(name, email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loginAsGuest() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Create a guest user without persisting to backend
      _user = UserModel(
        id: 'guest',
        name: 'ضيف',
        email: 'guest@velora.com',
        createdAt: DateTime.now(),
        completedTrips: 0,
        savedTrips: 0,
        achievements: 0,
        preferredLanguage: 'ar',
      );
      _isGuest = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      _isGuest = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      if (!_isGuest) {
        await _repository.logout();
      }
      _user = null;
      _isGuest = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateProfile(UserModel updatedUser) async {
    if (_isGuest) {
      _error = 'لا يمكن تحديث الملف الشخصي في وضع الضيف';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _repository.updateProfile(updatedUser);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}