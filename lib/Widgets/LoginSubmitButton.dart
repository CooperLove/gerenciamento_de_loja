import 'package:flutter/material.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton(this.stream, this.onSubmit, {Key key})
      : super(key: key);

  final Stream stream;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData ? onSubmit : null,
            child: Text("Entrar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor)),
          );
        });
  }
}
