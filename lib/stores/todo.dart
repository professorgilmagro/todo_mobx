import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  String title;

  _TodoStore(this.title);

  @observable
  bool done = false;

  @action
  void toggleDone() => done = !done;
}
