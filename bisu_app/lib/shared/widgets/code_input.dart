import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// A segmented numeric code entry (mirrors `.code-boxes` / `.code-digit` in
/// styles.css) used by the auth-code screen.
///
/// ```css
/// .code-boxes{ display:flex; gap:8px; justify-content:center; }
/// .code-digit{ width:44px; height:54px; text-align:center; font-size:22px;
///   font-weight:700; border:1.5px solid var(--hair); border-radius:10px; background:#FFF; }
/// .code-digit:focus{ border-color:var(--gold); box-shadow:0 0 0 2px rgba(168,137,90,.15); }
/// ```
///
/// Fires [onChanged] on every edit and [onCompleted] once all [length] boxes
/// are filled.
class CodeInput extends StatefulWidget {
  const CodeInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  /// Number of digit boxes.
  final int length;

  /// Called with the full code once every box is filled.
  final ValueChanged<String> onCompleted;

  /// Called with the current (possibly partial) code on each edit.
  final ValueChanged<String>? onChanged;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      widget.length,
      (_) => TextEditingController(),
      growable: false,
    );
    _nodes = List<FocusNode>.generate(
      widget.length,
      (_) => FocusNode(),
      growable: false,
    );
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    for (final FocusNode n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((TextEditingController c) => c.text).join();

  void _onBoxChanged(int index, String raw) {
    // Keep only the last typed digit in this box.
    if (raw.length > 1) {
      _controllers[index].value = TextEditingValue(
        text: raw.substring(raw.length - 1),
        selection: const TextSelection.collapsed(offset: 1),
      );
    }
    final String text = _controllers[index].text;
    if (text.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    final String code = _value;
    widget.onChanged?.call(code);
    if (code.length == widget.length &&
        !code.split('').any((String ch) => ch.isEmpty)) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < widget.length; i++) ...<Widget>[
          if (i != 0) const SizedBox(width: 8),
          SizedBox(
            width: 44,
            height: 54,
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              cursorColor: BisuColors.gold,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: BisuColors.ink,
              ),
              decoration: const InputDecoration(
                counterText: '',
                isDense: true,
                filled: true,
                fillColor: BisuColors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: BisuColors.hair, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: BisuColors.hair, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: BisuColors.gold, width: 1.5),
                ),
              ),
              onChanged: (String raw) => _onBoxChanged(i, raw),
            ),
          ),
        ],
      ],
    );
  }
}
