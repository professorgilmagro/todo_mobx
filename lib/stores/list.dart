import 'package:mobx/mobx.dart';
import 'package:todomobx/stores/todo.dart';

part 'list.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  @observable
  String newTodoTitle = "";

  @action
  void setNewTodoTitle(String title) => newTodoTitle = title;

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;

  ObservableList<TodoStore> todoList = ObservableList<TodoStore>();

  @action
  void addTodo() {
    final todo = TodoStore(newTodoTitle);
    todoList.insert(0, todo);
    newTodoTitle = '';
  }
}
