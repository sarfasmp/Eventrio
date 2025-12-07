import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_and_voucher/models/event.dart';
import 'package:event_and_voucher/services/event_service.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({
    super.key,
    required this.event,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _eventDescriptionController;
  
  File? _coverPhoto;
  List<File?> _additionalPhotos = List.filled(4, null);
  bool _isCoverPhotoChanged = false;
  
  String? _selectedEventType;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  
  final List<String> _eventTypes = [
    'Music',
    'Art',
    'Sports',
    'Design',
    'Food & Drink',
    'Technology',
    'Entertainment',
  ];
  
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.event.title);
    _eventDescriptionController = TextEditingController(text: widget.event.description);
    _selectedEventType = widget.event.category;
    _selectedDate = widget.event.date;
    
    // Extract time from event date (assuming it's stored)
    _startTime = TimeOfDay.fromDateTime(widget.event.date);
    _endTime = TimeOfDay.fromDateTime(
      widget.event.date.add(const Duration(hours: 8)),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _coverPhoto = File(image.path);
          _isCoverPhotoChanged = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _pickAdditionalPhoto(int index) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _additionalPhotos[index] = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _selectDateAndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedStartTime = await showTimePicker(
        context: context,
        initialTime: _startTime ?? const TimeOfDay(hour: 10, minute: 0),
      );
      
      if (pickedStartTime != null) {
        final TimeOfDay? pickedEndTime = await showTimePicker(
          context: context,
          initialTime: _endTime ?? const TimeOfDay(hour: 18, minute: 0),
        );
        
        if (pickedEndTime != null) {
          setState(() {
            _selectedDate = pickedDate;
            _startTime = pickedStartTime;
            _endTime = pickedEndTime;
          });
        }
      }
    }
  }

  String _getDateAndTimeDisplay() {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      return '10AM - 06 PM, 12 November 2022';
    }
    final dateFormat = DateFormat('dd MMMM yyyy');
    return '${_startTime!.format(context)} - ${_endTime!.format(context)}, ${dateFormat.format(_selectedDate!)}';
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Combine date and start time
      final eventDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      // Update event (in a real app, you'd upload images first and get URLs)
      final updatedEvent = Event(
        id: widget.event.id,
        title: _eventNameController.text.trim(),
        description: _eventDescriptionController.text.trim(),
        imageUrl: _isCoverPhotoChanged && _coverPhoto != null
            ? _coverPhoto!.path
            : widget.event.imageUrl,
        date: eventDateTime,
        venue: widget.event.venue,
        location: widget.event.location,
        price: widget.event.price,
        availableTickets: widget.event.availableTickets,
        category: _selectedEventType!,
      );

      // In a real app, you'd call EventService.updateEvent(widget.event.id, updatedEvent)
      // For now, we'll just show success and go back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating event: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildEditableField({
    required String label,
    required Widget child,
    required VoidCallback onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            child,
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
                onPressed: onEdit,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textBlack),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Edit Event',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover Photo Section
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickCoverPhoto,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _isCoverPhotoChanged && _coverPhoto != null
                                    ? Image.file(
                                        _coverPhoto!,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: widget.event.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.primaryGradient,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(color: Colors.white),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.primaryGradient,
                                          ),
                                          child: const Icon(Icons.event, size: 60, color: Colors.white),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: _pickCoverPhoto,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Additional Photos Section
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            final hasPhoto = _additionalPhotos[index] != null;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap: () => _pickAdditionalPhoto(index),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: hasPhoto
                                        ? Image.file(
                                            _additionalPhotos[index]!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.grey,
                                              border: Border.all(
                                                color: AppTheme.primaryOrange,
                                                width: 2,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: AppTheme.primaryOrange,
                                              size: 32,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Event Details Section
                      const Text(
                        'Event Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textBlack,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Event Name
                      _buildEditableField(
                        label: 'Event Name',
                        child: TextFormField(
                          controller: _eventNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppTheme.grey2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppTheme.grey2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Event name is required';
                            }
                            return null;
                          },
                        ),
                        onEdit: () {
                          // Focus on the field
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),

                      const SizedBox(height: 20),

                      // Event Type
                      _buildEditableField(
                        label: 'Event Type',
                        child: DropdownButtonFormField<String>(
                          value: _selectedEventType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppTheme.grey2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppTheme.grey2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                            ),
                            suffixIcon: const Icon(Icons.keyboard_arrow_down),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          items: _eventTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedEventType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Event type is required';
                            }
                            return null;
                          },
                        ),
                        onEdit: () {
                          // Trigger dropdown
                        },
                      ),

                      const SizedBox(height: 20),

                      // Date and Time
                      _buildEditableField(
                        label: 'Select Date and Time',
                        child: GestureDetector(
                          onTap: _selectDateAndTime,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(text: _getDateAndTimeDisplay()),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: AppTheme.grey2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: AppTheme.grey2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                                ),
                                suffixIcon: const Icon(Icons.calendar_today),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              validator: (value) {
                                if (_selectedDate == null || _startTime == null || _endTime == null) {
                                  return 'Date and time are required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        onEdit: _selectDateAndTime,
                      ),

                      const SizedBox(height: 20),

                      // Event Description
                      _buildEditableField(
                        label: 'Event Description',
                        child: TextFormField(
                          controller: _eventDescriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppTheme.grey2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppTheme.grey2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Event description is required';
                            }
                            return null;
                          },
                        ),
                        onEdit: () {
                          // Focus on the field
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonLinear,
                      foregroundColor: AppTheme.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.white,
                            ),
                          )
                        : const Text(
                            'SAVE CHANGES',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

