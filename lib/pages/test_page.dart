// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: PuzzleApp());
//   }
// }

// class PuzzleApp extends StatefulWidget {
//   @override
//   _PuzzleAppState createState() => _PuzzleAppState();
// }

// class _PuzzleAppState extends State<PuzzleApp> {
//   File? _selectedImage;
//   Uint8List? _puzzlePiece; // قطعه برش خورده
//   final picker = ImagePicker();

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//       _generatePuzzlePiece();
//     }
//   }

//   Future<void> _generatePuzzlePiece() async {
//     if (_selectedImage == null) return;

//     final bytes = await _selectedImage!.readAsBytes();
//     final originalImage = img.decodeImage(bytes);

//     if (originalImage == null) return;

//     // اندازه قطعه پازلی
//     int pieceWidth = (originalImage.width / 4).toInt();
//     int pieceHeight = (originalImage.height / 4).toInt();

//     // انتخاب نقطه رندوم برای برش
//     int x = (originalImage.width - pieceWidth) ~/ 2;
//     int y = (originalImage.height - pieceHeight) ~/ 2;

//     // برش قطعه به صورت پازلی
//     final croppedPiece = img.copyCrop(
//       originalImage,
//       x,
//       y,
//       pieceWidth,
//       pieceHeight,
//     );

//     // تبدیل به Uint8List برای استفاده در Flutter
//     setState(() {
//       _puzzlePiece = Uint8List.fromList(img.encodePng(croppedPiece));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: const Text('پازل عکس'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child:
//                   _selectedImage == null
//                       ? const Text('لطفاً یک عکس انتخاب کنید.')
//                       : Image.file(_selectedImage!),
//             ),
//           ),
//           if (_puzzlePiece != null)
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: CustomPaint(
//                 size: Size(200, 200),
//                 painter: PuzzlePainter(_puzzlePiece!),
//               ),
//             ),
//           ElevatedButton(
//             onPressed: _pickImage,
//             child: const Text('انتخاب عکس'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PuzzlePainter extends CustomPainter {
//   final Uint8List imageBytes;

//   PuzzlePainter(this.imageBytes);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();
//     final image = MemoryImage(imageBytes);

//     // بارگذاری تصویر
//     image
//         .resolve(ImageConfiguration())
//         .addListener(
//           ImageStreamListener((ImageInfo info, bool _) {
//             canvas.drawImage(info.image, Offset(0, 0), paint);

//             // ایجاد مسیر پازلی
//             Path path = Path();
//             path.moveTo(0, 0);
//             path.lineTo(size.width * 0.3, 0);
//             path.cubicTo(
//               size.width * 0.35,
//               size.height * 0.2,
//               size.width * 0.65,
//               size.height * 0.2,
//               size.width * 0.7,
//               0,
//             );
//             path.lineTo(size.width, 0);
//             path.lineTo(size.width, size.height);
//             path.lineTo(0, size.height);
//             path.close();

//             // برش دادن تصویر به شکل پازلی
//             canvas.clipPath(path);
//             paint.color = Colors.transparent;
//             canvas.drawPath(path, paint);
//           }),
//         );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
