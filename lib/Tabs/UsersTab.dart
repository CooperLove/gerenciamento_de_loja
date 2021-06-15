import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Tiles/UserTile.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none),
        ),
        Expanded(
            child: ListView.separated(
                // padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return UserTile();
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.white60);
                },
                itemCount: 20))
      ],
    );
  }
}
