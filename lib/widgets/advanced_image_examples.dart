import 'dart:io';
import 'package:flutter/material.dart';
import 'package:event_and_voucher/widgets/advanced_image.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

/// Example usage file for AdvancedImage widget
/// This demonstrates various ways to use the AdvancedImage widget

class AdvancedImageExamples extends StatelessWidget {
  const AdvancedImageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Image Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Network Images'),
          _buildNetworkImageExamples(),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Asset Images'),
          _buildAssetImageExamples(),
          
          const SizedBox(height: 24),
          _buildSectionTitle('File Images'),
          _buildFileImageExamples(),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Circular Images'),
          _buildCircularImageExamples(),
          
          const SizedBox(height: 24),
          _buildSectionTitle('With Custom Styling'),
          _buildStyledImageExamples(),
          
          const SizedBox(height: 24),
          _buildSectionTitle('With Shimmer Effect'),
          _buildShimmerImageExamples(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNetworkImageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic network image
        const Text('Basic Network Image:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          width: 200,
          height: 150,
        ),
        
        const SizedBox(height: 16),
        
        // Network image with custom placeholder
        const Text('With Custom Placeholder:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          width: 200,
          height: 150,
          placeholder: Container(
            color: Colors.grey[200],
            child: const Center(child: Text('Loading...')),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Network image with error fallback
        const Text('With Error Fallback:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://invalid-url.com/image.jpg',
          width: 200,
          height: 150,
          errorImageAsset: 'assets/images/placeholder.png', // Fallback asset
        ),
      ],
    );
  }

  Widget _buildAssetImageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Asset Image:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.asset(
          'assets/images/logo.png',
          width: 200,
          height: 150,
        ),
        
        const SizedBox(height: 16),
        
        // Asset image with error widget
        const Text('With Custom Error Widget:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.asset(
          'assets/non_existent.png',
          width: 200,
          height: 150,
          errorWidget: Container(
            color: Colors.red[100],
            child: const Center(child: Icon(Icons.error)),
          ),
        ),
      ],
    );
  }

  Widget _buildFileImageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('File Image:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        // Note: In real usage, you'd get the file from image picker
        Builder(
          builder: (context) {
            // Example file path - in real app, use actual file
            final exampleFile = File('/path/to/image.jpg');
            if (exampleFile.existsSync()) {
              return AdvancedImageHelper.file(
                exampleFile,
                width: 200,
                height: 150,
              );
            }
            return Container(
              width: 200,
              height: 150,
              color: Colors.grey[200],
              child: const Center(
                child: Text('File not found\n(Example)'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircularImageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Circular Network Image:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://i.pravatar.cc/150?img=12',
          width: 100,
          height: 100,
        ).circular(
          border: Border.all(color: AppTheme.primaryOrange, width: 3),
        ),
        
        const SizedBox(height: 16),
        
        const Text('Circular Asset Image:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.asset(
          'assets/images/profile.png',
          width: 100,
          height: 100,
        ).circular(radius: 50),
      ],
    );
  }

  Widget _buildStyledImageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('With Border Radius & Shadow:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          width: 200,
          height: 150,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        const Text('With Border:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          width: 200,
          height: 150,
          border: Border.all(color: AppTheme.primaryOrange, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        
        const SizedBox(height: 16),
        
        const Text('With Opacity:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          width: 200,
          height: 150,
          opacity: 0.7,
        ),
      ],
    );
  }

  Widget _buildShimmerImageExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('With Shimmer Loading:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        AdvancedImageHelper.network(
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          width: 200,
          height: 150,
          showShimmer: true,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}

/// Quick usage examples as comments:
/// 
/// // 1. Simple network image
/// AdvancedImage.network('https://example.com/image.jpg', width: 200, height: 150)
/// 
/// // 2. Asset image
/// AdvancedImage.asset('assets/images/logo.png', width: 200, height: 150)
/// 
/// // 3. File image
/// AdvancedImage.file(File('/path/to/image.jpg'), width: 200, height: 150)
/// 
/// // 4. Memory image
/// AdvancedImage.memory(bytes, width: 200, height: 150)
/// 
/// // 5. Circular profile image
/// AdvancedImage.network(url, width: 100, height: 100).circular()
/// 
/// // 6. With all options
/// AdvancedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   sourceType: ImageSourceType.networkOrAsset,
///   width: 200,
///   height: 150,
///   fit: BoxFit.cover,
///   borderRadius: BorderRadius.circular(16),
///   border: Border.all(color: Colors.orange),
///   boxShadow: [BoxShadow(...)],
///   showShimmer: true,
///   placeholder: CustomWidget(),
///   errorWidget: CustomErrorWidget(),
///   opacity: 0.9,
///   useCache: true,
/// )

