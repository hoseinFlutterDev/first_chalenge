import 'package:flutter/material.dart';

class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int totalRows;
  final int totalCols;

  PuzzlePieceClipper({
    required this.row,
    required this.col,
    required this.totalRows,
    required this.totalCols,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    double w = size.width;
    double h = size.height;
    double bumpSize = w * 0.12;

    // جهت دندونه‌ها
    bool topBump = row > 0;
    bool bottomBump = row < totalRows - 1;
    bool leftBump = col > 0;
    bool rightBump = col < totalCols - 1;

    path.moveTo(0, 0);

    // بالا
    if (topBump) {
      path.lineTo(w * 0.3, 0);
      path.cubicTo(w * 0.4, -bumpSize, w * 0.6, -bumpSize, w * 0.7, 0);
    }
    path.lineTo(w, 0);

    // راست
    if (rightBump) {
      path.lineTo(w, h * 0.3);
      path.cubicTo(w + bumpSize, h * 0.4, w + bumpSize, h * 0.6, w, h * 0.7);
    }
    path.lineTo(w, h);

    // پایین
    if (bottomBump) {
      path.lineTo(w * 0.7, h);
      path.cubicTo(w * 0.6, h + bumpSize, w * 0.4, h + bumpSize, w * 0.3, h);
    }
    path.lineTo(0, h);

    // چپ
    if (leftBump) {
      path.lineTo(0, h * 0.7);
      path.cubicTo(-bumpSize, h * 0.6, -bumpSize, h * 0.4, 0, h * 0.3);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
