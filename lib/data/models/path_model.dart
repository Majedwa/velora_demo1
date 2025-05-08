import 'package:latlong2/latlong.dart';

class PathModel {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String location;
  final String locationAr;
  final List<String> images;
  final double length; // in kilometers
  final Duration estimatedDuration;
  final DifficultyLevel difficulty;
  final List<ActivityType> activities;
  final List<LatLng> coordinates;
  final double rating;
  final int reviewCount;
  final List<String> warnings;
  final List<String> warningsAr;

  PathModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.location,
    required this.locationAr,
    required this.images,
    required this.length,
    required this.estimatedDuration,
    required this.difficulty,
    required this.activities,
    required this.coordinates,
    required this.rating,
    required this.reviewCount,
    required this.warnings,
    required this.warningsAr,
  });
}

enum DifficultyLevel { easy, medium, hard }

enum ActivityType {
  hiking,
  camping,
  climbing,
  religious,
  cultural,
  nature,
  archaeological,
}