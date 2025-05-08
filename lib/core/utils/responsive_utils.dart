// lib/core/utils/responsive_utils.dart
import 'package:flutter/material.dart';

class ResponsiveUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  
  // معايير الأجهزة
  static late bool isMobile;
  static late bool isTablet;
  static late bool isDesktop;
  
  // حجم الخط
  static late double defaultTextSize;
  static late double smallTextSize;
  static late double mediumTextSize;
  static late double largeTextSize;
  
  // المساحات
  static late double defaultSpace;
  static late double extraSmallSpace;
  static late double smallSpace;
  static late double mediumSpace;
  static late double largeSpace;
  static late double extraLargeSpace;
  
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    
    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    
    // تحديد نوع الجهاز
    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1200;
    isDesktop = screenWidth >= 1200;
    
    // حجم الخط
    defaultTextSize = isMobile ? 14 : isTablet ? 16 : 18;
    smallTextSize = isMobile ? 12 : isTablet ? 14 : 16;
    mediumTextSize = isMobile ? 16 : isTablet ? 18 : 20;
    largeTextSize = isMobile ? 20 : isTablet ? 24 : 28;
    
    // المساحات
    extraSmallSpace = isMobile ? 4 : isTablet ? 6 : 8;
    smallSpace = isMobile ? 8 : isTablet ? 12 : 16;
    defaultSpace = isMobile ? 16 : isTablet ? 20 : 24;
    mediumSpace = isMobile ? 24 : isTablet ? 32 : 40;
    largeSpace = isMobile ? 32 : isTablet ? 48 : 64;
    extraLargeSpace = isMobile ? 48 : isTablet ? 64 : 80;
  }
  
  static double getResponsiveWidth(double percentage) {
    return safeBlockHorizontal * percentage;
  }

  static double getResponsiveHeight(double percentage) {
    return safeBlockVertical * percentage;
  }
  
  static EdgeInsets getResponsivePadding({
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left != null ? getResponsiveWidth(left) : (horizontal != null ? getResponsiveWidth(horizontal) : 0),
      right: right != null ? getResponsiveWidth(right) : (horizontal != null ? getResponsiveWidth(horizontal) : 0),
      top: top != null ? getResponsiveHeight(top) : (vertical != null ? getResponsiveHeight(vertical) : 0),
      bottom: bottom != null ? getResponsiveHeight(bottom) : (vertical != null ? getResponsiveHeight(vertical) : 0),
    );
  }
  
  static double getResponsiveFontSize(double size) {
    double finalSize = safeBlockHorizontal * size;
    
    // تحديد حد أدنى وحد أقصى لحجم الخط
    if (finalSize < 12) {
      finalSize = 12;
    } else if (finalSize > 32) {
      finalSize = 32;
    }
    
    return finalSize;
  }
}

// امتداد لسهولة استخدام الأدوات المساعدة
extension ResponsiveExtension on BuildContext {
  // احصل على قيم الاستجابة
  double get screenWidth => ResponsiveUtils.screenWidth;
  double get screenHeight => ResponsiveUtils.screenHeight;
  
  // تحقق من نوع الجهاز
  bool get isMobile => ResponsiveUtils.isMobile;
  bool get isTablet => ResponsiveUtils.isTablet;
  bool get isDesktop => ResponsiveUtils.isDesktop;
  
  // احصل على المساحات
  double get xs => ResponsiveUtils.extraSmallSpace;
  double get sm => ResponsiveUtils.smallSpace;
  double get md => ResponsiveUtils.mediumSpace;
  double get lg => ResponsiveUtils.largeSpace;
  double get xl => ResponsiveUtils.extraLargeSpace;
  
  // احصل على أحجام الخطوط
  double get textSm => ResponsiveUtils.smallTextSize;
  double get textMd => ResponsiveUtils.mediumTextSize;
  double get textLg => ResponsiveUtils.largeTextSize;
  
  // طرق مساعدة
  double rw(double percentage) => ResponsiveUtils.getResponsiveWidth(percentage);
  double rh(double percentage) => ResponsiveUtils.getResponsiveHeight(percentage);
  double fontSize(double size) => ResponsiveUtils.getResponsiveFontSize(size);
  
  // الحصول على padding متجاوب
  EdgeInsets padding({
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return ResponsiveUtils.getResponsivePadding(
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    );
  }
}