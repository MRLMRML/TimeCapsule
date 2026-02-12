import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/presentation/components/capsule_card.dart';
import 'package:time_capsule/presentation/viewmodel/capsule_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CapsuleViewModel>().loadCapsules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CapsuleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Capsules',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/create'),
        label: const Text('Create Capsule'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(CapsuleViewModel viewModel) {
    if (viewModel.isLoading && viewModel.capsules.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.capsules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No time capsules yet.\nCreate your first one!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.capsules.length,
      itemBuilder: (_, index) {
        final capsule = viewModel.capsules[index];
        return CapsuleCard(
          capsule: capsule,
          onTap: capsule.isUnlocked
              ? () {
                  viewModel.openCapsule(capsule.id);
                  context.go('/capsule/${capsule.id}');
                }
              : () {},
          onDelete: () => _showDeleteDialog(context, capsule.id),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Capsule'),
        content: const Text('Are you sure you want to delete this capsule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CapsuleViewModel>().deleteCapsule(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
