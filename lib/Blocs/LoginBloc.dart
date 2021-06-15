import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciamento_de_loja/Validators/LoginValidator.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  ValueStream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  ValueStream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  ValueStream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid =>
      Rx.combineLatest2(outEmail, outPassword, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;

  LoginBloc() {
    _init();
  }

  void _init() async {
    await Firebase.initializeApp();
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      print("Auth changed");
      if (user != null) {
        bool canLogin = await verifyPrevileges(user);
        print(canLogin);
        if (canLogin) {
          _stateController.add(LoginState.SUCCESS);
          // FirebaseAuth.instance.signOut();
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  void submit() async {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);
    print("State: ${outState.value}");
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrevileges(User user) async {
    return await FirebaseFirestore.instance
        .collection("admins")
        .doc(user.uid)
        .get()
        .then((doc) {
      return doc.data() != null;
    }).catchError((e) => false);
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _streamSubscription.cancel();
    super.dispose();
  }
}
