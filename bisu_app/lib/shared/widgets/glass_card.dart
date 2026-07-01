import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// A frosted "glass" card used on the night-background Home screen.
///
/// Mirrors `.glass-card` in styles.css:
/// ```css
/// .glass-card{
///   border-radius:18px;
///   background:rgba(18,18,16,.40);
///   border:1px solid rgba(255,255,255,.20);
///   backdrop-filter:blur(14px);
///   box-shadow:0 8px 30px rgba(0,0,0,.28);
///   padding:14px 16px;
/// }
/// ```
///
/// The CSS uses a real backdrop blur; reproducing that on arbitrary
/// backgrounds is expensive, so by default we render the same translucent
/// dark fill (which reads identically over the Home video/photo) wrapped in a
/// [BackdropFilter] for the blur. Pass [background] to override the fill (e.g.
/// the light-screen `.card` look) and the blur is then skipped.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.background,
    this.radius = 18,
    this.blur = true,
  });

  /// The card contents.
  final Widget child;

  /// Inner padding. Defaults to the CSS `14px 16px`.
  final EdgeInsetsGeometry padding;

  /// Fill color. Null = the translucent night glass (`rgba(18,18,16,.40)`).
  final Color? background;

  /// Corner radius. Defaults to the CSS `18px`.
  final double radius;

  /// Whether to apply the frosted backdrop blur (only when [background] is the
  /// default translucent fill).
  final bool blur;

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = BorderRadius.circular(radius);
    final bool glass = background == null;
    final Color fill = background ?? const Color(0x66121210); // rgba(18,18,16,.40)

    final Widget content = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: br,
        border: glass
            ? Border.all(color: const Color(0x33FFFFFF)) // rgba(255,255,255,.20)
            : null,
        boxShadow: glass
            ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x47000000), // rgba(0,0,0,.28)
                  blurRadius: 30,
                  offset: Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (glass && blur) {
      return ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: content,
        ),
      );
    }
    return ClipRRect(borderRadius: br, child: content);
  }
}
