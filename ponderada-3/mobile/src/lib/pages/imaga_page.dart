import 'dart:io';
import 'package:flutter/material.dart';

class ImagePathWidget extends StatefulWidget {
  final String imageUrl;

  const ImagePathWidget({super.key, required this.imageUrl});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePathWidgetState createState() => _ImagePathWidgetState();
}

class _ImagePathWidgetState extends State<ImagePathWidget> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImageFromCache();
  }

  Future<void> _loadImageFromCache() async {
    try {
      final imagePath = widget.imageUrl;
      setState(() {
        _imageFile = File(imagePath);
      });
    } catch (e) {
      // Handle errors here
      print('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exibir Imagem'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Text('Imagem não encontrada'),
          ],
        ),
      ),
    );
  }
}
