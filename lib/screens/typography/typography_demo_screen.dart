import 'package:flutter/material.dart';
import 'package:event_and_voucher/theme/app_typography.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class TypographyDemoScreen extends StatelessWidget {
  const TypographyDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Typography'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.textBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typeface Section
            _buildSection(
              title: 'Typeface',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ag',
                    style: AppTypography.heading01.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inter',
                    style: AppTypography.body01.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Heading Section
            _buildSection(
              title: 'Heading',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypographyItem(
                    label: 'Heading 01',
                    style: AppTypography.heading01,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '32px • 48 • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Heading 02',
                    style: AppTypography.heading02,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '20px • 30 • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Heading 03',
                    style: AppTypography.heading03,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '18px • 28 • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Heading 04',
                    style: AppTypography.heading04,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '16px • Auto • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Heading 05',
                    style: AppTypography.heading05,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '14px • Auto • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Heading 06',
                    style: AppTypography.heading06,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • Auto • Semi Bold',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Body Section
            _buildSection(
              title: 'Body',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypographyItem(
                    label: 'Body 01',
                    style: AppTypography.body01,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '14px • 24 • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Body 02',
                    style: AppTypography.body02,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • 22 • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Body 03',
                    style: AppTypography.body03,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • 20 • Medium',
                  ),
                  _buildTypographyItem(
                    label: 'Body 04',
                    style: AppTypography.body04,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • 16 • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Body 05',
                    style: AppTypography.body05,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '10px • Auto • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Body 06',
                    style: AppTypography.body06,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '6px • 10 • Medium',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Button Section
            _buildSection(
              title: 'Button',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypographyItem(
                    label: 'Button 01',
                    style: AppTypography.button01,
                    sampleText: 'Button Text',
                    properties: '14px • 18 • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Button 02',
                    style: AppTypography.button02,
                    sampleText: 'Button Text',
                    properties: '12px • 20 • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Button 03',
                    style: AppTypography.button03,
                    sampleText: 'Button Text',
                    properties: '10px • Auto • Semi Bold',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Caption Section
            _buildSection(
              title: 'Others (Captions)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypographyItem(
                    label: 'Caption 01',
                    style: AppTypography.caption01,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '16px • 24 • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Caption 02',
                    style: AppTypography.caption02,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '14px • Auto • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Caption 03',
                    style: AppTypography.caption03,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • 24 • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Caption 04',
                    style: AppTypography.caption04,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • 16 • Medium',
                  ),
                  _buildTypographyItem(
                    label: 'Caption 05',
                    style: AppTypography.caption05,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '12px • 12 • Regular',
                  ),
                  _buildTypographyItem(
                    label: 'Caption 06',
                    style: AppTypography.caption06,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '10px • Auto • Semi Bold',
                  ),
                  _buildTypographyItem(
                    label: 'Caption 07',
                    style: AppTypography.caption07,
                    sampleText: 'The quick brown fox jumps over the lazy dog',
                    properties: '6px • Auto • Semi Bold',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Usage Examples Section
            _buildSection(
              title: 'Usage Examples',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUsageExample(
                    title: 'Using TypographyText Widget',
                    code: '''
TypographyText(
  text: 'Hello World',
  style: AppTypography.heading01,
  color: AppTheme.primaryOrange,
)
''',
                  ),
                  const SizedBox(height: 16),
                  _buildUsageExample(
                    title: 'Using Predefined Widgets',
                    code: '''
Heading01('Hello World', color: AppTheme.primaryOrange)
Body01('This is body text')
Button01('Click Me')
''',
                  ),
                  const SizedBox(height: 16),
                  _buildUsageExample(
                    title: 'Using TextStyle Directly',
                    code: '''
Text(
  'Hello World',
  style: AppTypography.heading02.copyWith(
    color: AppTheme.primaryOrange,
  ),
)
''',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.heading02.copyWith(
            decoration: TextDecoration.underline,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }

  Widget _buildTypographyItem({
    required String label,
    required TextStyle style,
    required String sampleText,
    required String properties,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: style,
          ),
          const SizedBox(height: 8),
          Text(
            sampleText,
            style: style,
          ),
          const SizedBox(height: 8),
          Text(
            properties,
            style: AppTypography.body05.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageExample({
    required String title,
    required String code,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.body03.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: AppTypography.body04.copyWith(
              fontFamily: 'monospace',
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

