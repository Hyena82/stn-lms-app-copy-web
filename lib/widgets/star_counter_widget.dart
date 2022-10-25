// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StarCounterWidget extends StatelessWidget {
  final double value;
  final double size;
  final Color color;

  const StarCounterWidget(
      {Key? key, required this.value, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Icon(
            (value == 5)
                ? FontAwesomeIcons.solidStar
                : index + 1 < value
                    ? FontAwesomeIcons.solidStar
                    : (index == value.toInt() && value % 1 != 0)
                        ? FontAwesomeIcons.starHalfAlt
                        : FontAwesomeIcons.star,
            color: color,
            size: size,
          ),
        );
      }),
    );
  }
}
