import 'package:flutter/material.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// A small on/off switch (mirrors `.toggle` in styles.css).
///
/// ```css
/// .toggle{ width:44px; height:26px; border-radius:99px; background:#D9D3C6; }
/// .toggle::after{ top:3px; left:3px; width:20px; height:20px; border-radius:99px;
///   background:#FFF; box-shadow:0 1px 4px rgba(0,0,0,.25); }
/// .toggle.is-on{ background:var(--gold); }
/// .toggle.is-on::after{ transform:translateX(18px); }
/// ```
class ToggleSwitch extends StatelessWidget {
  const ToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when tapped.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? BisuColors.gold : const Color(0xFFD9D3C6),
          borderRadius: BorderRadius.circular(99),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: BisuColors.white,
              borderRadius: BorderRadius.circular(99),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x40000000), // rgba(0,0,0,.25)
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
