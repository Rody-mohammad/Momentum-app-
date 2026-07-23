import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/models/habit.dart';
import 'package:momentum/providers/habit_provider.dart';

class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({super.key, required this.habit});
  final Habit habit;

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  late HabitCategory _selectedCategory;
  late HabitTimeOfDay _selectedTime;
  late FrequencyType _selectedFrequency;
  late List<int> _selectedWeeklyDays;
  late int _intervalDays;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _selectedCategory = widget.habit.category;
    _selectedTime = widget.habit.timeOfDay;
    _selectedFrequency = widget.habit.frequencyType;
    _selectedWeeklyDays = List<int>.from(widget.habit.weeklyDays);
    _intervalDays = widget.habit.intervalDays;
    _startDate = widget.habit.startDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_selectedFrequency == FrequencyType.weekly && _selectedWeeklyDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day for weekly frequency')),
      );
      return;
    }

    context.read<HabitProvider>().updateHabit(
          id: widget.habit.id,
          name: name,
          category: _selectedCategory,
          timeOfDay: _selectedTime,
          frequencyType: _selectedFrequency,
          weeklyDays: _selectedFrequency == FrequencyType.weekly ? _selectedWeeklyDays : const [],
          intervalDays: _selectedFrequency == FrequencyType.interval ? _intervalDays : 1,
          startDate: _startDate,
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.canvas : AppColors.canvasLight;
    final surface = isDark ? AppColors.surface : AppColors.surfaceLight;
    final textPrimary =
        isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('Edit Habit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _saveChanges,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.accentPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Name',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              style: TextStyle(color: textPrimary, fontSize: 20),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: textSecondary),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textSecondary),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.accentPrimary, width: 2),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 40),

            Text(
              'Category',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildCategoryPicker(surface, textSecondary),
            const SizedBox(height: 40),

            Text(
              'Time of Day',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildTimePicker(surface, textSecondary),
            const SizedBox(height: 40),

            // Frequency Picker
            Text(
              'Frequency',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildFrequencySelector(surface, textSecondary),

            if (_selectedFrequency == FrequencyType.weekly) ...[
              const SizedBox(height: 24),
              Text(
                'On Days',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _buildWeeklyDaySelector(surface, textSecondary),
            ] else if (_selectedFrequency == FrequencyType.interval) ...[
              const SizedBox(height: 24),
              Text(
                'Interval',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _buildIntervalStepper(surface, textPrimary, textSecondary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPicker(Color surface, Color textSecondary) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: HabitCategory.values.map((category) {
        final isSelected = _selectedCategory == category;
        final color = AppColors.getCategoryColor(category.index);
        return ChoiceChip(
          label: Text(
            category.name.toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          selected: isSelected,
          selectedColor: color.withValues(alpha: 0.3),
          backgroundColor: surface,
          side: BorderSide(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
          onSelected: (_) => setState(() => _selectedCategory = category),
        );
      }).toList(),
    );
  }

  Widget _buildTimePicker(Color surface, Color textSecondary) {
    return SegmentedButton<HabitTimeOfDay>(
      segments: const [
        ButtonSegment(
          value: HabitTimeOfDay.morning,
          label: Text('AM'),
        ),
        ButtonSegment(
          value: HabitTimeOfDay.afternoon,
          label: Text('PM'),
        ),
        ButtonSegment(
          value: HabitTimeOfDay.evening,
          label: Text('Eve'),
        ),
        ButtonSegment(
          value: HabitTimeOfDay.anytime,
          label: Text('Any'),
        ),
      ],
      selected: {_selectedTime},
      onSelectionChanged: (newSelection) =>
          setState(() => _selectedTime = newSelection.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accentSubtle
              : surface,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accentPrimary
              : textSecondary,
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: textSecondary.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildFrequencySelector(Color surface, Color textSecondary) {
    return SegmentedButton<FrequencyType>(
      segments: const [
        ButtonSegment(
          value: FrequencyType.daily,
          label: Text('Daily'),
        ),
        ButtonSegment(
          value: FrequencyType.weekly,
          label: Text('Weekly'),
        ),
        ButtonSegment(
          value: FrequencyType.interval,
          label: Text('Interval'),
        ),
      ],
      selected: {_selectedFrequency},
      onSelectionChanged: (Set<FrequencyType> newSelection) {
        setState(() => _selectedFrequency = newSelection.first);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryAccent.withValues(alpha: 0.2);
          }
          return surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryAccent;
          }
          return textSecondary;
        }),
        side: WidgetStateProperty.all(
          BorderSide(color: textSecondary.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildWeeklyDaySelector(Color surface, Color textSecondary) {
    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      children: List.generate(7, (index) {
        final dayNum = index + 1;
        final isSelected = _selectedWeeklyDays.contains(dayNum);
        const color = AppColors.accentPrimary;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeeklyDays.remove(dayNum);
                  } else {
                    _selectedWeeklyDays.add(dayNum);
                  }
                });
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected ? color.withValues(alpha: 0.25) : surface,
                    border: Border.all(
                      color: isSelected
                          ? color
                          : textSecondary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      weekdays[index],
                      style: TextStyle(
                        color: isSelected ? color : textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIntervalStepper(Color surface, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Every $_intervalDays days',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _intervalDays > 1
                    ? () => setState(() => _intervalDays--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.accentPrimary,
              ),
              Text(
                '$_intervalDays',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: _intervalDays < 30
                    ? () => setState(() => _intervalDays++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.accentPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}