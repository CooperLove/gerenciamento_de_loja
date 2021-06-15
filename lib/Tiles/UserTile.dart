import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white);
    return ListTile(
      title: Text(
        "Title",
        style: textStyle,
      ),
      subtitle: Text(
        "Subitle",
        style: textStyle,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Pedidos 0",
            style: textStyle,
          ),
          Text(
            "Gasto R\$ 0.00",
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
