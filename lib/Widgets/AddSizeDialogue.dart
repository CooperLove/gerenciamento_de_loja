import 'package:flutter/material.dart';

class AddSizeDialogue extends StatelessWidget {
  AddSizeDialogue({Key key}) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ))
          ],
        ),
      ),
    );
  }
}
