// lib/home/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Main color palette
  static const sageGreen = Color(0xFF8FBC8F);    // Sage Green/Sea Green
  static const darkOliveGreen = Color(0xFF556B2F); // Dark Olive Green
  static const oliveDrab = Color(0xFF6B8E23);     // Olive Drab
  static const honeydew = Color(0xFFF0FFF0);      // Honeydew

  // Functional colors
  static const backgroundColor = honeydew;
  static const buttonColor = oliveDrab;
  static const textHoverPrimary = darkOliveGreen;
  static const textHoverSecondary = sageGreen;
  static const shadowColor = Color(0x1A000000);
  static const overlayColor = Color(0x80556B2F);
  static const cardHoverColor = Color(0xFFF5FFF5);
}
class AppResponsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
      
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
      
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return width * 0.44; // Mobile
    if (width < 1200) return width * 0.3; // Tablet
    return width * 0.2; // Desktop
  }
}
class AppTheme {
  static ThemeData getMobileTheme() {
  final baseTheme = theme;
  return baseTheme.copyWith(
    textTheme: baseTheme.textTheme.copyWith(
      titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
        fontSize: 18,
      ),
      bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
        fontSize: 14,
      ),
    ),
    cardTheme: baseTheme.cardTheme.copyWith(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
    ),
    appBarTheme: baseTheme.appBarTheme.copyWith(
      toolbarHeight: 56,
    ),
  );
}
static BoxDecoration getMobileCardDecoration() {
  return BoxDecoration(
    color: AppColors.honeydew,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

static BoxDecoration getMobileSearchDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
  static ThemeData get theme => ThemeData(
    primaryColor: AppColors.darkOliveGreen,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    
    // Text Theme
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        color: AppColors.darkOliveGreen,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.poppins(
        color: AppColors.darkOliveGreen,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: AppColors.darkOliveGreen,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: AppColors.darkOliveGreen,
      ),
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkOliveGreen,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.honeydew),
      titleTextStyle: TextStyle(
        color: AppColors.honeydew,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.honeydew,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.buttonColor,
      foregroundColor: AppColors.honeydew,
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.honeydew,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.sageGreen),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.sageGreen),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.darkOliveGreen, width: 2),
      ),
      hintStyle: TextStyle(color: AppColors.darkOliveGreen.withOpacity(0.5)),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.darkOliveGreen,
    ),
  );

  // Custom button style for hover effects
  static ButtonStyle getHoverButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return AppColors.textHoverSecondary;
          }
          return AppColors.buttonColor;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return AppColors.textHoverPrimary;
          }
          return AppColors.honeydew;
        },
      ),
    );
  }
}

// Example usage in widgets:

// Custom hover text widget
class HoverText extends StatefulWidget {
  final String text;
  final double fontSize;
  
  const HoverText({
    Key? key, 
    required this.text, 
    this.fontSize = 14,
  }) : super(key: key);

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: isHovered ? AppColors.textHoverSecondary : AppColors.textHoverPrimary,
        ),
      ),
    );
  }
}

// Custom hover icon button
class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  
  const HoverIconButton({
    Key? key, 
    required this.icon, 
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverIconButtonState createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: IconButton(
        icon: Icon(
          widget.icon,
          color: isHovered ? AppColors.textHoverSecondary : AppColors.textHoverPrimary,
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}



