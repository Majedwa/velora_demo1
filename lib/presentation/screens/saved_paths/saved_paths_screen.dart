import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/path_model.dart';
import '../../providers/paths_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../paths/widgets/path_card.dart';

class SavedPathsScreen extends StatelessWidget {
  const SavedPathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual saved paths provider
    final pathsProvider = Provider.of<PathsProvider>(context);
    final isLoading = pathsProvider.isLoading;
    final error = pathsProvider.error;
    
    // For now, we'll just use a subset of all paths as "saved" paths
    // This should be replaced with actual saved paths functionality
    final savedPaths = pathsProvider.paths.take(3).toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'المسارات المحفوظة',
      ),
      body: _buildBody(
        context,
        isLoading: isLoading,
        error: error,
        savedPaths: savedPaths,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required bool isLoading,
    required String? error,
    required List<PathModel> savedPaths,
  }) {
    if (isLoading) {
      return const LoadingIndicator();
    }

    if (error != null) {
      return CustomErrorWidget(
        message: error,
        onRetry: () {
          // TODO: Implement retry functionality
        },
      );
    }

    if (savedPaths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.bookmark_simple,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد مسارات محفوظة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'استكشف المسارات واحفظها للوصول إليها بسهولة لاحقًا',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/paths');
              },
              icon: const Icon(PhosphorIcons.map_trifold),
              label: const Text('استكشف المسارات'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savedPaths.length,
      itemBuilder: (context, index) {
        final path = savedPaths[index];
        return Dismissible(
          key: Key(path.id),
          background: Container(
            color: AppColors.error,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(
              PhosphorIcons.trash,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            // TODO: Implement remove saved path functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تمت إزالة ${path.nameAr} من المسارات المحفوظة'),
                action: SnackBarAction(
                  label: 'تراجع',
                  onPressed: () {
                    // TODO: Implement undo functionality
                  },
                ),
              ),
            );
          },
          child: PathCard(
            path: path,
            onTap: () => context.go('/paths/${path.id}'),
          ),
        );
      },
    );
  }
}