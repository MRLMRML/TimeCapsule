import 'package:flutter/material.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';
import 'package:time_capsule/presentation/theme/app_theme.dart';

class CapsuleCard extends StatelessWidget {
  final TimeCapsule capsule;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CapsuleCard({
    super.key,
    required this.capsule,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = capsule.isUnlocked;
    final statusColor = isUnlocked ? AppTheme.unlockedColor : AppTheme.lockedColor;
    final icon = isUnlocked ? Icons.lock_open : Icons.lock;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: isUnlocked ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capsule.isOpened ? capsule.message : 'Tap to open',
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: capsule.isOpened ? 5 : 1,
                      overflow: capsule.isOpened
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          isUnlocked
                              ? 'Ready!'
                              : 'Opens: ${capsule.formattedUnlockTime}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: statusColor,
                              ),
                        ),
                        if (capsule.isOpened) ...[
                          const SizedBox(width: 8),
                          Text(
                            'Opened',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
