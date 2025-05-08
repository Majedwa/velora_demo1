import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Velora',
      'welcome': 'Welcome to Velora',
      'discover_palestine': 'Discover Palestine',
      'home': 'Home',
      'paths': 'Paths',
      'explore': 'Explore',
      'map': 'Map',
      'profile': 'Profile',
      'featured_paths': 'Featured Paths',
      'suggested_adventures': 'Suggested Adventures',
      'search_placeholder': 'Search for a path or place...',
      'view_all': 'View All',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'hours': 'hours',
      'km': 'km',
      'filters': 'Filters',
      'activity_type': 'Activity Type',
      'difficulty_level': 'Difficulty Level',
      'location': 'Location',
      'apply': 'Apply',
      'clear_all': 'Clear All',
      'no_paths_available': 'No paths available',
      'start_journey': 'Start Journey',
      'description': 'Description',
      'available_activities': 'Available Activities',
      'warnings_and_tips': 'Warnings and Tips',
      'rating': 'Rating',
      'reviews': 'reviews',
      'north': 'North',
      'center': 'Center',
      'south': 'South',
      'hiking': 'Hiking',
      'camping': 'Camping',
      'climbing': 'Climbing',
      'religious': 'Religious',
      'cultural': 'Cultural',
      'nature': 'Nature',
      'archaeological': 'Archaeological',
      'my_trips': 'My Trips',
      'saved': 'Saved',
      'achievements': 'Achievements',
      'favorites': 'Favorites',
      'language': 'Language',
      'help_support': 'Help & Support',
      'about_app': 'About App',
      'logout': 'Logout',
      'completed_trips': 'Completed Trips',
      'saved_trips': 'Saved Trips',
      'settings': 'Settings',
    },
    'ar': {
      'app_name': 'Velora',
      'welcome': 'مرحباً في Velora',
      'discover_palestine': 'اكتشف فلسطين',
      'home': 'الرئيسية',
      'paths': 'المسارات',
      'explore': 'استكشف',
      'map': 'الخريطة',
      'profile': 'الملف',
      'featured_paths': 'مسارات مميزة',
      'suggested_adventures': 'مغامرات مقترحة',
      'search_placeholder': 'ابحث عن مسار أو مكان...',
      'view_all': 'عرض الكل',
      'easy': 'سهل',
      'medium': 'متوسط',
      'hard': 'صعب',
      'hours': 'ساعات',
      'km': 'كم',
      'filters': 'الفلاتر',
      'activity_type': 'نوع النشاط',
      'difficulty_level': 'مستوى الصعوبة',
      'location': 'الموقع',
      'apply': 'تطبيق',
      'clear_all': 'مسح الكل',
      'no_paths_available': 'لا توجد مسارات متاحة',
      'start_journey': 'ابدأ الرحلة',
      'description': 'الوصف',
      'available_activities': 'الأنشطة المتاحة',
      'warnings_and_tips': 'تحذيرات وإرشادات',
      'rating': 'التقييم',
      'reviews': 'تقييمات',
      'north': 'الشمال',
      'center': 'الوسط',
      'south': 'الجنوب',
      'hiking': 'المشي',
      'camping': 'التخييم',
      'climbing': 'التسلق',
      'religious': 'ديني',
      'cultural': 'ثقافي',
      'nature': 'طبيعة',
      'archaeological': 'أثري',
      'my_trips': 'رحلاتي',
      'saved': 'المحفوظات',
      'achievements': 'الإنجازات',
      'favorites': 'المفضلة',
      'language': 'اللغة',
      'help_support': 'المساعدة والدعم',
      'about_app': 'عن التطبيق',
      'logout': 'تسجيل الخروج',
      'completed_trips': 'رحلات مكتملة',
      'saved_trips': 'رحلات محفوظة',
      'settings': 'الإعدادات',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}