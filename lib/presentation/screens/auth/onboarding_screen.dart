// lib/presentation/screens/auth/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _currentPage = 0;
  final int _numPages = 3;
  bool _isLastPage = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'استكشف فلسطين',
      'description': 'اكتشف أجمل المسارات والمناطق السياحية في فلسطين، بطريقة سهلة ومبسطة.',
      'image': 'assets/images/onboarding1.png',
      'animation': 'assets/animations/explore.json',
      'color': AppColors.primary,
      'icon': PhosphorIcons.compass
    },
    {
      'title': 'تنوع المسارات',
      'description': 'مجموعة متنوعة من المسارات المناسبة لجميع المستويات والاهتمامات، من المشي البسيط إلى التسلق الصعب.',
      'image': 'assets/images/onboarding2.png',
      'animation': 'assets/animations/hiking.json',
      'color': AppColors.secondary,
      'icon': PhosphorIcons.mountains
    },
    {
      'title': 'خطط رحلتك',
      'description': 'احفظ المسارات المفضلة لديك، واطلع على تفاصيل الطرق والإحداثيات، وشارك تجاربك مع الآخرين.',
      'image': 'assets/images/onboarding3.png',
      'animation': 'assets/animations/plan.json',
      'color': AppColors.tertiary,
      'icon': PhosphorIcons.map_trifold
    },
  ];

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
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = page == _numPages - 1;
    });
  }

  void _nextPage() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }
  
  Future<void> _completeOnboarding() async {
    // حفظ إكمال شاشة التعريف في التخزين المحلي
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompletedKey, true);
    
    // التنقل إلى شاشة تسجيل الدخول
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة أدوات الاستجابة
    ResponsiveUtils.init(context);
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  _onboardingData[_currentPage]['color'].withOpacity(0.1),
                  _onboardingData[_currentPage]['color'].withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // زر التخطي
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedOpacity(
                      opacity: _isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: TextButton(
                        onPressed: _isLastPage ? null : _skipOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: _onboardingData[_currentPage]['color'],
                          backgroundColor: _onboardingData[_currentPage]['color'].withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'تخطي',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // محتوى الصفحات
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _numPages,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // شعار الخطوة
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: data['color'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  data['icon'],
                                  color: data['color'],
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // صورة أو رسوم متحركة
                              Expanded(
                                child: _hasLottieFile(data['animation'])
                                  ? LottieBuilder.asset(
                                      data['animation'],
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset(
                                      data['image'],
                                      fit: BoxFit.contain,
                                    ),
                              ),
                              const SizedBox(height: 40),
                              
                              // العنوان
                              Text(
                                data['title'],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              
                              // الوصف
                              Text(
                                data['description'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // التنقل بين الصفحات
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // مؤشر الصفحات
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _numPages,
                        effect: WormEffect(
                          activeDotColor: _onboardingData[_currentPage]['color'],
                          dotColor: Colors.grey[300]!,
                          dotHeight: 10,
                          dotWidth: 10,
                          type: WormType.thinUnderground,
                        ),
                      ),
                      
                      // زر التالي
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _isLastPage ? 140 : 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _onboardingData[_currentPage]['color'],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: _onboardingData[_currentPage]['color'].withOpacity(0.5),
                          ),
                          child: _isLastPage 
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ابدأ الآن',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    PhosphorIcons.arrow_right,
                                    size: 20,
                                  ),
                                ],
                              )
                            : const Icon(
                                PhosphorIcons.arrow_right,
                                size: 24,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  bool _hasLottieFile(String path) {
    // في التطبيق الحقيقي، يمكن استخدام طريقة أكثر تقدمًا للتحقق
    return path.isNotEmpty && path.endsWith('.json');
  }
}