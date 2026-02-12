import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_capsule/presentation/viewmodel/capsule_viewmodel.dart';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({super.key});

  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final _messageController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CapsuleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Capsule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Write your message...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 24),
            Card(
              child: InkWell(
                onTap: () => _selectDateTime(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Unlock Time',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedDateTime != null
                                ? DateFormat('MMM dd, yyyy at hh:mm a')
                                    .format(_selectedDateTime!)
                                : 'Select date and time',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _canSave()
                  ? () => _createCapsule(viewModel)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: viewModel.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Capsule',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canSave() {
    return _messageController.text.trim().isNotEmpty &&
        _selectedDateTime != null &&
        !(_selectedDateTime!.isBefore(DateTime.now()));
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final minDateTime = now.add(const Duration(minutes: 1));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: minDateTime,
      firstDate: now,
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(minDateTime),
    );

    if (pickedTime == null) return;

    final selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (selected.isAfter(minDateTime)) {
      setState(() => _selectedDateTime = selected);
    }
  }

  void _createCapsule(CapsuleViewModel viewModel) async {
    await viewModel.createCapsule(
      _messageController.text,
      _selectedDateTime!,
    );

    if (mounted && viewModel.error == null) {
      context.pop();
    }
  }
}
