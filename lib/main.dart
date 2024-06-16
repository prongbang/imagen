import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_filex/flutter_filex.dart';
import 'package:image/image.dart' as x;
import 'package:imagen/font/regular_100.dart';
import 'package:imagen/paint/certificate_custom_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<ui.Image> _loadImage(String imageAssetPath) async {
    final data = (await rootBundle.load(imageAssetPath));
    final bytes = data.buffer.asUint8List();
    return await decodeImageFromList(bytes);
  }

  final recorder = ui.PictureRecorder();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('A4 Image'),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Builder(builder: (context) {
            return FutureBuilder<ui.Image>(
                future: _loadImage('assets/images/a4.jpg'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FittedBox(
                      child: CustomPaint(
                        painter: CertificateCustomPainter(
                          snapshot.data!,
                        ),
                        size: const ui.Size(2480, 3508),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                });
            return FutureBuilder<Uint8List>(
              future: _loadAndResizeImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final image = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(child: Image.memory(image)),
                      TextButton(
                        onPressed: () async {
                          _processSave(image);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Future<Uint8List> _loadAndResizeImage() async {
    ByteData background = await rootBundle.load('assets/images/a4.jpg');
    Uint8List backgroundBytes = background.buffer.asUint8List();
    x.Image image = x.decodeImage(backgroundBytes)!;

    x.drawString(
      image,
      'MOCKRAWIT MITRAWOKKIYOTHINSAWONG',
      font: regular100,
      wrap: true,
      color: x.ColorFloat32.rgb(0, 0, 0),
    );

    // x.Image resizedImage = x.copyResize(image, width: A4_WIDTH_PX, height: A4_HEIGHT_PX);
    List<int> encodeImage = x.encodeJpg(image);
    return Uint8List.fromList(encodeImage);
  }

  void _processSave(Uint8List imageBytes) async {
    x.Image image = x.decodeImage(imageBytes)!;
    final jpeg = x.encodeJpg(image);

    // Write the PNG formatted data to a file.
    final directoryUtility = DownloadsDirectoryUtility();
    final fileXUtility = FileXProvider.create(directoryUtility);
    final fileX = FileX(
      prefix: 'imagen-',
      filename: 'a4',
      extension: FileX.jpeg,
      bytes: jpeg,
    );
    String path = await fileXUtility.write(fileX);
    print('path: $path');
  }
}
