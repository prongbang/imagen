import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CertificateCustomPainter extends CustomPainter {
  CertificateCustomPainter(this.background);

  final ui.Image background;

  @override
  void paint(Canvas canvas, Size size) async {
    canvas.drawImage(background, const Offset(0, 0), Paint());

    const textStyle = TextStyle(color: Colors.black, fontSize: 100);
    const textSpan = TextSpan(
      text: 'MOCKRAWIT MITRAWOKKIYOTHINSAWONG',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
