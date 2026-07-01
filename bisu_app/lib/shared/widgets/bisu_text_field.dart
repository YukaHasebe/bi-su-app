import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// A bordered text input (mirrors `.auth-input` in styles.css).
///
/// ```css
/// .auth-input{ padding:14px 16px; font-size:14px; letter-spacing:.02em;
///   border:1px solid var(--hair); border-radius:12px; background:#FFF; color:var(--ink); }
/// .auth-input:focus{ border-color:var(--gold); }
/// .auth-input::placeholder{ color:var(--ink-faint); }
/// ```
///
/// An optional [label] is rendered above the field (the mockup labels fields
/// in copy rather than a floating label, so this stays a plain caption).
class BisuTextField extends StatelessWidget {
  const BisuTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
  });

  /// Text editing controller.
  final TextEditingController controller;

  /// Optional caption rendered above the field.
  final String? label;

  /// Placeholder text (`::placeholder`).
  final String? hintText;

  /// Keyboard type.
  final TextInputType keyboardType;

  /// Whether to obscure input (passwords).
  final bool obscureText;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder base = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: BisuColors.hair, width: 1),
    );

    final Widget field = TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      cursorColor: BisuColors.gold,
      style: const TextStyle(
        fontFamilyFallback: <String>[
          'Hiragino Kaku Gothic ProN',
          'Yu Gothic Medium',
          'YuGothic',
          'Noto Sans JP',
          'Segoe UI',
          'sans-serif',
        ],
        fontSize: 14,
        letterSpacing: 0.28, // ~.02em of 14px
        color: BisuColors.ink,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: BisuColors.white,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: BisuColors.inkFaint,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: base,
        enabledBorder: base,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: BisuColors.gold, width: 1),
        ),
      ),
    );

    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 7),
          child: Text(
            label!,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: BisuColors.inkSoft,
            ),
          ),
        ),
        field,
      ],
    );
  }
}
