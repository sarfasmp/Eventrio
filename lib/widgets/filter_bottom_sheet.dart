import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class FilterData {
  Set<String> selectedCategories = {};
  String? selectedDateOption; // 'today', 'tomorrow', 'this_week', or null for custom
  DateTime? customDate;
  String? location;
  double minPrice = 0;
  double maxPrice = 200;

  FilterData copy() {
    return FilterData()
      ..selectedCategories = Set.from(selectedCategories)
      ..selectedDateOption = selectedDateOption
      ..customDate = customDate
      ..location = location
      ..minPrice = minPrice
      ..maxPrice = maxPrice;
  }

  void reset() {
    selectedCategories.clear();
    selectedDateOption = null;
    customDate = null;
    location = null;
    minPrice = 0;
    maxPrice = 200;
  }
}

class FilterBottomSheet extends StatefulWidget {
  final FilterData initialFilters;
  final Function(FilterData) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterData _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters.copy();
  }

  void _resetFilters() {
    setState(() {
      _filters.reset();
    });
  }

  void _applyFilters() {
    widget.onApply(_filters);
    Navigator.pop(context);
  }

  Future<void> _selectCustomDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filters.customDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _filters.customDate = picked;
        _filters.selectedDateOption = null; // Clear quick option when custom date is selected
      });
    }
  }

  void _selectDateOption(String option) {
    setState(() {
      _filters.selectedDateOption = option;
      _filters.customDate = null; // Clear custom date when quick option is selected
    });
  }

  String _getDateDisplay() {
    if (_filters.selectedDateOption != null) {
      return 'Choose from calender';
    }
    if (_filters.customDate != null) {
      return DateFormat('dd MMMM yyyy').format(_filters.customDate!);
    }
    return 'Choose from calender';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Filter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textBlack,
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Selection
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categoryData.length,
                      itemBuilder: (context, index) {
                        final category = _categoryData[index];
                        final isSelected = _filters.selectedCategories.contains(category['name']);
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _CategoryChip(
                            name: category['name'] as String,
                            icon: category['icon'] as IconData,
                            color: category['color'] as Color,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _filters.selectedCategories.remove(category['name']);
                                } else {
                                  _filters.selectedCategories.add(category['name'] as String);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Time and Date Section
                  const Text(
                    'Time and Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Date Buttons
                  Row(
                    children: [
                      _DateOptionButton(
                        label: 'Today',
                        isSelected: _filters.selectedDateOption == 'today',
                        onTap: () => _selectDateOption('today'),
                      ),
                      const SizedBox(width: 12),
                      _DateOptionButton(
                        label: 'Tomorrow',
                        isSelected: _filters.selectedDateOption == 'tomorrow',
                        onTap: () => _selectDateOption('tomorrow'),
                      ),
                      const SizedBox(width: 12),
                      _DateOptionButton(
                        label: 'This week',
                        isSelected: _filters.selectedDateOption == 'this_week',
                        onTap: () => _selectDateOption('this_week'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Calendar Picker Field
                  GestureDetector(
                    onTap: _selectCustomDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.grey2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppTheme.primaryOrange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getDateDisplay(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: AppTheme.primaryOrange, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Location Section
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {
                      // TODO: Implement location picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Location picker coming soon')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.grey2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _filters.location ?? 'Mirpur 10, Dhaka, Bangladesh',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: AppTheme.primaryOrange, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Price Range Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select price range',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textBlack,
                        ),
                      ),
                      Text(
                        '\$${_filters.minPrice.toInt()}-\$${_filters.maxPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price Range Slider with Visual Bars
                  _PriceRangeSlider(
                    minPrice: _filters.minPrice,
                    maxPrice: _filters.maxPrice,
                    onChanged: (min, max) {
                      setState(() {
                        _filters.minPrice = min;
                        _filters.maxPrice = max;
                      });
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide.none,
                      backgroundColor: AppTheme.primaryOrange.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'RESET',
                      style: TextStyle(
                        color: AppTheme.textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.buttonLinear,
                      foregroundColor: AppTheme.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'APPLY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.name,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOrange : AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryOrange : AppTheme.grey2,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.white : color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? AppTheme.white : Colors.grey[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Date Option Button Widget
class _DateOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateOptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryOrange
                : AppTheme.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.white : Colors.grey[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Price Range Slider Widget
class _PriceRangeSlider extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final Function(double, double) onChanged;

  const _PriceRangeSlider({
    required this.minPrice,
    required this.maxPrice,
    required this.onChanged,
  });

  @override
  State<_PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<_PriceRangeSlider> {
  late double _minPrice;
  late double _maxPrice;
  final double _minValue = 0;
  final double _maxValue = 200;

  @override
  void initState() {
    super.initState();
    _minPrice = widget.minPrice;
    _maxPrice = widget.maxPrice;
  }

  @override
  void didUpdateWidget(_PriceRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minPrice != widget.minPrice || oldWidget.maxPrice != widget.maxPrice) {
      _minPrice = widget.minPrice;
      _maxPrice = widget.maxPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background bars visualization
        SizedBox(
          height: 60,
          child: Row(
            children: List.generate(10, (index) {
              final height = (index % 3 == 0) ? 40.0 : (index % 2 == 0 ? 30.0 : 20.0);
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
                    ),
                  ),
                  height: height,
                ),
              );
            }),
          ),
        ),

        // Slider
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: _minValue,
          max: _maxValue,
          divisions: 200,
          activeColor: AppTheme.primaryOrange,
          inactiveColor: Colors.transparent,
          onChanged: (RangeValues values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
            widget.onChanged(_minPrice, _maxPrice);
          },
        ),
      ],
    );
  }
}

// Category data
final List<Map<String, dynamic>> _categoryData = [
  {'name': 'Design', 'icon': Icons.emoji_events, 'color': Colors.lightBlue},
  {'name': 'Art', 'icon': Icons.palette, 'color': AppTheme.primaryOrange},
  {'name': 'Sports', 'icon': Icons.sports_basketball, 'color': AppTheme.primaryOrange},
  {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.red},
];


