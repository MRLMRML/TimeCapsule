import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/presentation/theme/app_theme.dart';
import 'package:time_capsule/presentation/viewmodel/capsule_viewmodel.dart';

class CapsuleDetailScreen extends StatefulWidget {
  final String capsuleId;

  const CapsuleDetailScreen({super.key, required this.capsuleId});

  @override
  State<CapsuleDetailScreen> createState() => _CapsuleDetailScreenState();
}

class _CapsuleDetailScreenState extends State<CapsuleDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CapsuleViewModel>().loadCapsuleById(widget.capsuleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CapsuleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.selectedCapsule?.isOpened == true
            ? 'Your Message'
            : 'Time Capsule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.clearSelectedCapsule();
            context.pop();
          },
        ),
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(CapsuleViewModel viewModel) {
    final capsule = viewModel.selectedCapsule;

    if (capsule == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isUnlocked = capsule.isUnlocked;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (isUnlocked ? AppTheme.unlockedColor : AppTheme.lockedColor)
                    .withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnlocked ? Icons.lock_open : Icons.lock,
                size: 60,
                color: isUnlocked ? AppTheme.unlockedColor : AppTheme.lockedColor,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      isUnlocked
                          ? 'Your Future Self Says:'
                          : 'Message from the Past',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (isUnlocked) ...[
                      Text(
                        capsule.message,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      Column(
                        children: [
                          Icon(
                            Icons.lock,
                            size: 32,
                            color: AppTheme.lockedColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'This capsule is locked until\n\n${capsule.formattedUnlockTime}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'Created: ${capsule.createdFormatted}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
