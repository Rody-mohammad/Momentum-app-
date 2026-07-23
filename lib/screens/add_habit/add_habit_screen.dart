import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:momentum/core/theme/app_colors.dart';
import 'package:momentum/models/enums.dart';
import 'package:momentum/providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nameController = TextEditingController();
  HabitCategory _selectedCategory = HabitCategory.health;
  HabitTimeOfDay _selectedTime = HabitTimeOfDay.morning;
  FrequencyType _selectedFrequency = FrequencyType.daily;
  final List<int> _selectedWeeklyDays = [1, 2, 3, 4, 5, 6, 7];
  int _intervalDays = 2;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    if (_selectedFrequency == FrequencyType.weekly && _selectedWeeklyDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day for weekly frequency')),
      );
      return;
    }

    context.read<HabitProvider>().addHabit(
          name: name,
          category: _selectedCategory,
          timeOfDay: _selectedTime,
          frequencyType: _selectedFrequency,
          weeklyDays: _selectedFrequency == FrequencyType.weekly ? _selectedWeeklyDays : const [],
          intervalDays: _selectedFrequency == FrequencyType.interval ? _intervalDays : 1,
          startDate: DateTime.now(),
        );

    context.pop(); // Go back to home screen
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
        title: const Text('New Habit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _saveHabit,
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
              'What do you want to build?',
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
                  borderSide: BorderSide(
                    color: AppColors.accentPrimary,
                    width: 2,
                  ),
                ),
                hintText: 'e.g., Read 10 pages',
                hintStyle: TextStyle(
                  color: textSecondary.withValues(alpha: 0.5),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 40),
            
            // Category Picker
            Text(
              'Category',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildCategoryPicker(surface),
            const SizedBox(height: 40),

            // Time of Day Picker
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

  Widget _buildCategoryPicker(Color surface) {
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
      onSelectionChanged: (Set<HabitTimeOfDay> newSelection) {
        setState(() => _selectedTime = newSelection.first);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentSubtle;
          }
          return surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentPrimary;
          }
          return textSecondary;
        }),
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
            return AppColors.accentSubtle;
          }
          return surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentPrimary;
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