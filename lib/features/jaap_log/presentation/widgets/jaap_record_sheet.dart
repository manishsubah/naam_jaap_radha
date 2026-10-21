import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/features/jaap_log/domain/ledger.dart';
import 'package:naam_jaap/l10n/l10n.dart';

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

  /// Extra count chanted elsewhere (another counter, a mala) to add on top.
  final _addMore = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void dispose() {
    _count.dispose();
    _addMore.dispose();
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

  void _addToCount() {
    final amount = int.tryParse(_addMore.text.trim()) ?? 0;
    if (amount <= 0) return;
    final current = int.tryParse(_count.text) ?? 0;
    final next = (current + amount).clamp(0, JaapRecordSheet.maxCount);
    setState(() {
      _count.text = '$next';
      _addMore.clear();
    });
  }

  String? _validateCount(String? value) {
    final count = int.tryParse(value?.trim() ?? '');
    final l10n = context.l10n;
    if (count == null || count <= 0) return l10n.recordCountRequired;
    if (count > JaapRecordSheet.maxCount) {
      return l10n.recordCountTooLarge(l10n.numbers.format(JaapRecordSheet.maxCount));
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
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recordDeleteTitle),
        content: Text(l10n.recordDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.commonDelete)),
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
    final l10n = context.l10n;
    final numbers = l10n.numbers;
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
              Text(existing == null ? l10n.recordAddTitle : l10n.recordUpdateTitle,
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                existing == null
                    ? l10n.recordAddSubtitle
                    : l10n.recordUpdateSubtitle(numbers.format(existing)),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              InkWell(
                key: const Key('record-date'),
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.recordDate,
                    suffixIcon: const Icon(Icons.event_rounded),
                  ),
                  child: Text(l10n.formatDate('EEEE, d MMM yyyy', _date)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: const Key('record-naam'),
                initialValue: _naamId,
                decoration: InputDecoration(labelText: l10n.jaapName),
                items: [
                  for (final n in naams) DropdownMenuItem(value: n.id, child: Text(l10n.naamName(n))),
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
                decoration: InputDecoration(labelText: l10n.todaysCount, hintText: '108'),
                validator: _validateCount,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('record-add-more'),
                      controller: _addMore,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.recordAddMore,
                        hintText: l10n.recordAddMoreHint,
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _addToCount(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    key: const Key('record-add-more-button'),
                    tooltip: l10n.recordAddMoreTooltip,
                    onPressed: (int.tryParse(_addMore.text) ?? 0) > 0 ? _addToCount : null,
                    icon: const Icon(Icons.add_rounded),
                  ),
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
                    Expanded(child: Text(l10n.recordTotalUpTo, style: theme.textTheme.bodyMedium)),
                    Text(
                      numbers.format(runningTotal),
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
                label: Text(existing == null ? l10n.recordSave : l10n.recordUpdate),
              ),
              if (existing != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _saving ? null : _delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.recordDelete),
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
