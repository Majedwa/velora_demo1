// lib/presentation/widgets/navigation/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../../core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, -1),  // تغيير اتجاه الظل للأعلى
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onItemTapped(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey.shade600,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.house),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.map_trifold),
                label: 'المسارات',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.compass),
                label: 'استكشف',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.map_pin),
                label: 'الخريطة',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.user),
                label: 'الملف',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/paths');
        break;
      case 2:
        context.go('/explore');
        break;
      case 3:
        context.go('/map');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}