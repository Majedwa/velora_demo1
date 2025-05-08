import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../providers/paths_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import 'widgets/path_card.dart';
import 'widgets/path_filter_sheet.dart';

class PathsScreen extends StatelessWidget {
  const PathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المسارات'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.funnel),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Consumer<PathsProvider>(
        builder: (context, pathsProvider, child) {
          final paths = pathsProvider.filteredPaths;

          if (paths.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.map_trifold,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد مسارات متاحة',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: paths.length,
            itemBuilder: (context, index) {
              final path = paths[index];
              return PathCard(path: path);
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PathFilterSheet(),
    );
  }
}