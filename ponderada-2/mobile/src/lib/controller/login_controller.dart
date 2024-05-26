import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/repositories/user_repository.dart';

class LoginController {
  var user = User();

  final UserRepository _userRepository;
  final state = ValueNotifier<LoginState>(LoginState.start);

  LoginController([UserRepository? userRepository])
      : _userRepository = userRepository ?? UserRepository();

  Future start(BuildContext context, String email, String password) async {
    state.value = LoginState.loading;
    try {
      user = await _userRepository.fetchLogin(email, password);
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacementNamed(context, '/home');
      state.value = LoginState.success;
    } catch (e) {
      state.value = LoginState.error;
    }
  }
}

enum LoginState {
  start,
  loading,
  success,
  error,
}
