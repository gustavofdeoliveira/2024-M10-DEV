import 'package:flutter/material.dart';
import 'package:mobile/models/photo.dart';

import 'package:mobile/services/photo_service.dart';

class HomeController {
  List<Photo> photos = [];
  var photo = Photo();
  final PhotoService _photoService;
  final state = ValueNotifier<HomeState>(HomeState.start);

  HomeController([PhotoService? photoService])
      : _photoService = photoService ?? PhotoService();

  Future start() async {
    state.value = HomeState.loading;
    try {
      photos = await _photoService.fetchTags();
      state.value = HomeState.success;
    } catch (e) {
      state.value = HomeState.error;
    }
  }
}

enum HomeState {
  start,
  loading,
  success,
  error,
}
