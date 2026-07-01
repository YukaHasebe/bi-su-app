import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:video_player/video_player.dart';

import 'package:bisu_app/models/rank.dart';
import 'package:bisu_app/shared/swallow_svg.dart';
import 'package:bisu_app/theme/bisu_colors.dart';
import 'package:bisu_app/theme/bisu_typography.dart';

/// SPLASH / 起動演出 — the first route of the app.
///
/// Faithful port of app.js `playVideoSplash` (315–428) + the `#splash`
/// skeleton in index.html and the `.splash*` rules in styles.css.
///
/// Plays the current rank's journey video (`assets/videos/journey-<id>.mp4`)
/// over a night background, respecting [Rank.videoStart] (seek) and
/// [Rank.videoEnd] (stop). The logo fades in early; on the video "landing"
/// the swallow emblem + rank EN/JP/place reveal in sequence; a SKIP button
/// is always available. On end / skip / error → [onDone] fires (the integrate
/// layer pushes RootScaffold).
///
/// SIMPLIFICATION vs the mockup: the mockup captures the final video frame and
/// carries it into the Home background (`__videoHomeShot` / `setHomeBg`). That
/// frame-capture-to-home-background hand-off is NOT reproduced here.
///
/// If the video fails to load, falls back to a tinted gradient + emblem and
/// still fires [onDone] after ~2.4s.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone, this.rank});

  /// Called exactly once when the splash finishes (end / skip / error /
  /// fallback). The integrate layer uses this to push RootScaffold.
  final VoidCallback onDone;

  /// The rank whose journey video + caption to show. Defaults to
  /// [RankId.member] (the boot rank).
  final RankId? rank;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // --- staged reveal flags (mirror the reveal() calls in playVideoSplash) ---
  bool _logoShown = false; // reveal('.splash-logo', 500)
  bool _skipShown = false; // splash-skip is-shown @ 700ms
  bool _swallowShown = false; // reveal('#splash-swallow', after landing +200)
  bool _enShown = false; // reveal('#splash-rank-en', +400)
  bool _jpShown = false; // reveal('#splash-rank-jp', +650)
  bool _placeShown = false; // reveal('#splash-place', +850)
  bool _leaving = false; // .splash.is-leaving (fade out)

  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _videoFailed = false;
  bool _videoVisible = true; // hidden until seeked when videoStart > 0

  bool _landed = false; // landing() ran once
  bool _finished = false; // finishSplash() / onDone fired once

  // rAF-equivalent: poll position to honor videoEnd precisely.
  Ticker? _endTicker;
  final List<Timer> _timers = <Timer>[];

  Rank get _rank => Ranks.of(widget.rank ?? RankId.member);

  @override
  void initState() {
    super.initState();
    // Early reveals that do not depend on the video (mirror reveal/at calls).
    _scheduleAt(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _logoShown = true);
    });
    _scheduleAt(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _skipShown = true);
    });
    _initVideo();
  }

  void _scheduleAt(Duration d, VoidCallback fn) {
    _timers.add(Timer(d, fn));
  }

  Future<void> _initVideo() async {
    final Rank r = _rank;
    final VideoPlayerController controller =
        VideoPlayerController.asset(r.video);
    _controller = controller;
    try {
      await controller.initialize();
      if (!mounted) {
        return;
      }
      await controller.setVolume(0);
      await controller.setLooping(false);

      final double startAt = r.videoStart ?? 0;
      if (startAt > 0) {
        // Seek to the start offset; keep the video hidden until seeked
        // (mirrors visibility:hidden until 'seeked' in the mockup).
        _videoVisible = false;
        await controller.seekTo(
          Duration(milliseconds: (startAt * 1000).round()),
        );
        if (!mounted) return;
        _videoVisible = true;
      }

      setState(() => _videoReady = true);
      await controller.play();

      // rAF-equivalent end watcher (honors videoEnd / duration - 0.12s).
      _endTicker = createTicker((_) => _checkEnd())..start();
    } catch (_) {
      _onVideoFailed();
    }
  }

  void _checkEnd() {
    if (_landed) return;
    final VideoPlayerController? c = _controller;
    if (c == null || !c.value.isInitialized) return;

    final double endAt = _rank.videoEnd ?? 0;
    final double durationSec = c.value.duration.inMilliseconds / 1000.0;
    final double limit =
        endAt > 0 ? endAt : (durationSec > 0 ? durationSec - 0.12 : double.infinity);
    final double pos = c.value.position.inMilliseconds / 1000.0;

    if (c.value.hasError) {
      _onVideoFailed();
      return;
    }
    if (pos >= limit || c.value.position >= c.value.duration) {
      _landing();
    }
  }

  void _onVideoFailed() {
    if (_videoFailed || _finished) return;
    _videoFailed = true;
    if (mounted) setState(() {});
    // Fallback: reveal the emblem + caption over a tinted gradient, then finish.
    _landing();
    _scheduleAt(const Duration(milliseconds: 2400), _finishSplash);
  }

  /// Mirrors landing() in playVideoSplash: pause the video, then reveal the
  /// emblem + rank EN/JP/place in sequence, then finish after 2.4s.
  void _landing() {
    if (_landed) return;
    _landed = true;
    _endTicker?.stop();
    _controller?.pause();

    if (!mounted) return;
    setState(() => _swallowShown = true); // +200 (immediate here)
    _scheduleAt(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _enShown = true); // +400
    });
    _scheduleAt(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _jpShown = true); // +650
    });
    _scheduleAt(const Duration(milliseconds: 650), () {
      if (mounted) setState(() => _placeShown = true); // +850
    });
    _scheduleAt(const Duration(milliseconds: 2400), _finishSplash);
  }

  /// Skip handler (mirrors state.skipFn): if already landed, finish; otherwise
  /// seek to the landing point, land, and finish.
  Future<void> _onSkip() async {
    if (_finished) return;
    if (_landed) {
      _finishSplash();
      return;
    }
    final VideoPlayerController? c = _controller;
    final double endAt = _rank.videoEnd ?? 0;
    try {
      if (c != null && c.value.isInitialized) {
        final double durationSec = c.value.duration.inMilliseconds / 1000.0;
        final double target =
            endAt > 0 ? endAt : (durationSec > 0 ? durationSec - 0.15 : 0);
        await c.pause();
        if (target > 0) {
          await c.seekTo(Duration(milliseconds: (target * 1000).round()));
        }
      }
    } catch (_) {
      // ignore — fall through to landing/finish
    }
    _landing();
    _finishSplash();
  }

  /// Mirrors finishSplash(): fade out, then fire onDone after ~700ms.
  void _finishSplash() {
    if (_finished) return;
    _finished = true;
    if (mounted) {
      setState(() => _leaving = true);
    }
    _endTicker?.stop();
    _scheduleAt(const Duration(milliseconds: 700), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    for (final Timer t in _timers) {
      t.cancel();
    }
    _timers.clear();
    _endTicker?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Rank r = _rank;

    return Scaffold(
      backgroundColor: BisuColors.night,
      body: AnimatedOpacity(
        // .splash.is-leaving { opacity:0 } transition .65s ease
        opacity: _leaving ? 0 : 1,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // ---- splash-shots: video layer (or fallback gradient) ----
            _buildBackdrop(r),

            // ---- splash-veil: radial vignette ----
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.16), // ~50% 42%
                    radius: 1.1,
                    colors: <Color>[
                      Color(0x00050608),
                      Color(0x8C050608), // rgba(5,6,8,.55)
                    ],
                    stops: <double>[0.55, 1.0],
                  ),
                ),
                child: SizedBox.expand(),
              ),
            ),

            // ---- splash-center: logo + emblem + rank EN/JP ----
            _buildCenter(r),

            // ---- splash-place: caption pinned near the bottom ----
            _buildPlace(r),

            // ---- splash-skip button ----
            _buildSkip(),
          ],
        ),
      ),
    );
  }

  /// Video layer; falls back to a rank-tinted gradient on failure.
  Widget _buildBackdrop(Rank r) {
    final VideoPlayerController? c = _controller;
    if (!_videoFailed && _videoReady && c != null && c.value.isInitialized) {
      return AnimatedOpacity(
        opacity: _videoVisible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: FittedBox(
          // object-fit: cover
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: c.value.size.width,
            height: c.value.size.height,
            child: VideoPlayer(c),
          ),
        ),
      );
    }
    // Fallback (and pre-ready) backdrop: night → rank tint.
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            BisuColors.night,
            Color.lerp(BisuColors.night, r.color, 0.32) ?? BisuColors.night,
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }

  /// .splash-center — column with logo, swallow emblem, rank EN, rank JP.
  Widget _buildCenter(Rank r) {
    return IgnorePointer(
      child: Padding(
        // .splash-center { padding-bottom:40px }
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // .splash-logo — 120px wide, fades in @500ms (900ms ease)
            _Reveal(
              shown: _logoShown,
              duration: const Duration(milliseconds: 900),
              child: Image.asset(
                'assets/images/logo_w.png',
                width: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(width: 120),
              ),
            ),
            const SizedBox(height: 34), // .splash-logo margin-bottom:34px

            // .splash-swallow — 74×58, tinted with rank.soft (per app.js)
            _Reveal(
              shown: _swallowShown,
              child: SizedBox(
                width: 74,
                height: 58,
                child: SwallowEmblem(
                  color: r.soft,
                  width: 74,
                  height: 58,
                  semanticLabel: '${r.en} emblem',
                ),
              ),
            ),
            const SizedBox(height: 6), // .splash-swallow margin-bottom:6px

            // .splash-rank-en — serif 34, letter-spacing .42em
            _Reveal(
              shown: _enShown,
              duration: const Duration(milliseconds: 850),
              child: Text(
                r.en,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamilyFallback: BisuType.serifFallback,
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 34 * 0.42, // .42em
                  color: Color(0xFFF5EEDF),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 22,
                      color: Color(0x8C000000), // rgba(0,0,0,.55)
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10), // .splash-rank-jp margin-top:10px

            // .splash-rank-jp — serif 12.5, letter-spacing .5em
            _Reveal(
              shown: _jpShown,
              child: Text(
                r.jp,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamilyFallback: BisuType.serifFallback,
                  fontSize: 12.5,
                  height: 1.3,
                  letterSpacing: 12.5 * 0.5, // .5em
                  color: Color(0xD9F5EEDF), // rgba(245,238,223,.85)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// .splash-place — pinned 84px from the bottom, centered.
  Widget _buildPlace(Rank r) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 84,
      child: IgnorePointer(
        child: _Reveal(
          shown: _placeShown,
          child: Text(
            r.place,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamilyFallback: BisuType.serifFallback,
              fontSize: 10,
              height: 1.3,
              letterSpacing: 10 * 0.4, // .4em
              color: Color(0x8CFFFFFF), // rgba(255,255,255,.55)
            ),
          ),
        ),
      ),
    );
  }

  /// .splash-skip — pill button bottom-right, fades in @700ms.
  Widget _buildSkip() {
    return Positioned(
      right: 18,
      bottom: 30,
      child: AnimatedOpacity(
        opacity: _skipShown ? 1 : 0,
        duration: const Duration(milliseconds: 400),
        child: _SkipButton(onTap: _skipShown ? _onSkip : null),
      ),
    );
  }
}

/// SKIP pill (`.splash-skip`).
class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(
        side: BorderSide(color: Color(0x59FFFFFF)), // rgba(255,255,255,.35)
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 16, 8),
          child: Text(
            'SKIP',
            style: TextStyle(
              fontFamilyFallback: BisuType.sansFallback,
              fontSize: 10.5,
              height: 1.0,
              letterSpacing: 10.5 * 0.28, // .28em
              color: Color(0xBFFFFFFF), // rgba(255,255,255,.75)
            ),
          ),
        ),
      ),
    );
  }
}

/// A single fade+rise reveal (mirrors the reveal() helper: opacity 0→1 and
/// translateY(10px)→0 with an ease/cubic-bezier transition).
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.shown,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
  });

  final bool shown;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: shown ? 1 : 0,
      duration: duration,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        // translateY(10px) → none. 10px over a ~390px frame ≈ 0.0256 of width;
        // _Reveal slides in vertical fractions of its own height, so use a
        // small fixed-ish offset via a Transform is overkill — AnimatedSlide's
        // offset is a fraction of the child size, which keeps the subtle rise.
        offset: shown ? Offset.zero : const Offset(0, 0.18),
        duration: duration,
        curve: const Cubic(0.2, 0.7, 0.25, 1),
        child: child,
      ),
    );
  }
}
