import 'dart:io';
import 'dart:typed_data';
import 'package:first_challenge/componand/puzzle_piece_clipper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  File? _imageFile;
  List<Uint8List> _puzzlePieces = [];
  List<Uint8List> _options = [];
  int _missingIndex = -1;
  int gridSize = 5;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _splitImageIntoPuzzlePieces();
    } else {
      print('هیچ تصویری انتخاب نشده است.');
    }
  }

  Future<void> _splitImageIntoPuzzlePieces() async {
    final bytes = await _imageFile!.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return;

    int pieceWidth = originalImage.width ~/ gridSize;
    int pieceHeight = originalImage.height ~/ gridSize;

    List<Uint8List> pieces = [];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final piece = img.copyCrop(
          originalImage,
          col * pieceWidth,
          row * pieceHeight,
          pieceWidth,
          pieceHeight,
        );
        pieces.add(Uint8List.fromList(img.encodeJpg(piece)));
      }
    }

    _missingIndex = gridSize * gridSize - 1;

    setState(() {
      _puzzlePieces = List.from(pieces);
      _options = [pieces[_missingIndex], ...pieces.sublist(0, 5)]..shuffle();
    });
  }

  void _checkAnswer(Uint8List selected) {
    final correctPiece = _puzzlePieces[_missingIndex];

    if (selected == correctPiece) {
      setState(() {
        // قرار دادن قطعه درست در موقعیت درست
        _puzzlePieces[_missingIndex] = selected;

        // حذف اون قطعه از گزینه‌ها
        _options.remove(selected);

        // چون قطعه جایگزین شد، دیگه جای خالی نداریم
        _missingIndex = -1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('آفرین! قطعه درست رو سر جاش گذاشتی 🎉')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('اشتباهه! دوباره امتحان کن.')));
    }
  }

  Widget _buildPuzzleGrid() {
    return SizedBox(
      width: 350,
      height: 350,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        itemCount: _puzzlePieces.length,
        itemBuilder: (context, index) {
          if (index == _missingIndex && _missingIndex != -1) {
            return Container();
          }

          int row = index ~/ gridSize;
          int col = index % gridSize;

          return ClipPath(
            clipper: PuzzlePieceClipper(
              row: row,
              col: col,
              totalRows: gridSize,
              totalCols: gridSize,
            ),
            child: Image.memory(_puzzlePieces[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 161, 213, 232)),
          if (_imageFile != null)
            Opacity(
              opacity: 0.5,
              child: Image.file(
                _imageFile!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _imageFile == null
                          ? Text(
                            'لطفاً یک عکس انتخاب کنید.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          )
                          : _buildPuzzleGrid(),
                      SizedBox(height: 20),
                      _imageFile == null
                          ? ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('انتخاب عکس'),
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  color: Color.fromARGB(255, 19, 13, 41),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'چالش پازل',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 110, // کاهش ارتفاع برای جا شدن کامل 6 عکس
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 33, 31, 49),
                        ),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(6),
                          physics: NeverScrollableScrollPhysics(), // حذف اسکرول
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio:
                                2.3, // باعث میشه قطعه کمی کشیده‌تر و کوچیک‌تر بشه
                          ),
                          itemCount: _options.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _checkAnswer(_options[index]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.memory(
                                  _puzzlePieces[index],
                                  fit: BoxFit.fill, // بهتر از cover برای پازل
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'تمام',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Text(
                              'پازل درست را انتخاب کنید',
                              style: TextStyle(color: Colors.white24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
