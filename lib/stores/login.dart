import 'package:email_validator/email_validator.dart';
import 'package:mobx/mobx.dart';

part 'login.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  _LoginStore() {
    autorun((_) {});
  }

  @observable
  bool showPass = false;

  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  bool loading = false;

  @observable
  bool loggedIn = false;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @action
  void togglePassVisibility() => showPass = !showPass;

  @computed
  Function get loginPressed {
    if (isValidEmail && password.length > 6 && !loading) {
      return login;
    }

    return null;
  }

  @computed
  bool get isValidEmail {
    return EmailValidator.validate(email);
  }

  @action
  Future<void> login() async {
    loading = true;
    await Future.delayed(Duration(seconds: 2));
    loading = false;
    loggedIn = true;
  }

  @action
  Future<void> logout() async {
    loading = true;
    await Future.delayed(Duration(seconds: 1));
    loading = false;
    loggedIn = false;
  }
}
