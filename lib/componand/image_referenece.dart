// image_service.dart

import 'dart:math';

class ImageService {
  static final List<String> _imageUrls = [
    'https://picsum.photos/seed/picsum1/300/200',
    'https://picsum.photos/seed/picsum2/300/200',
    'https://picsum.photos/seed/picsum3/300/200',
  ];

  static String getRandomImageUrl() {
    final random = Random();
    return _imageUrls[random.nextInt(_imageUrls.length)];
  }
}
