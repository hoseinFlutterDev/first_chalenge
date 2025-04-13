// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(MaterialApp(home: PuzzleGame()));

// class PuzzleGame extends StatefulWidget {
//   @override
//   _PuzzleGameState createState() => _PuzzleGameState();
// }

// class _PuzzleGameState extends State<PuzzleGame> {
//   File? imageFile;
//   img.Image? fullImage;
//   List<img.Image> puzzlePieces = [];
//   img.Image? missingPiece;
//   List<img.Image> options = [];
//   int gridSize = 3;
//   int? missingIndex;
//   bool isCompleted = false;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       final file = File(picked.path);
//       final bytes = await file.readAsBytes();
//       final original = img.decodeImage(bytes);

//       if (original != null) {
//         setState(() {
//           imageFile = file;
//           fullImage = img.copyResize(original, width: 300, height: 300);
//           isCompleted = false;
//         });
//         generatePuzzle(fullImage!);
//       }
//     }
//   }

//   void generatePuzzle(img.Image image) {
//     puzzlePieces.clear();
//     options.clear();

//     int pieceWidth = image.width ~/ gridSize;
//     int pieceHeight = image.height ~/ gridSize;

//     for (int row = 0; row < gridSize; row++) {
//       for (int col = 0; col < gridSize; col++) {
//         var piece = img.copyCrop(
//           image,
//           col * pieceWidth,
//           row * pieceHeight,
//           pieceWidth,
//           pieceHeight,
//         );
//         puzzlePieces.add(piece);
//       }
//     }

//     // حذف یک قطعه به صورت تصادفی
//     missingIndex = Random().nextInt(puzzlePieces.length);
//     missingPiece = puzzlePieces[missingIndex!];
//     puzzlePieces[missingIndex!] = img.Image(pieceWidth, pieceHeight);
//     options.add(missingPiece!);

//     // تولید 5 گزینه اشتباه بدون تکرار و بدون قطعه درست
//     Set<int> usedIndices = {missingIndex!};
//     while (options.length < 6) {
//       int randomIndex = Random().nextInt(puzzlePieces.length);
//       if (usedIndices.contains(randomIndex)) continue;
//       usedIndices.add(randomIndex);

//       int row = randomIndex ~/ gridSize;
//       int col = randomIndex % gridSize;

//       var fakePiece = img.copyCrop(
//         fullImage!,
//         col * pieceWidth,
//         row * pieceHeight,
//         pieceWidth,
//         pieceHeight,
//       );
//       options.add(fakePiece);
//     }

//     options.shuffle();
//     setState(() {});
//   }

//   bool compareImages(img.Image a, img.Image b) {
//     if (a.width != b.width || a.height != b.height) return false;
//     for (int y = 0; y < a.height; y++) {
//       for (int x = 0; x < a.width; x++) {
//         if (a.getPixel(x, y) != b.getPixel(x, y)) return false;
//       }
//     }
//     return true;
//   }

//   void checkSelection(img.Image selectedPiece) {
//     if (compareImages(selectedPiece, missingPiece!)) {
//       setState(() {
//         puzzlePieces[missingIndex!] = selectedPiece;
//         isCompleted = true;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("تبریک! قطعه درست انتخاب شد.")));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("اشتباه است! دوباره امتحان کنید.")),
//       );
//     }
//   }

//   Widget buildPuzzleGrid() {
//     return fullImage == null
//         ? Center(child: Text('لطفاً یک تصویر انتخاب کنید.'))
//         : GridView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: gridSize,
//           ),
//           itemCount: puzzlePieces.length,
//           itemBuilder: (context, index) {
//             final piece = puzzlePieces[index];
//             if (piece.width == 0 || piece.height == 0) {
//               return Container(color: Colors.grey);
//             }
//             return Image.memory(
//               Uint8List.fromList(img.encodeJpg(piece)),
//               fit: BoxFit.cover,
//             );
//           },
//         );
//   }

//   Widget buildOptions() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(8),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3, // دو ستون
//         crossAxisSpacing: 5,
//         mainAxisSpacing: 5,
//         childAspectRatio: 1,
//       ),
//       itemCount: options.length,
//       itemBuilder: (context, index) {
//         final option = options[index];
//         return GestureDetector(
//           onTap: () => checkSelection(option),
//           child: Image.memory(
//             Uint8List.fromList(img.encodeJpg(option)),
//             fit: BoxFit.cover,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('چالش تشخیص ربات از انسان'),
//         actions: [
//           IconButton(icon: Icon(Icons.image), onPressed: pickImage),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               if (fullImage != null) generatePuzzle(fullImage!);
//               setState(() => isCompleted = false);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(child: buildPuzzleGrid()),
//           if (!isCompleted)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("لطفاً قطعه مناسب را انتخاب کنید."),
//             ),
//           if (!isCompleted) Expanded(child: buildOptions()),
//           if (isCompleted)
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text("پازل کامل شد!"),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:first_challenge/pages/first_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: FirstPage());
  }
}
