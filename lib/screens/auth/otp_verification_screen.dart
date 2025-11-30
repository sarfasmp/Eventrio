import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:event_and_voucher/providers/auth_provider.dart';
import 'package:event_and_voucher/providers/otp_provider.dart';
import 'package:event_and_voucher/widgets/toast.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class OTPVerificationScreen extends ConsumerWidget {
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _OTPVerificationContent(phoneNumber: phoneNumber),
      ),
    );
  }
}

class _OTPVerificationContent extends ConsumerStatefulWidget {
  final String phoneNumber;

  const _OTPVerificationContent({required this.phoneNumber});

  @override
  ConsumerState<_OTPVerificationContent> createState() => _OTPVerificationContentState();
}

class _OTPVerificationContentState extends ConsumerState<_OTPVerificationContent> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {
        _otp = _otpController.text;
      });
      
      if (_otp.length == 6) {
        _verifyOTP(_otp);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeypadInput(String value) {
    if (_otp.length < 6) {
      _otpController.text = _otp + value;
    }
  }

  void _onBackspace() {
    if (_otp.isNotEmpty) {
      _otpController.text = _otp.substring(0, _otp.length - 1);
    }
  }

  Future<void> _verifyOTP(String otp) async {
    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.verifyOTP(otp);

    if (mounted) {
      if (success) {
        // Navigate immediately to home screen
        context.go('/');
      } else {
        _otpController.clear();
        Toast.showError(context, 'Invalid OTP');
      }
    }
  }

  Future<void> _resendOTP() async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.sendOTP(widget.phoneNumber);
    ref.read(otpProvider.notifier).resetResendTimer();
    ref.read(otpProvider.notifier).clearOTP();
    _otpController.clear();
  }

  void _editPhoneNumber() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);
    final authState = ref.watch(authProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Verify your phone number',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Enter the 6-digit code sent to your phone number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                const SizedBox(height: 48),

                // OTP Input Field (masked)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final hasDigit = index < _otp.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: hasDigit ? Colors.black : Colors.transparent,
                            shape: BoxShape.circle,
                            border: hasDigit
                                ? null
                                : Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Hidden text field for OTP input
                Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _otpController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Wrong phone number and Resend row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Wrong phone number? Edit
                    GestureDetector(
                      onTap: _editPhoneNumber,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Wrong phone number? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Resend button
                    if (!otpState.canResend)
                      TextButton(
                        onPressed: null,
                        child: Text(
                          'Resend (${otpState.resendTimer}S)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: _resendOTP,
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                if (authState.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        _NumericKeypad(
          onKeypadInput: _onKeypadInput,
          onBackspace: _onBackspace,
        ),
      ],
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  final Function(String) onKeypadInput;
  final VoidCallback onBackspace;

  const _NumericKeypad({
    required this.onKeypadInput,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            children: [
              _KeypadButton(
                label: '1',
                onTap: () => onKeypadInput('1'),
              ),
              _KeypadButton(
                label: '2',
                subLabel: 'ABC',
                onTap: () => onKeypadInput('2'),
              ),
              _KeypadButton(
                label: '3',
                subLabel: 'DEF',
                onTap: () => onKeypadInput('3'),
              ),
            ],
          ),
          // Row 2: 4, 5, 6
          Row(
            children: [
              _KeypadButton(
                label: '4',
                subLabel: 'GHI',
                onTap: () => onKeypadInput('4'),
              ),
              _KeypadButton(
                label: '5',
                subLabel: 'JKL',
                onTap: () => onKeypadInput('5'),
              ),
              _KeypadButton(
                label: '6',
                subLabel: 'MNO',
                onTap: () => onKeypadInput('6'),
              ),
            ],
          ),
          // Row 3: 7, 8, 9
          Row(
            children: [
              _KeypadButton(
                label: '7',
                subLabel: 'PQRS',
                onTap: () => onKeypadInput('7'),
              ),
              _KeypadButton(
                label: '8',
                subLabel: 'TUV',
                onTap: () => onKeypadInput('8'),
              ),
              _KeypadButton(
                label: '9',
                subLabel: 'WXYZ',
                onTap: () => onKeypadInput('9'),
              ),
            ],
          ),
          // Row 4: 0, Backspace
          Row(
            children: [
              _KeypadButton(
                label: '0',
                onTap: () => onKeypadInput('0'),
              ),
              _KeypadButton(
                icon: Icons.backspace_outlined,
                onTap: onBackspace,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final String? subLabel;
  final IconData? icon;
  final VoidCallback onTap;

  const _KeypadButton({
    this.label,
    this.subLabel,
    this.icon,
    required this.onTap,
  }) : assert(label != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: Colors.black,
                        size: 24,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          if (subLabel != null)
                            Text(
                              subLabel!,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
