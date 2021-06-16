import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/UserBloc.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.snapshot, {Key key}) : super(key: key);

  final DocumentSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    final List status = [
      "",
      "Em preparação",
      "Em transporte",
      "Aguardando entrega",
      "Entregue"
    ];

    return Container(
      child: Card(
        child: ExpansionTile(
          title: Text(
            "#${snapshot.id.substring(snapshot.id.length - 7)} - ${status[snapshot["status"]]}",
            style: TextStyle(
                color:
                    snapshot["status"] != 4 ? Colors.grey[850] : Colors.green),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 0.0, bottom: 8.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(BlocProvider.getBloc<UserBloc>()
                        .getUser(snapshot["clientId"])["name"]),
                    subtitle: Text(BlocProvider.getBloc<UserBloc>()
                        .getUser(snapshot["clientId"])["address"]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Products: R\$ ${snapshot["productsPrice"]}"),
                        Text("Total: R\$ ${snapshot["totalPrice"]}"),
                      ],
                    ),
                  ),
                  Column(
                    children: snapshot["products"].map<Widget>((p) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(p["product"]["title"]),
                        subtitle: Text("${p["category"]}/${p["pid"]}"),
                        trailing: Text(p["quantity"].toString()),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(snapshot["clientId"])
                              .collection("orders")
                              .doc(snapshot.id)
                              .delete();
                          snapshot.reference.delete();
                        },
                        child: Text("Excluir"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: snapshot["status"] > 1
                            ? () {
                                snapshot.reference
                                    .update({"status": snapshot["status"] - 1});
                              }
                            : null,
                        child: Text("Regredir"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: snapshot["status"] < 4
                            ? () {
                                snapshot.reference
                                    .update({"status": snapshot["status"] + 1});
                              }
                            : null,
                        child: Text("Avançar"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
