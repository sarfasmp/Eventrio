import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

/// Advanced Typography System based on Inter font family
/// Implements all typography styles: Heading, Body, Button, and Caption
class AppTypography {
  // Font Family
  static const String fontFamily = 'Urbanist';
  
  // Get Inter font
  static TextStyle _urbanist({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.urbanist(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height != null ? height / fontSize : null,
      letterSpacing: letterSpacing ?? 0,
      color: color ?? AppTheme.textBlack,
    );
  }

  // ==================== HEADING STYLES ====================
  
  /// Heading 01: 32px, Line Height: 48, Semi Bold
  static TextStyle get heading01 => _urbanist(
    fontSize: 32,
    fontWeight: FontWeight.w600, // Semi Bold
    height: 48,
    letterSpacing: 0,
  );

  /// Heading 02: 20px, Line Height: 30, Semi Bold
  static TextStyle get heading02 => _urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 30,
    letterSpacing: 0,
  );

  /// Heading 03: 18px, Line Height: 28, Semi Bold
  static TextStyle get heading03 => _urbanist(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 28,
    letterSpacing: 0,
  );

  /// Heading 04: 16px, Line Height: Auto, Semi Bold
  static TextStyle get heading04 => _urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Heading 05: 14px, Line Height: Auto, Semi Bold
  static TextStyle get heading05 => _urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Heading 06: 12px, Line Height: Auto, Semi Bold
  static TextStyle get heading06 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // ==================== BODY STYLES ====================
  
  /// Body 01: 14px, Line Height: 24, Regular
  static TextStyle get body01 => _urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 24,
    letterSpacing: 0,
  );

  /// Body 02: 12px, Line Height: 22, Regular
  static TextStyle get body02 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 22,
    letterSpacing: 0,
  );

  /// Body 03: 12px, Line Height: 20, Medium
  static TextStyle get body03 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    height: 20,
    letterSpacing: 0,
  );

  /// Body 04: 12px, Line Height: 16, Regular
  static TextStyle get body04 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16,
    letterSpacing: 0,
  );

  /// Body 05: 10px, Line Height: Auto, Regular
  static TextStyle get body05 => _urbanist(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Body 06: 6px, Line Height: 10, Medium
  static TextStyle get body06 => _urbanist(
    fontSize: 6,
    fontWeight: FontWeight.w500,
    height: 10,
    letterSpacing: 0,
  );

  // ==================== BUTTON STYLES ====================
  
  /// Button 01: 14px, Line Height: 18, Semi Bold
  static TextStyle get button01 => _urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 18,
    letterSpacing: 0,
  );

  /// Button 02: 12px, Line Height: 20, Semi Bold
  static TextStyle get button02 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 20,
    letterSpacing: 0,
  );

  /// Button 03: 10px, Line Height: Auto, Semi Bold
  static TextStyle get button03 => _urbanist(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // ==================== CAPTION STYLES ====================
  
  /// Caption 01: 16px, Line Height: 24, Regular
  static TextStyle get caption01 => _urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24,
    letterSpacing: 0,
  );

  /// Caption 02: 14px, Line Height: Auto, Regular
  static TextStyle get caption02 => _urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Caption 03: 12px, Line Height: 24, Semi Bold
  static TextStyle get caption03 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 24,
    letterSpacing: 0,
  );

  /// Caption 04: 12px, Line Height: 16, Medium
  static TextStyle get caption04 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16,
    letterSpacing: 0,
  );

  /// Caption 05: 12px, Line Height: 12, Regular
  static TextStyle get caption05 => _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 12,
    letterSpacing: 0,
  );

  /// Caption 06: 10px, Line Height: Auto, Semi Bold
  static TextStyle get caption06 => _urbanist(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Caption 07: 6px, Line Height: Auto, Semi Bold
  static TextStyle get caption07 => _urbanist(
    fontSize: 6,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // ==================== HELPER METHODS ====================
  
  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply opacity to any text style
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: (style.color ?? AppTheme.textBlack).withValues(alpha: opacity));
  }

  /// Apply custom letter spacing
  static TextStyle withLetterSpacing(TextStyle style, double letterSpacing) {
    return style.copyWith(letterSpacing: letterSpacing);
  }
}

/// Typography Widget for easy usage
class TypographyText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const TypographyText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: color != null ? style.copyWith(color: color) : style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Predefined Typography Widgets for each style
class Heading01 extends TypographyText {
  Heading01(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.heading01);
}

class Heading02 extends TypographyText {
  Heading02(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.heading02);
}

class Heading03 extends TypographyText {
  Heading03(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.heading03);
}

class Heading04 extends TypographyText {
  Heading04(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.heading04);
}

class Heading05 extends TypographyText {
  Heading05(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.heading05);
}

class Heading06 extends TypographyText {
  Heading06(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.heading06);
}

class Body01 extends TypographyText {
  Body01(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.body01);
}

class Body02 extends TypographyText {
  Body02(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.body02);
}

class Body03 extends TypographyText {
  Body03(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.body03);
}

class Body04 extends TypographyText {
  Body04(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.body04);
}

class Body05 extends TypographyText {
  Body05(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.body05);
}

class Body06 extends TypographyText {
  Body06(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.body06);
}

class Button01 extends TypographyText {
  Button01(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.button01);
}

class Button02 extends TypographyText {
  Button02(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.button02);
}

class Button03 extends TypographyText {
  Button03(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.button03);
}

class Caption01 extends TypographyText {
  Caption01(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption01);
}

class Caption02 extends TypographyText {
  Caption02(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption02);
}

class Caption03 extends TypographyText {
  Caption03(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption03);
}

class Caption04 extends TypographyText {
  Caption04(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption04);
}

class Caption05 extends TypographyText {
  Caption05(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption05);
}

class Caption06 extends TypographyText {
  Caption06(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption06);
}

class Caption07 extends TypographyText {
  Caption07(
    String text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
  }) : super(text: text, style: AppTypography.caption07);
}

