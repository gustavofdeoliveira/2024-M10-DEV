import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/controller/home_controller.dart';
import 'package:mobile/pages/imaga_page.dart';
import 'package:mobile/services/local_notification.dart';
import 'package:mobile/services/photo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  final ImagePicker _picker = ImagePicker();
  final PhotoService _imageService = PhotoService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
    controller.start();
  }

  _start() {
    return Container();
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          isLoading = true;
        });
        await LocalNotificationService.showTextNotification(
          title: 'Envio de Imagem',
          body: 'A imagem está sendo enviada.',
        );

        var pathImage = await _imageService.uploadImage(
            File(pickedFile.path), pickedFile.path, pickedFile.name);

        await LocalNotificationService.showTextNotification(
          title: 'Upload de Imagem',
          body: 'Sua imagem foi processada com sucesso!',
        );

        _viewPhoto(pathImage);
      }
    } catch (e) {
      print('Failed to take photo: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to take photo')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _viewPhoto(String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePathWidget(imageUrl: filename),
      ),
    );
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    setState(() {
      controller.start();
      // Reversing items to simulate data change
      controller.photos = controller.photos.reversed.toList();
    });
  }

  _success() {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ListView.builder(
        itemCount: controller.photos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Photo: ${controller.photos[index].fileName}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // Importante para evitar overflow
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePathWidget(
                          imageUrl: controller.photos[index].url ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _error() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {});
        },
        child: const Text('Try again'),
      ),
    );
  }

  _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  stateManagement(state) {
    switch (state) {
      case HomeState.start:
        return _start();
      case HomeState.loading:
        return _loading();
      case HomeState.success:
        return _success();
      case HomeState.error:
        return _error();
      default:
        return _start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos Page'),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) {
          return stateManagement(controller.state.value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
