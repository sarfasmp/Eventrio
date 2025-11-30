import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:event_and_voucher/providers/auth_provider.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const RegistrationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _validateFirstName(String value) {
    setState(() {
      _isFirstNameValid = value.isNotEmpty;
    });
  }

  void _validateLastName(String value) {
    setState(() {
      _isLastNameValid = value.isNotEmpty;
    });
  }

  void _handleProceed() {
    if (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty) {
      // Complete registration and navigate to home
      ref.read(authProvider.notifier).login();
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                // Title
                const Text(
                  "Let's get to know you",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'We are glad to have you',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                const SizedBox(height: 48),

                // Full Name Section
                Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                // First Name and Last Name Row
                Row(
                  children: [
                    // First Name Field
                    Expanded(
                      child: Stack(
                        children: [
                          TextField(
                            controller: _firstNameController,
                            onChanged: _validateFirstName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'First name',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.normal,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.primaryOrange,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(bottom: 12),
                            ),
                          ),
                          // Checkmark icon for first name
                          if (_isFirstNameValid)
                            const Positioned(
                              right: 0,
                              bottom: 12,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Vertical divider
                    Container(
                      width: 1,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.grey.shade300,
                    ),

                    // Last Name Field
                    Expanded(
                      child: Stack(
                        children: [
                          TextField(
                            controller: _lastNameController,
                            onChanged: _validateLastName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Last name',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.normal,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.primaryOrange,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(bottom: 12),
                            ),
                          ),
                          // Checkmark icon
                          if (_isLastNameValid)
                            const Positioned(
                              right: 0,
                              bottom: 12,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Phone Number Section
                Text(
                  'Phone Number (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                // Phone Number Field (read-only/pre-filled)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: widget.phoneNumber),
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Country flag icon placeholder
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '🇳🇬',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                const SizedBox(height: 32),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isFirstNameValid && _isLastNameValid)
                        ? _handleProceed
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

