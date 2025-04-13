import 'package:first_challenge/componand/image_referenece.dart';
import 'package:flutter/material.dart';

class CaptchaPage extends StatefulWidget {
  @override
  State<CaptchaPage> createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> {
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = ImageService.getRandomImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('چالش کپچا تصویری')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 270,
              width: 500,
              child: Image.network(
                imageUrl,
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('عکس جدید'),
              onPressed: () {
                setState(() {
                  imageUrl = ImageService.getRandomImageUrl();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
