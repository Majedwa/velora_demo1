// lib/presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/localization/language_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../providers/user_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String _appVersion = '';
  final double _switchScale = 0.8;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
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
    
    _getAppVersion();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _showResetConfirmation(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين الإعدادات'),
        content: const Text('هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى الوضع الافتراضي؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              settingsProvider.resetSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم إعادة تعيين الإعدادات'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = true;
              });
              
              try {
                await userProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('حدث خطأ: $e'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _openWebsite(String url) async {
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لا يمكن فتح الرابط'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
  
  Future<void> _sendEmail() async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: AppConstants.appEmail,
      queryParameters: {
        'subject': 'استفسار حول تطبيق Velora',
        'body': 'مرحباً، لدي استفسار حول تطبيق Velora...\n',
      },
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لا يمكن فتح تطبيق البريد الإلكتروني'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
  
  Future<void> _showAboutApp() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              AppConstants.logoPath,
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 12),
            const Text('عن التطبيق'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Velora - اكتشف فلسطين',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'الإصدار: $_appVersion',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Velora هو تطبيق لاستكشاف المسارات والأماكن السياحية في فلسطين. يهدف التطبيق إلى تسهيل عملية اكتشاف الأماكن الجميلة والتاريخية في فلسطين وتوفير معلومات مفصلة عن المسارات المختلفة.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© ${DateTime.now().year} Velora Team. جميع الحقوق محفوظة.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _openWebsite(AppConstants.termsUrl),
            icon: const Icon(
              PhosphorIcons.file_text,
              size: 16,
            ),
            label: const Text('الشروط والأحكام'),
          ),
          TextButton.icon(
            onPressed: () => _openWebsite(AppConstants.privacyUrl),
            icon: const Icon(
              PhosphorIcons.shield,
              size: 16,
            ),
            label: const Text('سياسة الخصوصية'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة أدوات الاستجابة
    ResponsiveUtils.init(context);
    
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    final bool isGuest = userProvider.isGuest;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'الإعدادات',
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.info),
            onPressed: _showAboutApp,
          ),
        ],
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // قسم الحساب
                _buildSectionHeader(context, title: 'الحساب', icon: PhosphorIcons.user_circle),
                _buildSettingsCard(
                  context,
                  children: [
                    // معلومات المستخدم
                    if (userProvider.user != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // صورة المستخدم
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary,
                              child: userProvider.user!.profileImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.network(
                                      userProvider.user!.profileImageUrl!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    userProvider.user!.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                            const SizedBox(width: 16),
                            
                            // معلومات المستخدم
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userProvider.user!.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    userProvider.user!.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // زر تعديل الملف الشخصي
                            IconButton(
                              icon: const Icon(
                                PhosphorIcons.pencil_simple,
                                color: AppColors.primary,
                              ),
                              onPressed: isGuest ? null : () {
                                // تعديل الملف الشخصي
                              },
                              tooltip: 'تعديل الملف الشخصي',
                            ),
                          ],
                        ),
                      ),
                    
                    // تعديل الملف الشخصي
                    _SettingItem(
                      title: 'تعديل الملف الشخصي',
                      subtitle: 'تحديث المعلومات الشخصية وصورة الملف',
                      icon: PhosphorIcons.user_focus,
                      onTap: isGuest ? null : () {
                        // تعديل الملف الشخصي
                      },
                      enabled: !isGuest,
                    ),
                    const Divider(),
                    
                    // تغيير كلمة المرور
                    _SettingItem(
                      title: 'تغيير كلمة المرور',
                      subtitle: 'تحديث كلمة المرور الخاصة بك',
                      icon: PhosphorIcons.lock_key,
                      onTap: isGuest ? null : () {
                        // تغيير كلمة المرور
                      },
                      enabled: !isGuest,
                    ),
                    const Divider(),
                    
                    // اللغة
                    _SettingItem(
                      title: 'اللغة',
                      subtitle: 'تغيير لغة التطبيق',
                      icon: PhosphorIcons.translate,
                      trailing: DropdownButton<String>(
                        value: languageProvider.currentLanguage,
                        underline: const SizedBox(),
                        icon: const Icon(
                          PhosphorIcons.caret_down,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'ar',
                            child: Text('العربية'),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('English'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            HapticFeedback.mediumImpact();
                            languageProvider.changeLanguage(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // قسم التطبيق
                _buildSectionHeader(context, title: 'إعدادات التطبيق', icon: PhosphorIcons.gear),
                _buildSettingsCard(
                  context,
                  children: [
                    // الإشعارات
                    _SettingItem(
                      title: 'الإشعارات',
                      subtitle: 'تفعيل/تعطيل الإشعارات',
                      icon: PhosphorIcons.bell,
                      trailing: Transform.scale(
                        scale: _switchScale,
                        child: CustomSwitch(
                          value: settingsProvider.notificationsEnabled,
                          onChanged: (value) {
                            HapticFeedback.mediumImpact();
                            settingsProvider.setNotificationsEnabled(value);
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ),
                    const Divider(),
                    
                    // الوضع الداكن
                    _SettingItem(
                      title: 'الوضع الداكن',
                      subtitle: 'تفعيل/تعطيل الوضع الداكن',
                      icon: PhosphorIcons.moon,
                      trailing: Transform.scale(
                        scale: _switchScale,
                        child: CustomSwitch(
                          value: settingsProvider.darkModeEnabled,
                          onChanged: (value) {
                            HapticFeedback.mediumImpact();
                            settingsProvider.setDarkModeEnabled(value);
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ),
                    const Divider(),
                    
                    // نوع الخريطة
                    _SettingItem(
                      title: 'نوع الخريطة',
                      subtitle: 'اختيار نوع الخريطة المفضل',
                      icon: PhosphorIcons.map_trifold,
                      trailing: DropdownButton<String>(
                        value: settingsProvider.mapType,
                        underline: const SizedBox(),
                        icon: const Icon(
                          PhosphorIcons.caret_down,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'standard',
                            child: Text('قياسية'),
                          ),
                          DropdownMenuItem(
                            value: 'satellite',
                            child: Text('صناعية'),
                          ),
                          DropdownMenuItem(
                            value: 'terrain',
                            child: Text('تضاريس'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            HapticFeedback.mediumImpact();
                            settingsProvider.setMapType(value);
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    
                    // وحدة قياس درجة الحرارة
                    _SettingItem(
                      title: 'وحدة درجة الحرارة',
                      subtitle: 'تغيير وحدة قياس درجة الحرارة',
                      icon: PhosphorIcons.thermometer,
                      trailing: DropdownButton<bool>(
                        value: settingsProvider.useCelsius,
                        underline: const SizedBox(),
                        icon: const Icon(
                          PhosphorIcons.caret_down,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: true,
                            child: Text('سيلسيوس (°C)'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('فهرنهايت (°F)'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            HapticFeedback.mediumImpact();
                            settingsProvider.setUseCelsius(value);
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    
                    // خدمات الموقع
                    _SettingItem(
                      title: 'خدمات الموقع',
                      subtitle: 'السماح بالوصول إلى موقعك',
                      icon: PhosphorIcons.map_pin,
                      trailing: Transform.scale(
                        scale: _switchScale,
                        child: CustomSwitch(
                          value: settingsProvider.locationEnabled,
                          onChanged: (value) {
                            HapticFeedback.mediumImpact();
                            settingsProvider.setLocationEnabled(value);
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ),
                    const Divider(),
                    
                    // حد سجل البحث
                    _SettingItem(
                      title: 'سجل البحث',
                      subtitle: 'عدد العناصر المحفوظة في سجل البحث',
                      icon: PhosphorIcons.clock_counter_clockwise,
                      trailing: DropdownButton<int>(
                        value: settingsProvider.searchHistoryLimit,
                        underline: const SizedBox(),
                        icon: const Icon(
                          PhosphorIcons.caret_down,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 5,
                            child: Text('5 عناصر'),
                          ),
                          DropdownMenuItem(
                            value: 10,
                            child: Text('10 عناصر'),
                          ),
                          DropdownMenuItem(
                            value: 20,
                            child: Text('20 عنصر'),
                          ),
                          DropdownMenuItem(
                            value: 0,
                            child: Text('لا يوجد'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            HapticFeedback.mediumImpact();
                            settingsProvider.setSearchHistoryLimit(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // قسم الدعم
                _buildSectionHeader(context, title: 'الدعم', icon: PhosphorIcons.question),
                _buildSettingsCard(
                  context,
                  children: [
                    // المساعدة والأسئلة الشائعة
                    _SettingItem(
                      title: 'المساعدة والأسئلة الشائعة',
                      subtitle: 'الحصول على مساعدة حول استخدام التطبيق',
                      icon: PhosphorIcons.info,
                      onTap: () => _openWebsite(AppConstants.faqUrl),
                    ),
                    const Divider(),
                    
                    // الإبلاغ عن مشكلة
                    _SettingItem(
                      title: 'الإبلاغ عن مشكلة',
                      subtitle: 'إرسال تقرير عن مشكلة تواجهها',
                      icon: PhosphorIcons.warning,
                      onTap: _sendEmail,
                    ),
                    const Divider(),
                    
                    // عن التطبيق
                    _SettingItem(
                      title: 'عن التطبيق',
                      subtitle: 'معلومات عن التطبيق والإصدار',
                      icon: PhosphorIcons.info,
                      trailing: Text(
                        'الإصدار $_appVersion',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      onTap: _showAboutApp,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // إعادة تعيين الإعدادات
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showResetConfirmation(context, settingsProvider);
                    },
                    icon: const Icon(PhosphorIcons.arrows_clockwise),
                    label: const Text('إعادة تعيين الإعدادات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // تسجيل الخروج
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showLogoutConfirmation(context);
                    },
                    icon: const Icon(PhosphorIcons.sign_out),
                    label: const Text('تسجيل الخروج'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withOpacity(0.1),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          
          // مؤشر التحميل
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: trailing ?? (onTap != null
            ? Icon(
                PhosphorIcons.caret_right,
                color: AppColors.textSecondary,
              )
            : null),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}