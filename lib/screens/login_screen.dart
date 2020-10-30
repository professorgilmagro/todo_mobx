import 'package:cube_transition/cube_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/stores/login.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginStore _loginStore;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(
                      builder: (_) => CustomTextField(
                        hint: 'E-mail',
                        prefix: Icon(Icons.account_circle),
                        textInputType: TextInputType.emailAddress,
                        onChanged: _loginStore.setEmail,
                        enabled: !_loginStore.loading,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(
                      builder: (context) => CustomTextField(
                        hint: 'Senha',
                        prefix: Icon(Icons.lock),
                        obscure: !_loginStore.showPass,
                        onChanged: _loginStore.setPassword,
                        enabled: !_loginStore.loading,
                        suffix: CustomIconButton(
                          radius: 32,
                          iconData: _loginStore.showPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onTap: () {
                            _loginStore.togglePassVisibility();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: Observer(
                        builder: (BuildContext context) {
                          return RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: _loginStore.loading
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white)),
                                      height: 20.0,
                                      width: 20.0,
                                    )
                                  : Text('Login'),
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                                  Theme.of(context).primaryColor.withAlpha(100),
                              textColor: Colors.white,
                              onPressed: _loginStore.loginPressed);
                        },
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  ReactionDisposer disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginStore = Provider.of<LoginStore>(context);
    disposer = reaction((_) => _loginStore.loggedIn, (loggedIn) {
      Navigator.of(context).push(
        CubePageRoute(
          enterPage: ListScreen(),
          exitPage: this.widget,
          duration: Duration(milliseconds: 900),
        ),
      );
    });
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }
}
