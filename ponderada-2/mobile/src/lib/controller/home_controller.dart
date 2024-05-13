import 'package:flutter/material.dart';
import 'package:mobile/models/tags.dart';
import 'package:mobile/repositories/tags_repository.dart';

class HomeController {
  List<Tag> tags = [];
  final TagsRepository _tagsRepository;
  final state = ValueNotifier<HomeState>(HomeState.start);

  HomeController([TagsRepository? tagsRepository])
      : _tagsRepository = tagsRepository ?? TagsRepository();

  Future start() async {
    state.value = HomeState.loading;
    try {
      tags = await _tagsRepository.fetchTags();
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
