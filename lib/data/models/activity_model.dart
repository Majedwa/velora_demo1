import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ActivityModel {
  final String id;
  final String name;
  final String nameAr;
  final IconData icon;
  final Color color;

  ActivityModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.color,
  });

  static List<ActivityModel> getAllActivities() {
    return [
      ActivityModel(
        id: 'hiking',
        name: 'Hiking',
        nameAr: 'المشي',
        icon: PhosphorIcons.person_simple_walk,
        color: Colors.green,
      ),
      ActivityModel(
        id: 'camping',
        name: 'Camping',
        nameAr: 'التخييم',
        icon: PhosphorIcons.campfire_light,
        color: Colors.orange,
      ),
      ActivityModel(
        id: 'climbing',
        name: 'Climbing',
        nameAr: 'التسلق',
        icon: PhosphorIcons.mountains,
        color: Colors.red,
      ),
      ActivityModel(
        id: 'religious',
        name: 'Religious',
        nameAr: 'ديني',
        icon: PhosphorIcons.house,
        color: Colors.purple,
      ),
      ActivityModel(
        id: 'cultural',
        name: 'Cultural',
        nameAr: 'ثقافي',
        icon: PhosphorIcons.buildings,
        color: Colors.blue,
      ),
      ActivityModel(
        id: 'nature',
        name: 'Nature',
        nameAr: 'طبيعة',
        icon: PhosphorIcons.tree,
        color: Colors.teal,
      ),
      ActivityModel(
        id: 'archaeological',
        name: 'Archaeological',
        nameAr: 'أثري',
        icon: PhosphorIcons.compass,
        color: Colors.brown,
      ),
    ];
  }
}