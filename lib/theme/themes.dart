import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final LinearGradient? backgroundGradient;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? borderColor;
  final Color? dartsTextColor;
  final Color? dartsBGColor;
  final Color? cardBackgroundColor;
  final Color? cardTextColor;

  const CustomThemeExtension({
    this.backgroundGradient,
    this.selectedColor,
    this.unselectedColor,
    this.borderColor,
    this.dartsTextColor,
    this.dartsBGColor,
    this.cardBackgroundColor,
    this.cardTextColor,
  });

  @override
  CustomThemeExtension copyWith({
    LinearGradient? backgroundGradient,
    Color? selectedColor,
    Color? unselectedColor,
    Color? borderColor,
    Color? dartsTextColor,
    Color? dartsBGColor,
    Color? cardBackgroundColor,
    Color? cardTextColor,
  }) {
    return CustomThemeExtension(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      borderColor: borderColor ?? this.borderColor,
      dartsTextColor: dartsTextColor ?? this.dartsTextColor,
      dartsBGColor: dartsBGColor ?? this.dartsBGColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      cardTextColor: cardTextColor ?? this.cardTextColor,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      backgroundGradient:
          LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      unselectedColor: Color.lerp(unselectedColor, other.unselectedColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      dartsTextColor: Color.lerp(dartsTextColor, other.dartsTextColor, t),
      dartsBGColor: Color.lerp(dartsBGColor, other.dartsBGColor, t),
      cardBackgroundColor:
          Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t),
      cardTextColor: Color.lerp(cardTextColor, other.cardTextColor, t),
    );
  }
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.blueGrey[200],
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(255, 249, 249, 249),
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade200,
  ),
).copyWith(
  extensions: [
    CustomThemeExtension(
      backgroundGradient: const LinearGradient(
        colors: [Colors.blueGrey, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      selectedColor: Colors.blue[200],
      unselectedColor: Colors.white,
      borderColor: Colors.grey,
      dartsTextColor: Colors.black,
      dartsBGColor: Colors.white,
      cardBackgroundColor: Colors.white,
      cardTextColor: Colors.black,
    ),
  ],
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade800,
    primary: Colors.grey.shade700,
    secondary: Colors.grey.shade600,
  ),
).copyWith(
  extensions: [
    CustomThemeExtension(
      backgroundGradient: LinearGradient(
        colors: [Colors.black, Colors.grey.shade800],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      selectedColor: Colors.orange,
      unselectedColor: Colors.grey.shade800,
      borderColor: Colors.white,
      dartsTextColor: Colors.white,
      dartsBGColor: Colors.grey.shade800,
      cardBackgroundColor: Colors.grey.shade800,
      cardTextColor: Colors.white,
    ),
  ],
);
