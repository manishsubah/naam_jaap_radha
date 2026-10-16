import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/data/providers/providers.dart';

Future<void> showManualEntrySheet(BuildContext context, {DateTime? date}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => ManualEntrySheet(initialDate: date),
  );
}

class ManualEntrySheet extends ConsumerStatefulWidget {
  const ManualEntrySheet({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  ConsumerState<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends ConsumerState<ManualEntrySheet> {
  final _controller = TextEditingController();
  late String _naamId = ref.read(selectedNaamProvider).id;
  late DateTime _date = widget.initialDate ?? DateTime.now();

  static const _quickCounts = [11, 21, 108, 1008];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final count = int.tryParse(_controller.text.trim()) ?? 0;
    if (count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter how many times you chanted')),
      );
      return;
    }
    await ref.read(jaapEntriesProvider.notifier).addCount(_naamId, count, date: _date);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final naams = ref.watch(naamsProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add jaap count', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Chanted with a physical mala or elsewhere? Add it here.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _naamId,
            decoration: const InputDecoration(labelText: 'Naam'),
            items: [
              for (final n in naams) DropdownMenuItem(value: n.id, child: Text(n.name)),
            ],
            onChanged: (v) => setState(() => _naamId = v ?? _naamId),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Count', hintText: 'e.g. 108'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final q in _quickCounts)
                ActionChip(label: Text('$q'), onPressed: () => _controller.text = '$q'),
            ],
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_rounded),
            title: Text(DateFormat('EEEE, d MMM yyyy').format(_date)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Add to my jaap'),
          ),
        ],
      ),
    );
  }
}
