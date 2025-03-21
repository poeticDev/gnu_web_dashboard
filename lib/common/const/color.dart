import 'package:flutter/material.dart';

/// 주색상
const SEED_COLOR = Color(0xFF1b263b);


/// 배경색
const BG_COLOR = Color(0xFFDEEBF7);
const COMPONENT_BG_COLOR = Color(0xFFEFF5F8);
const COMPONENT_SHADDOW_COLOR = Color(0xFFCCE3FA);

/// 글자 색상
const TEXT_COLOR = Color(0xFF2C3740);
const BODY_TEXT_COLOR = Color(0xFF485157);
const WHITE_TEXT_COLOR = Color(0xFFFDF8F8);


class AppColors {
  final ColorScheme _scheme;

  const AppColors._(this._scheme);

  /// 현재 context의 ColorScheme을 반영하는 AppColors 생성자
  factory AppColors.of(BuildContext context) {
    return AppColors._(Theme.of(context).colorScheme);
  }

  // 🔵 Primary
  Color get primary => _scheme.primary;
  Color get onPrimary => _scheme.onPrimary;
  Color get primaryContainer => _scheme.primaryContainer;
  Color get onPrimaryContainer => _scheme.onPrimaryContainer;

  // 🟣 Secondary
  Color get secondary => _scheme.secondary;
  Color get onSecondary => _scheme.onSecondary;
  Color get secondaryContainer => _scheme.secondaryContainer;
  Color get onSecondaryContainer => _scheme.onSecondaryContainer;

  // 🟢 Tertiary
  Color get tertiary => _scheme.tertiary;
  Color get onTertiary => _scheme.onTertiary;
  Color get tertiaryContainer => _scheme.tertiaryContainer;
  Color get onTertiaryContainer => _scheme.onTertiaryContainer;
}