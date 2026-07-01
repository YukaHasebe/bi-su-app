/// Formats [n] as a yen amount with ja-JP thousands separators.
///
/// Mirrors app.js `yen(n) => '¥' + n.toLocaleString('ja-JP')`.
/// Example: `yen(138400)` → `"¥138,400"`.
String yen(num n) => '¥${_thousands(n)}';

/// Formats [n] with ja-JP thousands separators but without the ¥ symbol.
/// Example: `thousands(13830)` → `"13,830"`. Used e.g. for the points balance.
String thousands(num n) => _thousands(n);

String _thousands(num n) {
  final bool negative = n < 0;
  // Match JS toLocaleString default: integer grouping, drop fractional noise.
  final int abs = n.abs().round();
  final String digits = abs.toString();
  final StringBuffer out = StringBuffer();
  final int len = digits.length;
  for (int i = 0; i < len; i++) {
    if (i != 0 && (len - i) % 3 == 0) {
      out.write(',');
    }
    out.write(digits[i]);
  }
  return negative ? '-$out' : out.toString();
}
