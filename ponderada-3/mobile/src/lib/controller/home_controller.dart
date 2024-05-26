import 'package:flutter/material.dart';
import 'package:mobile/models/tags.dart';
import 'package:mobile/services/photo_repository.dart';

class HomeController {
  List<Tag> tags = [];
  var tag = Tag();
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

  Future delete(BuildContext context, idTag) async {
    state.value = HomeState.loading;
    try {
      tag = await _tagsRepository.deleteTag(idTag);
      state.value = HomeState.success;
    } catch (e) {
      state.value = HomeState.error;
    }
  }

  Future update(BuildContext context, idTag, name, description) async {
    state.value = HomeState.loading;
    try {
      tag = await _tagsRepository.updateTag(idTag, name, description);
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacementNamed(context, '/home');
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
