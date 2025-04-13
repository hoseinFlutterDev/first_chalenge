import 'dart:typed_data';

class PuzzlePiece {
  final Uint8List imageBytes;
  final int row;
  final int col;

  PuzzlePiece({required this.imageBytes, required this.row, required this.col});
}
