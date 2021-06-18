import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/CategoryBloc.dart';
import 'package:gerenciamento_de_loja/Blocs/ProductBloc.dart';
import 'package:gerenciamento_de_loja/Screens/ProductScreen.dart';
import 'package:gerenciamento_de_loja/Widgets/EditCategoryDialogue.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile(this._category, {Key key}) : super(key: key);
  final DocumentSnapshot _category;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: ExpansionTile(
          title: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => EditCategoryDialogue(
                          categoryBloc: CategoryBloc(_category),
                        ));
              },
              child: Text(_category["title"])),
          children: [
            FutureBuilder<QuerySnapshot>(
                future: _category.reference.collection("items").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  return Column(
                    children: snapshot.data.docs
                        .map((d) => ListTile(
                              leading: Image.network(
                                d["images"][0],
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(d["title"]),
                              trailing: Text("R\$ ${d["price"]}"),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                        _category.id,
                                        d,
                                        ProductBloc(
                                            categoryId: _category.id,
                                            document: d))));
                              },
                            ))
                        .toList(),
                  );
                }),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductScreen(
                          _category.id,
                          null,
                          ProductBloc(
                              categoryId: _category.id, document: null))));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "Adicionar Produto",
                    style: TextStyle(color: Colors.blue),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
