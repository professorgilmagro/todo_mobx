import 'package:cube_transition/cube_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/stores/list.dart';
import 'package:todomobx/stores/login.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'login_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  LoginStore loginStore;
  final listStore = ListStore();
  final textController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginStore = Provider.of<LoginStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tarefas',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32),
                    ),
                    Observer(
                      builder: (_) => loginStore.loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.exit_to_app),
                              color: Colors.white,
                              onPressed: () {
                                loginStore.logout().then((value) {
                                  Navigator.of(context).push(
                                    CubePageRoute(
                                      enterPage: LoginScreen(),
                                      exitPage: this.widget,
                                      duration: Duration(milliseconds: 900),
                                    ),
                                  );
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Observer(
                      builder: (_) => Column(
                        children: <Widget>[
                          CustomTextField(
                            controller: textController,
                            hint: 'Tarefa',
                            onChanged: listStore.setNewTodoTitle,
                            suffix: listStore.isFormValid
                                ? CustomIconButton(
                                    radius: 32,
                                    iconData: Icons.add,
                                    onTap: () {
                                      listStore.addTodo();
                                      textController.clear();
                                    },
                                  )
                                : null,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Observer(
                              builder: (_) => ListView.separated(
                                itemCount: listStore.todoList.length,
                                itemBuilder: (_, index) {
                                  final todo = listStore.todoList[index];
                                  return Observer(
                                    builder: (_) => ListTile(
                                      title: Text(
                                        todo.title,
                                        style: TextStyle(
                                          color: todo.done
                                              ? Colors.grey
                                              : Colors.black,
                                          decoration: todo.done
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      trailing: Icon(
                                        todo.done
                                            ? Icons.check_circle_rounded
                                            : Icons.radio_button_unchecked,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onTap: todo.toggleDone,
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) {
                                  return Divider();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
