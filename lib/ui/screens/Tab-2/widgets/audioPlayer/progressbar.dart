import 'dart:math';

import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  ProgressBar({
    required this.duration,
    required this.position,
    this.bufferedPosition = Duration.zero,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double? _dragValue;
  bool _dragging = false;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 3.0,
      trackShape: CustomTrackShape(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final value = min(
      _dragValue ?? widget.position.inMilliseconds.toDouble(),
      widget.duration.inMilliseconds.toDouble(),
    );
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Container(
      height:35,
      child: Stack(
        children: [
          SliderTheme(
            data: _sliderThemeData.copyWith(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
              thumbColor: Colors.transparent,
              activeTrackColor: Color(0xff616161),
              inactiveTrackColor: Color(0xffC4C4C4),
              trackHeight: 3.0,

            ),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {},
            ),
          ),
          SliderTheme(
            data: _sliderThemeData.copyWith(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
              thumbColor: Colors.transparent,
              activeTrackColor: Color(0xff616161),
              inactiveTrackColor: Color(0xffC4C4C4),
              trackHeight: 1.0,
            ),
            child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: value,
                onChanged: null,
                onChangeEnd: null),
          ),
          Positioned(
            right: 16.0,
            top: 0.0,
            child: Text(
                ( RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_position")
                        ?.group(1) ??
                    '$_position') +
                        " / " +
                        (RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                .firstMatch("$_duration")
                                ?.group(1) ??
                            '$_duration'),
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }

  // Duration get _remaining => widget.duration - widget.position;
  Duration get _position => widget.position;
  Duration get _duration => widget.duration;
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
  required RenderBox parentBox,
  Offset offset = Offset.zero,
  required SliderThemeData sliderTheme,
  bool isEnabled = false,
  bool isDiscrete = false,})
{
  final double trackHeight = sliderTheme.trackHeight ?? 3;
  final double trackLeft = offset.dx;
  final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
  final double trackWidth = parentBox.size.width - 15;
  return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);}
}
