import 'dart:typed_data';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

void main() => runApp(MaterialApp(home: PuzzlePage()));

class PuzzlePage extends StatefulWidget {
  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  Uint8List? fullImageBytes;
  List<img.Image> options = [];
  img.Image? originalImage;
  int? missingRow;
  int? missingCol;
  final int rows = 3;
  final int cols = 3;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        createPuzzle(originalImage!);
      }
    }
  }

  void createPuzzle(img.Image image) {
    final pieceWidth = (image.width / cols).floor();
    final pieceHeight = (image.height / rows).floor();

    final rand = Random();
    missingRow = rand.nextInt(rows);
    missingCol = rand.nextInt(cols);

    final canvas = img.Image(image.width, image.height);
    img.copyInto(canvas, image);

    // تکه‌ای که باید حذف شود
    img.Image missingPiece = img.copyCrop(
      image,
      missingCol! * pieceWidth,
      missingRow! * pieceHeight,
      pieceWidth,
      pieceHeight,
    );

    // حذف تکه از تصویر
    img.fillRect(
      canvas,
      missingCol! * pieceWidth,
      missingRow! * pieceHeight,
      (missingCol! + 1) * pieceWidth,
      (missingRow! + 1) * pieceHeight,
      img.getColor(255, 255, 255),
    );

    // تبدیل به بایت برای نمایش
    fullImageBytes = Uint8List.fromList(img.encodeJpg(canvas));

    // ساخت گزینه‌ها
    options.clear();
    options.add(missingPiece); // گزینه‌ی درست

    while (options.length < 6) {
      int r = rand.nextInt(rows);
      int c = rand.nextInt(cols);

      if (r == missingRow && c == missingCol) continue;

      img.Image fake = img.copyCrop(
        image,
        c * pieceWidth,
        r * pieceHeight,
        pieceWidth,
        pieceHeight,
      );
      options.add(fake);
    }

    options.shuffle();

    setState(() {});
  }

  void checkSelection(img.Image selected) {
    final correctBytes = Uint8List.fromList(img.encodePng(options.first));
    final selectedBytes = Uint8List.fromList(img.encodePng(selected));
    bool isCorrect = listEquals(correctBytes, selectedBytes);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isCorrect ? "درسته 🎉" : "اشتباهه ❌"),
            actions: [
              TextButton(
                child: Text("باشه"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("چالش پازل")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickImage,
            child: Text("انتخاب عکس از گالری"),
          ),
          if (fullImageBytes != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(fullImageBytes!),
            ),
          if (options.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("کدوم تیکه گم شده؟", style: TextStyle(fontSize: 18)),
            ),
          if (options.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemBuilder: (_, index) {
                final opt = options[index];
                return GestureDetector(
                  onTap: () => checkSelection(opt),
                  child: Image.memory(Uint8List.fromList(img.encodeJpg(opt))),
                );
              },
            ),
        ],
      ),
    );
  }
}
