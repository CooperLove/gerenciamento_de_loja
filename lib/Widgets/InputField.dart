import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      this.hint, this.icon, this.obscure, this.stream, this.onChanged,
      {Key key})
      : super(key: key);

  final hint;
  final IconData icon;
  final obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
          decoration: InputDecoration(
              hintText: hint,
              errorText: snapshot.hasError ? snapshot.error : null,
              hintStyle: TextStyle(color: Colors.white54),
              icon: Icon(
                icon,
                color: Colors.white54,
              ),
              contentPadding:
                  EdgeInsets.only(left: 5, right: 30, bottom: 10, top: 30)),
        );
      },
    );
  }
}
