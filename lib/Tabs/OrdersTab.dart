import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/OrdersBloc.dart';
import 'package:gerenciamento_de_loja/Tiles/OrderTile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
        stream: BlocProvider.getBloc<OrdersBloc>().outOrders.cast(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.pinkAccent[700]),
            ));
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text("Nenhum pedido encontrado"),
            );
          } else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return OrderTile(snapshot.data[index]);
              },
            );
        },
      ),
    );
  }
}
