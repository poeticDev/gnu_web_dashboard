import 'package:flutter/material.dart';

/// 주색상
const SEED_COLOR = Color(0xFFB5C2CC);

/// 배경색
const BG_COLOR = Color(0xFF1C1C25);
const COMPONENT_BG_COLOR = Color(0xFFEFF5F8);
const COMPONENT_SHADDOW_COLOR = Color(0xFFCCE3FA);

const PRIMARY_CONTAINER_COLOR = Color(0xFF23223A);

const DIVIDER_COLOR = Color(0xFFEB5353);

/// 표 색상
const GRID_BG_COLOR = PRIMARY_CONTAINER_COLOR;
const GRID_ODD_ROW_COLOR = BG_COLOR;
const GRID_EVEN_ROW_COLOR = GRID_BG_COLOR;
const GRID_BORDER_COLOR = Color(0xFF1C1C25);
const Color GRID_ICON_COLOR = DIVIDER_COLOR;

/// 전원 스크린
const Color TOGGLE_TRUE_COLOR = Colors.green;
const Color TOGGLE_FALSE_COLOR = Color(0xFFE53935);

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

  // ───── 기본 색상 그룹 ─────

  /// 주요 색상. 버튼, 강조 텍스트 등에 사용됨.
  Color get primary => _scheme.primary;

  /// primary 위에 얹히는 텍스트나 아이콘 색상.
  Color get onPrimary => _scheme.onPrimary;

  /// primary 변형 색상. 배경 또는 카드 등에 주로 사용됨.
  Color get primaryContainer => _scheme.primaryContainer;

  /// primaryContainer 위에 얹히는 텍스트/아이콘 색상.
  Color get onPrimaryContainer => _scheme.onPrimaryContainer;

  /// 부 색상. secondary 기능 버튼, 라벨 등에 사용됨.
  Color get secondary => _scheme.secondary;

  /// secondary 위의 텍스트/아이콘 색상.
  Color get onSecondary => _scheme.onSecondary;

  /// secondary 변형 색상. 배경, 태그 등에 사용됨.
  Color get secondaryContainer => _scheme.secondaryContainer;

  /// secondaryContainer 위의 텍스트/아이콘 색상.
  Color get onSecondaryContainer => _scheme.onSecondaryContainer;

  /// 보조 색상. tertiary 버튼, 차트 등 비주얼 포인트에 사용.
  Color get tertiary => _scheme.tertiary;

  /// tertiary 위 텍스트/아이콘 색상.
  Color get onTertiary => _scheme.onTertiary;

  /// tertiary 변형 색상. 뱃지, 태그 등에 사용.
  Color get tertiaryContainer => _scheme.tertiaryContainer;

  /// tertiaryContainer 위 텍스트/아이콘 색상.
  Color get onTertiaryContainer => _scheme.onTertiaryContainer;

  // ───── 상태/배경 색상 그룹 ─────

  /// 전체 배경색 (앱의 메인 배경으로 쓰임)
  Color get surface => _scheme.surface;

  /// surface 위에 얹히는 텍스트/아이콘 색
  Color get onSurface => _scheme.onSurface;

  /// surface 변형 색상 (카드 구분용 배경 등)
  Color get surfaceVariant => _scheme.surfaceContainerHighest;

  /// surfaceVariant 위 텍스트/아이콘
  Color get onSurfaceVariant => _scheme.onSurfaceVariant;

  /// 그림자 표현에 사용됨 (elevation 효과 등)
  Color get shadow => _scheme.shadow;

  /// 최상위 surface의 컨트롤(예: 스크롤바 등)에 사용
  Color get surfaceTint => _scheme.surfaceTint;

  // ───── 오류/경고 색상 그룹 ─────

  /// 오류 발생 시 표시할 색 (예: 빨간색)
  Color get error => _scheme.error;

  /// error 위의 텍스트/아이콘
  Color get onError => _scheme.onError;

  /// error의 변형 색상 (예: errorContainer)
  Color get errorContainer => _scheme.errorContainer;

  /// errorContainer 위 텍스트/아이콘
  Color get onErrorContainer => _scheme.onErrorContainer;

  // ───── 보조 기능 색상 ─────

  /// 테두리, 구분선 등 비주얼용 라인 색상
  Color get outline => _scheme.outline;

  /// outline의 변형 (보조 구분선 등)
  Color get outlineVariant => _scheme.outlineVariant;

  /// contrast 강한 영역에 사용되는 surface 색상
  Color get inverseSurface => _scheme.inverseSurface;

  /// inverseSurface 위 텍스트/아이콘 색
  Color get onInverseSurface => _scheme.onInverseSurface;

  /// 반대 테마에서의 primary 색상 (ex. 다크모드일 때 라이트모드용 강조색)
  Color get inversePrimary => _scheme.inversePrimary;
}
