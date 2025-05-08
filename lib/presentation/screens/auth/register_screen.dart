// lib/presentation/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/password_strength_indicator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  
  // مؤشر قوة كلمة المرور
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'ضعيفة';
  Color _passwordStrengthColor = Colors.red;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentStep = 0;
  final List<String> _steps = ['المعلومات الشخصية', 'معلومات الحساب', 'التأكيد'];

  @override
  void initState() {
    super.initState();
    
    // إعداد متحكم الرسوم المتحركة
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
    
    // مراقبة تغييرات كلمة المرور لحساب القوة
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }
  
  void _updatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String strengthText = 'ضعيفة';
    Color strengthColor = Colors.red;
    
    if (password.isEmpty) {
      strength = 0.0;
      strengthText = 'ضعيفة';
      strengthColor = Colors.red;
    } else if (password.length < 6) {
      strength = 0.2;
      strengthText = 'ضعيفة';
      strengthColor = Colors.red;
    } else if (password.length < 8) {
      strength = 0.4;
      strengthText = 'متوسطة';
      strengthColor = Colors.orange;
    } else {
      // تحقق من تعقيد كلمة المرور
      final hasUppercase = password.contains(RegExp(r'[A-Z]'));
      final hasLowercase = password.contains(RegExp(r'[a-z]'));
      final hasDigits = password.contains(RegExp(r'[0-9]'));
      final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      
      final complexity = [hasUppercase, hasLowercase, hasDigits, hasSpecialChars].where((c) => c).length;
      
      if (complexity == 1) {
        strength = 0.4;
        strengthText = 'متوسطة';
        strengthColor = Colors.orange;
      } else if (complexity == 2) {
        strength = 0.6;
        strengthText = 'متوسطة';
        strengthColor = Colors.orange;
      } else if (complexity == 3) {
        strength = 0.8;
        strengthText = 'قوية';
        strengthColor = Colors.green;
      } else if (complexity == 4) {
        strength = 1.0;
        strengthText = 'قوية جداً';
        strengthColor = Colors.green.shade700;
      }
    }
    
    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }
  
  void _nextStep() {
    // تحقق من صحة الخطوة الحالية
    if (_currentStep == 0) {
      if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
        _showError('الرجاء إكمال جميع الحقول المطلوبة');
        return;
      }
    } else if (_currentStep == 1) {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
        _showError('الرجاء إكمال جميع الحقول المطلوبة');
        return;
      }
      
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError('كلمات المرور غير متطابقة');
        return;
      }
      
      if (_passwordStrength < 0.4) {
        _showError('كلمة المرور ضعيفة جداً، الرجاء اختيار كلمة مرور أقوى');
        return;
      }
    }
    
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_acceptTerms) {
      _showError('يجب الموافقة على شروط الاستخدام وسياسة الخصوصية');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (userProvider.error == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الحساب بنجاح'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go('/');
        }
      } else {
        if (mounted) {
          _showError(userProvider.error!);
        }
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _openTermsAndConditions() async {
    final uri = Uri.parse(AppConstants.termsUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError('لا يمكن فتح الرابط');
    }
  }
  
  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(AppConstants.privacyUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError('لا يمكن فتح الرابط');
    }
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة أدوات الاستجابة
    ResponsiveUtils.init(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'إنشاء حساب',
        centerTitle: true,
        automaticallyImplyLeading: _currentStep == 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(
                  PhosphorIcons.caret_left,
                  color: AppColors.primary,
                ),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Stack(
        children: [
          // خلفية مع تدرج
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),
          
          // المحتوى
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // مؤشر الخطوات
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_steps.length * 2 - 1, (index) {
                              // الأرقام الزوجية تمثل الدوائر، الأرقام الفردية تمثل الخطوط
                              if (index.isEven) {
                                final stepIndex = index ~/ 2;
                                final isActive = stepIndex <= _currentStep;
                                final isCompleted = stepIndex < _currentStep;
                                
                                return Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive ? AppColors.primary : Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Icon(
                                            PhosphorIcons.check_bold,
                                            color: Colors.white,
                                            size: 18,
                                          )
                                        : Text(
                                            '${stepIndex + 1}',
                                            style: TextStyle(
                                              color: isActive ? Colors.white : Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              } else {
                                final stepIndex = index ~/ 2;
                                return Expanded(
                                  child: Container(
                                    height: 2,
                                    color: stepIndex < _currentStep ? AppColors.primary : Colors.grey[300],
                                  ),
                                );
                              }
                            }),
                          ),
                        ),
                        
                        // عنوان الخطوة الحالية
                        Center(
                          child: Text(
                            _steps[_currentStep],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // محتوى الخطوة الحالية
                        _buildCurrentStepContent(),
                        
                        const SizedBox(height: 32),
                        
                        // أزرار التنقل بين الخطوات
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentStep > 0)
                              TextButton.icon(
                                onPressed: _previousStep,
                                icon: const Icon(PhosphorIcons.arrow_left),
                                label: const Text('الرجوع'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.textSecondary,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            
                            // زر الخطوة التالية أو التسجيل
                            SizedBox(
                              width: 160,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _currentStep < _steps.length - 1 ? _nextStep : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  _currentStep < _steps.length - 1 ? 'التالي' : 'إنشاء الحساب',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // رابط تسجيل الدخول
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'لديك حساب بالفعل؟',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // مؤشر التحميل
          if (_isLoading)
            const LoadingIndicator(
              isOverlay: true,
              message: 'جاري إنشاء الحساب...',
            ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAccountInfoStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الاسم الكامل
        const Text(
          'أدخل المعلومات الشخصية',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'الاسم الكامل',
            hintText: 'أدخل اسمك الكامل',
            prefixIcon: const Icon(PhosphorIcons.user),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: Validators.validateName,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        
        // رقم الهاتف
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'رقم الهاتف',
            hintText: 'أدخل رقم هاتفك',
            prefixIcon: const Icon(PhosphorIcons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: Validators.validatePhone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildAccountInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أدخل معلومات حسابك',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // البريد الإلكتروني
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'البريد الإلكتروني',
            hintText: 'أدخل بريدك الإلكتروني',
            prefixIcon: const Icon(PhosphorIcons.envelope),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: Validators.validateEmail,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        
        // كلمة المرور
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            hintText: 'أدخل كلمة المرور',
            prefixIcon: const Icon(PhosphorIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? PhosphorIcons.eye_slash
                    : PhosphorIcons.eye,
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: Validators.validatePassword,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 8),
        
        // مؤشر قوة كلمة المرور
        PasswordStrengthIndicator(
          strength: _passwordStrength,
          text: _passwordStrengthText,
          color: _passwordStrengthColor,
        ),
        const SizedBox(height: 16),
        
        // تأكيد كلمة المرور
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            labelText: 'تأكيد كلمة المرور',
            hintText: 'أعد إدخال كلمة المرور',
            prefixIcon: const Icon(PhosphorIcons.lock_key),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? PhosphorIcons.eye_slash
                    : PhosphorIcons.eye,
              ),
              onPressed: _toggleConfirmPasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: (value) {
            if (value != _passwordController.text) {
              return 'كلمات المرور غير متطابقة';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
  
  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تحقق من المعلومات وأكمل التسجيل',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        
        // ملخص البيانات
        Card(
          elevation: 0,
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('الاسم الكامل', _nameController.text),
                const Divider(),
                _buildInfoRow('رقم الهاتف', _phoneController.text),
                const Divider(),
                _buildInfoRow('البريد الإلكتروني', _emailController.text),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // الشروط والأحكام
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أوافق على',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openTermsAndConditions,
                        child: const Text(
                          'شروط الاستخدام',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Text(
                        ' و ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _openPrivacyPolicy,
                        child: const Text(
                          'سياسة الخصوصية',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}