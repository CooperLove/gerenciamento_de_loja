import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/LoginBloc.dart';
import 'package:gerenciamento_de_loja/Widgets/InputField.dart';
import 'package:gerenciamento_de_loja/Widgets/LoginSubmitButton.dart';
import 'package:firebase_core/firebase_core.dart';

import 'HomePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginBloc = LoginBloc();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Erro de autenticação!"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:

        default:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _initFirebase();
  }

  Widget _initFirebase() {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _home();
        } else
          return Container();
      },
    );
  }

  Widget _home() {
    final primaryColor = Theme.of(context).primaryColor;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(16.0),
          child: StreamBuilder<LoginState>(
            stream: loginBloc.outState.cast(),
            initialData: LoginState.LOADING,
            builder: (context, snapshot) {
              print(snapshot.data);
              switch (snapshot.data) {
                case LoginState.LOADING:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                    ),
                  );
                case LoginState.IDLE:
                case LoginState.SUCCESS:
                case LoginState.FAIL:
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.store,
                          color: primaryColor,
                          size: 100,
                        ),
                        InputField("Usuário", Icons.person, false,
                            loginBloc.outEmail, loginBloc.changeEmail),
                        InputField("Senha", Icons.lock, true,
                            loginBloc.outPassword, loginBloc.changePassword),
                        SizedBox(
                          height: 32,
                        ),
                        LoginSubmitButton(
                            loginBloc.outSubmitValid, loginBloc.submit),
                      ],
                    ),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
