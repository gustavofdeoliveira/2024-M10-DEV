// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mobile/models/tags.dart';
import 'package:mobile/repositories/tags_repository.dart';

class CreateController {
  var tag = Tag();
  final TagsRepository _tagsRepository;
  final state = ValueNotifier<CreateState>(CreateState.start);

  CreateController([TagsRepository? tagsRepository])
      : _tagsRepository = tagsRepository ?? TagsRepository();

  Future create(BuildContext context, name, description) async {
    state.value = CreateState.loading;
    try {
      tag = await _tagsRepository.createTag(name, description);
      await Navigator.pushReplacementNamed(context, '/home');
      state.value = CreateState.success;
    } catch (e) {
      state.value = CreateState.error;
    }
  }
}

enum CreateState {
  start,
  loading,
  success,
  error,
}
