import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

enum ImageSourceType {
  asset,
  network,
  file,
  memory,
  networkOrAsset, // Try network first, fallback to asset
}

class AdvancedImage extends StatelessWidget {
  /// The image source - can be a URL, asset path, file path, or Uint8List
  final String? imageUrl;
  
  /// For memory images (Uint8List)
  final Uint8List? imageBytes;
  
  /// For file images (File)
  final File? imageFile;
  
  /// Type of image source
  final ImageSourceType sourceType;
  
  /// Width of the image
  final double? width;
  
  /// Height of the image
  final double? height;
  
  /// How the image should be inscribed into the available space
  final BoxFit fit;
  
  /// Placeholder widget shown while loading
  final Widget? placeholder;
  
  /// Error widget shown when image fails to load
  final Widget? errorWidget;
  
  /// Background color while loading
  final Color? backgroundColor;
  
  /// Border radius for the image
  final BorderRadius? borderRadius;
  
  /// Border around the image
  final Border? border;
  
  /// Box shadow for the image container
  final List<BoxShadow>? boxShadow;
  
  /// Alignment of the image within its bounds
  final Alignment alignment;
  
  /// Whether to show a shimmer effect while loading
  final bool showShimmer;
  
  /// Color for shimmer effect
  final Color? shimmerColor;
  
  /// Fade in duration for network images
  final Duration fadeInDuration;
  
  /// Fade out duration for network images
  final Duration fadeOutDuration;
  
  /// Cache key for network images (optional, uses URL by default)
  final String? cacheKey;
  
  /// Maximum width for network image cache
  final int? maxWidthDiskCache;
  
  /// Maximum height for network image cache
  final int? maxHeightDiskCache;
  
  /// Error image asset path (fallback when network image fails)
  final String? errorImageAsset;
  
  /// Placeholder image asset path
  final String? placeholderAsset;
  
  /// Whether to use cache for network images
  final bool useCache;
  
  /// Image filter for effects
  final ColorFilter? colorFilter;
  
  /// Opacity of the image
  final double opacity;

  const AdvancedImage({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.imageFile,
    this.sourceType = ImageSourceType.networkOrAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.alignment = const Alignment(0, 0),
    this.showShimmer = false,
    this.shimmerColor,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 100),
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.errorImageAsset,
    this.placeholderAsset,
    this.useCache = true,
    this.colorFilter,
    this.opacity = 1.0,
  }) : assert(
          imageUrl != null || imageBytes != null || imageFile != null,
          'Either imageUrl, imageBytes, or imageFile must be provided',
        );

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget(context);
    
    // Apply opacity
    if (opacity < 1.0) {
      imageWidget = Opacity(opacity: opacity, child: imageWidget);
    }
    
    // Apply color filter
    if (colorFilter != null) {
      imageWidget = ColorFiltered(colorFilter: colorFilter!, child: imageWidget);
    }
    
    // Apply container styling
    if (borderRadius != null || border != null || boxShadow != null || backgroundColor != null) {
      imageWidget = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: imageWidget,
        ),
      );
    }
    
    return imageWidget;
  }

  Widget _buildImageWidget(BuildContext context) {
    switch (sourceType) {
      case ImageSourceType.asset:
        return _buildAssetImage();
      
      case ImageSourceType.network:
        return _buildNetworkImage();
      
      case ImageSourceType.file:
        return _buildFileImage();
      
      case ImageSourceType.memory:
        return _buildMemoryImage();
      
      case ImageSourceType.networkOrAsset:
        return _buildNetworkOrAssetImage();
    }
  }

  Widget _buildAssetImage() {
    if (imageUrl == null) {
      return _buildErrorWidget();
    }

    return Image.asset(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildErrorWidget();
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildNetworkImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    if (!useCache) {
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _buildPlaceholder();
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
      placeholderFadeInDuration: fadeInDuration,
      errorListener: (exception) {
        // Handle error if needed
      },
    );
  }

  Widget _buildFileImage() {
    if (imageFile == null || !imageFile!.existsSync()) {
      return _buildErrorWidget();
    }

    return Image.file(
      imageFile!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildErrorWidget();
      },
    );
  }

  Widget _buildMemoryImage() {
    if (imageBytes == null || imageBytes!.isEmpty) {
      return _buildErrorWidget();
    }

    return Image.memory(
      imageBytes!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildErrorWidget();
      },
    );
  }

  Widget _buildNetworkOrAssetImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    // Check if it's a network URL
    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        cacheKey: cacheKey,
        maxWidthDiskCache: maxWidthDiskCache,
        maxHeightDiskCache: maxHeightDiskCache,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) {
          // Try asset fallback if error image asset is provided
          if (errorImageAsset != null) {
            return Image.asset(
              errorImageAsset!,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
            );
          }
          return errorWidget ?? _buildErrorWidget();
        },
      );
    } else {
      // Treat as asset
      return _buildAssetImage();
    }
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) {
      return SizedBox(
        width: width,
        height: height,
        child: placeholder,
      );
    }

    if (placeholderAsset != null) {
      return Image.asset(
        placeholderAsset!,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (showShimmer) {
      return _buildShimmer();
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: backgroundColor != null
            ? null
            : AppTheme.primaryGradient,
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: SizedBox(
          width: (width != null && width! < 50) ? width! * 0.4 : 24,
          height: (height != null && height! < 50) ? height! * 0.4 : 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              backgroundColor != null ? AppTheme.primaryOrange : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) {
      return SizedBox(
        width: width,
        height: height,
        child: errorWidget,
      );
    }

    if (errorImageAsset != null) {
      return Image.asset(
        errorImageAsset!,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: borderRadius,
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.white,
        size: (width != null && height != null)
            ? (width! < height! ? width! * 0.3 : height! * 0.3)
            : 40,
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: borderRadius,
      ),
      child: _ShimmerEffect(
        baseColor: shimmerColor ?? Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
      ),
    );
  }
}

/// Shimmer effect widget for loading state
class _ShimmerEffect extends StatefulWidget {
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerEffect({
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 - _controller.value * 2, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Helper class with static factory methods for easier usage
class AdvancedImageHelper {
  /// Create from network URL
  static AdvancedImage network(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    Alignment alignment = const Alignment(0, 0),
    bool showShimmer = false,
    Color? shimmerColor,
    Duration fadeInDuration = const Duration(milliseconds: 300),
    Duration fadeOutDuration = const Duration(milliseconds: 100),
    String? cacheKey,
    int? maxWidthDiskCache,
    int? maxHeightDiskCache,
    String? errorImageAsset,
    String? placeholderAsset,
    bool useCache = true,
    ColorFilter? colorFilter,
    double opacity = 1.0,
  }) {
    return AdvancedImage(
      imageUrl: url,
      sourceType: ImageSourceType.network,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
      alignment: alignment,
      showShimmer: showShimmer,
      shimmerColor: shimmerColor,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      errorImageAsset: errorImageAsset,
      placeholderAsset: placeholderAsset,
      useCache: useCache,
      colorFilter: colorFilter,
      opacity: opacity,
    );
  }

  /// Create from asset path
  static AdvancedImage asset(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return AdvancedImage(
      imageUrl: path,
      sourceType: ImageSourceType.asset,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorWidget,
    );
  }

  /// Create from file
  static AdvancedImage file(
    File file, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return AdvancedImage(
      imageFile: file,
      sourceType: ImageSourceType.file,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorWidget,
    );
  }

  /// Create from memory (bytes)
  static AdvancedImage memory(
    Uint8List bytes, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return AdvancedImage(
      imageBytes: bytes,
      sourceType: ImageSourceType.memory,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorWidget,
    );
  }
}

/// Extension methods for AdvancedImage
extension AdvancedImageExtensions on AdvancedImage {
  /// Create circular image
  AdvancedImage circular({
    double? radius,
    Border? border,
  }) {
    final size = radius != null ? radius * 2 : (width ?? height ?? 50);
    return AdvancedImage(
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imageFile: imageFile,
      sourceType: sourceType,
      width: size,
      height: size,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(size / 2),
      border: border,
      boxShadow: boxShadow,
      alignment: alignment,
      showShimmer: showShimmer,
      shimmerColor: shimmerColor,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      errorImageAsset: errorImageAsset,
      placeholderAsset: placeholderAsset,
      useCache: useCache,
      colorFilter: colorFilter,
      opacity: opacity,
    );
  }
}

