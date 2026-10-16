import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/features/jaap_log/domain/ledger.dart';

/// Opens the form to add or correct the jaap count for one day and naam.
///
/// If a record already exists for the chosen day and naam, the form loads it
/// and saving replaces its count.
Future<void> showJaapRecordSheet(BuildContext context, {DateTime? date, String? naamId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    builder: (_) => JaapRecordSheet(initialDate: date, initialNaamId: naamId),
  );
}

class JaapRecordSheet extends ConsumerStatefulWidget {
  const JaapRecordSheet({super.key, this.initialDate, this.initialNaamId});

  final DateTime? initialDate;
  final String? initialNaamId;

  static const maxCount = 999999;

  @override
  ConsumerState<JaapRecordSheet> createState() => _JaapRecordSheetState();
}

class _JaapRecordSheetState extends ConsumerState<JaapRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _count = TextEditingController();
  late DateTime _date = dayOnly(widget.initialDate ?? DateTime.now());
  late String _naamId = widget.initialNaamId ?? ref.read(selectedNaamProvider).id;
  bool _saving = false;

  /// Count already saved for the chosen day and naam, captured when they're
  /// chosen so the form doesn't change mode while it closes after a save.
  int? _existing;

  static const _quickAdds = [11, 21, 108, 1008];
  final _numbers = NumberFormat.decimalPattern('en_IN');

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  void _loadExisting() {
    _existing = ref.read(jaapEntriesProvider.notifier).entryFor(dateKey(_date), _naamId)?.count;
    _count.text = _existing == null ? '' : '$_existing';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _date = dayOnly(picked);
        _loadExisting();
      });
    }
  }

  void _quickAdd(int amount) {
    final current = int.tryParse(_count.text) ?? 0;
    final next = (current + amount).clamp(0, JaapRecordSheet.maxCount);
    setState(() => _count.text = '$next');
  }

  String? _validateCount(String? value) {
    final count = int.tryParse(value?.trim() ?? '');
    if (count == null || count <= 0) return 'Enter how many times you chanted';
    if (count > JaapRecordSheet.maxCount) {
      return 'That is more than ${_numbers.format(JaapRecordSheet.maxCount)}';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(jaapEntriesProvider.notifier)
        .setCount(dateKey(_date), _naamId, int.parse(_count.text.trim()));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this record?'),
        content: const Text('The count for this day will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(jaapEntriesProvider.notifier).setCount(dateKey(_date), _naamId, 0);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final naams = ref.watch(naamsProvider);
    final entries = ref.watch(jaapEntriesProvider);
    final existing = _existing;
    final count = int.tryParse(_count.text) ?? 0;
    final runningTotal = totalBefore(entries, _naamId, dateKey(_date)) + count;
    if (!naams.any((n) => n.id == _naamId)) _naamId = naams.first.id;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(existing == null ? 'Add jaap record' : 'Update jaap record',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                existing == null
                    ? 'Record how many times you chanted on a day.'
                    : 'This day already has ${_numbers.format(existing)}. Saving replaces it.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              InkWell(
                key: const Key('record-date'),
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.event_rounded),
                  ),
                  child: Text(DateFormat('EEEE, d MMM yyyy').format(_date)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: const Key('record-naam'),
                initialValue: _naamId,
                decoration: const InputDecoration(labelText: 'Jaap name'),
                items: [
                  for (final n in naams) DropdownMenuItem(value: n.id, child: Text(n.name)),
                ],
                onChanged: (v) => setState(() {
                  _naamId = v ?? _naamId;
                  _loadExisting();
                }),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('record-count'),
                controller: _count,
                autofocus: existing == null,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(labelText: 'Daily count', hintText: '108'),
                validator: _validateCount,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final q in _quickAdds)
                    ActionChip(label: Text('+$q'), onPressed: () => _quickAdd(q)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text('Total count up to this day', style: theme.textTheme.bodyMedium)),
                    Text(
                      _numbers.format(runningTotal),
                      key: const Key('record-total'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check_rounded),
                label: Text(existing == null ? 'Save record' : 'Update record'),
              ),
              if (existing != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _saving ? null : _delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete record'),
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
