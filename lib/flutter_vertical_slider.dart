library flutter_vertical_slider;

import 'dart:math';

import 'package:flutter/material.dart';

class VerticalSlider extends StatelessWidget {
  const VerticalSlider({
    Key? key,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.value,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.width,
  }) : super(key: key);
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double value;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: inactiveTrackColor,
            thumbColor: Colors.transparent,
            overlayColor: Colors.transparent,
            thumbSelector: (textDirection, values, tapValue, thumbSize, trackSize, dx) => Thumb.start,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 1,
              elevation: 0.0,
            ),
            trackHeight: width,
            overlayShape: RoundSliderOverlayShape(overlayRadius: 1),
            trackShape: CustomRoundedRectSliderTrackShape(Radius.circular(12)),
          ),
          child: Slider(
            onChanged: onChanged,
            min: min,
            max: max,
            value: value,
          ),
        ),
      ),
    );
  }
}

class CustomRoundedRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  final Radius trackRadius;
  const CustomRoundedRectSliderTrackShape(this.trackRadius);

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween =
        ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween =
        ColorTween(begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final Paint leftTrackPaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint rightTrackPaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    var activeRect = RRect.fromLTRBAndCorners(
      trackRect.left,
      trackRect.top - (additionalActiveTrackHeight / 2),
      thumbCenter.dx,
      trackRect.bottom + (additionalActiveTrackHeight / 2),
      topLeft: trackRadius,
      bottomLeft: trackRadius,
    );
    var inActiveRect = RRect.fromLTRBAndCorners(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
      topRight: trackRadius,
      bottomRight: trackRadius,
    );
    var percent = ((activeRect.width / (activeRect.width + inActiveRect.width)) * 100).toInt();
    if (percent > 99) {
      activeRect = RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top - (additionalActiveTrackHeight / 2),
        thumbCenter.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        bottomRight: trackRadius,
        topRight: trackRadius,
      );
    }

    if (percent < 1) {
      inActiveRect = RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
        bottomLeft: trackRadius,
        topLeft: trackRadius,
      );
    }
    context.canvas.drawRRect(
      activeRect,
      leftTrackPaint,
    );

    context.canvas.drawRRect(
      inActiveRect,
      rightTrackPaint,
    );

    drawText(context.canvas, '%$percent', activeRect.center.dx, activeRect.center.dy, pi * 0.5, activeRect.width);
  }

  void drawText(Canvas context, String name, double x, double y, double angleRotationInRadians, double height) {
    context.save();
    var span = TextSpan(style: TextStyle(color: Colors.white, fontSize: height >= 24.0 ? 24.0 : height), text: name);
    var tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    context.translate((x + (tp.height * 0.5)), (y - (tp.width * 0.5)));
    context.rotate(angleRotationInRadians);
    tp.layout();
    tp.paint(context, new Offset(0.0, 0.0));
    context.restore();
  }
}
