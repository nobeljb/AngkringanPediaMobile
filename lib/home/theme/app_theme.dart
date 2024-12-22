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
}

class AppTheme {
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