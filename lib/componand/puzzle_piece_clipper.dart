import 'package:flutter/material.dart';
import 'dart:math';

class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int gridSize;

  PuzzlePieceClipper(this.row, this.col, this.gridSize);

  @override
  Path getClip(Size size) {
    final Path path = Path();
    double pieceWidth = size.width;
    double pieceHeight = size.height;

    path.moveTo(0, 0);

    // Top
    if (row == 0) {
      path.lineTo(pieceWidth, 0);
    } else {
      path.lineTo(pieceWidth / 3, 0);
      path.cubicTo(
        pieceWidth / 2,
        -pieceHeight / 6,
        pieceWidth * 2 / 3,
        0,
        pieceWidth,
        0,
      );
    }

    // Right
    if (col == gridSize - 1) {
      path.lineTo(pieceWidth, pieceHeight);
    } else {
      path.lineTo(pieceWidth, pieceHeight / 3);
      path.cubicTo(
        pieceWidth + pieceWidth / 6,
        pieceHeight / 2,
        pieceWidth,
        pieceHeight * 2 / 3,
        pieceWidth,
        pieceHeight,
      );
    }

    // Bottom
    if (row == gridSize - 1) {
      path.lineTo(0, pieceHeight);
    } else {
      path.lineTo(pieceWidth * 2 / 3, pieceHeight);
      path.cubicTo(
        pieceWidth / 2,
        pieceHeight + pieceHeight / 6,
        pieceWidth / 3,
        pieceHeight,
        0,
        pieceHeight,
      );
    }

    // Left
    if (col == 0) {
      path.close();
    } else {
      path.lineTo(0, pieceHeight * 2 / 3);
      path.cubicTo(-pieceWidth / 6, pieceHeight / 2, 0, pieceHeight / 3, 0, 0);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
