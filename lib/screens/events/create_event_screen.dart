import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:event_and_voucher/models/event.dart';
import 'package:event_and_voucher/services/event_service.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  
  File? _coverPhoto;
  List<File> _additionalPhotos = [];
  
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
          if (index < _additionalPhotos.length) {
            _additionalPhotos[index] = File(image.path);
          } else {
            _additionalPhotos.add(File(image.path));
          }
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
      return 'Choose event Date';
    }
    final dateFormat = DateFormat('dd MMMM yyyy');
    return '${_startTime!.format(context)} - ${_endTime!.format(context)}, ${dateFormat.format(_selectedDate!)}';
  }

  Future<void> _publishEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_coverPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a cover photo')),
      );
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

      // Create event (in a real app, you'd upload images first and get URLs)
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _eventNameController.text.trim(),
        description: _eventDescriptionController.text.trim(),
        imageUrl: _coverPhoto!.path, // In production, this would be a URL after upload
        date: eventDateTime,
        venue: '', // You might want to add venue field
        location: '', // You might want to add location field
        price: 0.0, // You might want to add price field
        availableTickets: 0, // You might want to add tickets field
        category: _selectedEventType!,
      );

      // In a real app, you'd call EventService.createEvent(newEvent)
      // For now, we'll just show success and go back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
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
                        'Create New Event',
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
                      GestureDetector(
                        onTap: _pickCoverPhoto,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppTheme.grey,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryOrange,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _coverPhoto != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    _coverPhoto!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppTheme.primaryOrange,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add Cover Photos',
                                      style: TextStyle(
                                        color: AppTheme.primaryOrange,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Additional Photos Section
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final hasPhoto = index < _additionalPhotos.length && _additionalPhotos[index] != null;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap: () => _pickAdditionalPhoto(index),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppTheme.grey,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.primaryOrange,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: hasPhoto
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(
                                            _additionalPhotos[index]!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.add,
                                          color: AppTheme.primaryOrange,
                                          size: 32,
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
                      TextFormField(
                        controller: _eventNameController,
                        decoration: InputDecoration(
                          labelText: 'Event Name*',
                          hintText: 'Type your event name',
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
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Event name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Event Type
                      DropdownButtonFormField<String>(
                        value: _selectedEventType,
                        decoration: InputDecoration(
                          labelText: 'Event Type*',
                          hintText: 'Choose event type',
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

                      const SizedBox(height: 20),

                      // Date and Time
                      GestureDetector(
                        onTap: _selectDateAndTime,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(text: _getDateAndTimeDisplay()),
                            decoration: InputDecoration(
                              labelText: 'Select Date and Time*',
                              hintText: 'Choose event Date',
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

                      const SizedBox(height: 20),

                      // Event Description
                      TextFormField(
                        controller: _eventDescriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Event Description*',
                          hintText: 'Type your event description...',
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
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Event description is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Publish Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _publishEvent,
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
                            'PUBLISH NOW',
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

