import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/UseBloc.dart';
import 'package:gerenciamento_de_loja/Tiles/UserTile.dart';
import 'package:shimmer/shimmer.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: BlocProvider.getBloc<UserBloc>().onSearch,
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
            child: StreamBuilder(
          stream: BlocProvider.getBloc<UserBloc>().outUsers.cast(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent[900])),
              );
            else if (snapshot.data.length == 0)
              return Center(
                  child: Text("Nenhum usuário encontrado!",
                      style: TextStyle(color: Colors.pinkAccent[900])));
            else
              return ListView.separated(
                  // padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return UserTile(snapshot.data[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.white60);
                  },
                  itemCount: snapshot.data.length);
          },
        ))
      ],
    );
  }
}
