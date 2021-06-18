import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Tiles/CategoryTile.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({Key key}) : super(key: key);

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          );
        }

        return ListView.builder(
            itemCount: snapshot.data.size,
            itemBuilder: (context, index) {
              return CategoryTile(snapshot.data.docs[index]);
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
