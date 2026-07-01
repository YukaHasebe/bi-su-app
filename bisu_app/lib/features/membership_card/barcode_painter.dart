import 'package:flutter/widgets.dart';

import 'package:bisu_app/theme/bisu_colors.dart';

/// Renders a faux 1-D barcode for the digital membership card.
///
/// Faithful port of app.js `generateBarcodeSVG(data)` (lines ~864–882):
/// each character of [data] is expanded to its 8-bit binary representation,
/// the whole stream is framed by the guard pattern `101`…`101`, and every `1`
/// bit becomes a 2px-wide black bar spanning the full height. The original
/// produces an `<svg viewBox="0 0 {bits*2} 80">` with `<rect width="2" height="80">`
/// bars; this painter reproduces that 1:1 (intrinsic width `code.length * 2`,
/// intrinsic height `80`) and lets the host scale it to fit the box.
///
/// Mock data only — not a scannable barcode (matches the mockup's disclaimer).
class BarcodePainter extends CustomPainter {
  const BarcodePainter({required this.data, this.barColor = BisuColors.ink});

  /// The string encoded into bars (e.g. `BISU-BS-00124857`).
  final String data;

  /// Bar fill color (`#2A2620` = [BisuColors.ink] in the mockup).
  final Color barColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Mirror generateBarcodeSVG: 8-bit per char, framed by '101'…'101'.
    final StringBuffer buf = StringBuffer();
    for (int i = 0; i < data.length; i++) {
      final int c = data.codeUnitAt(i);
      String bits = c.toRadixString(2);
      while (bits.length < 8) {
        bits = '0$bits';
      }
      buf.write(bits);
    }
    final String code = '101${buf.toString()}101';

    final int unitCount = code.length; // each bit = 2 SVG units wide
    if (unitCount == 0) return;

    // The SVG intrinsic width is unitCount*2, height 80. Scale uniformly to the
    // available box while preserving the bar/gap proportions, then center.
    const double svgUnitWidth = 2; // each bar/slot is 2 units wide in the SVG
    final double intrinsicWidth = unitCount * svgUnitWidth;
    const double intrinsicHeight = 80;

    final double scale = (size.width / intrinsicWidth)
        .clamp(0.0, size.height / intrinsicHeight)
        .toDouble();
    final double drawnWidth = intrinsicWidth * scale;
    final double drawnHeight = intrinsicHeight * scale;
    final double offsetX = (size.width - drawnWidth) / 2;
    final double offsetY = (size.height - drawnHeight) / 2;

    final Paint paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;

    final double barWidth = svgUnitWidth * scale;
    for (int j = 0; j < unitCount; j++) {
      if (code.codeUnitAt(j) == 0x31 /* '1' */) {
        final double x = offsetX + (j * svgUnitWidth * scale);
        canvas.drawRect(
          Rect.fromLTWH(x, offsetY, barWidth, drawnHeight),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BarcodePainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.barColor != barColor;
}
