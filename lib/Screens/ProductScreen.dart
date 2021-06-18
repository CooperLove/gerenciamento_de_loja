import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/ProductBloc.dart';
import 'package:gerenciamento_de_loja/Validators/ProductValidator.dart';
import 'package:gerenciamento_de_loja/Widgets/ImagesWidget.dart';
import 'package:gerenciamento_de_loja/Widgets/ProductSizes.dart';

class ProductScreen extends StatelessWidget with ProductValidator {
  ProductScreen(this._categoryId, this._document, this._productBloc, {Key key})
      : super(key: key);

  final String _categoryId;
  final DocumentSnapshot _document;
  final ProductBloc _productBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: StreamBuilder<bool>(
              stream: _productBloc.outCreated,
              initialData: false,
              builder: (context, snapshot) {
                return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
              }),
          actions: [
            StreamBuilder<bool>(
                stream: _productBloc.outCreated,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StreamBuilder<bool>(
                        stream: _productBloc.outCreated,
                        initialData: false,
                        builder: (context, snapshot) {
                          return IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: snapshot.data
                                ? () {
                                    _productBloc.deleteProduct();
                                    Navigator.of(context).pop();
                                  }
                                : null,
                          );
                        });
                  }
                  return Container();
                }),
            StreamBuilder<bool>(
                stream: _productBloc.outLoading,
                initialData: false,
                builder: (context, snapshot) {
                  return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: snapshot.data ? null : saveProduct,
                  );
                }),
          ],
        ),
        body: Stack(
          children: [
            _form(),
            StreamBuilder<bool>(
                stream: _productBloc.outLoading,
                initialData: false,
                builder: (context, snapshot) {
                  return IgnorePointer(
                    ignoring: !snapshot.data,
                    child: Container(
                      color:
                          snapshot.data ? Colors.black54 : Colors.transparent,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: StreamBuilder<Map>(
          stream: _productBloc.outData.cast(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              );
            }
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                ImagesWidget(
                  context: context,
                  initialValue: snapshot.data["images"],
                  onSaved: _productBloc.saveImages,
                  validator: imagesValidator,
                ),
                _textFormField("Titulo", snapshot.data["title"] ?? "dwda",
                    _productBloc.saveTitle, titleValidator),
                _textFormField(
                    "Descrição",
                    snapshot.data["description"] ?? "ewq",
                    _productBloc.saveDescription,
                    descriptionValidator,
                    maxLines: 6),
                _textFormField(
                    "Preço",
                    snapshot.data["price"]?.toStringAsFixed(2) ??
                        (9.99).toString(),
                    _productBloc.savePrice,
                    priceValidator,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true)),
                SizedBox(
                  height: 16.0,
                ),
                ProductSizes(
                  context: context,
                  initialValue: snapshot.data["sizes"],
                  onSaved: _productBloc.saveSizes,
                  validator: (s) {
                    if (s.isEmpty) return "Adicione um tamanho";
                    return null;
                  },
                ),
              ],
            );
          }),
    );
  }

  Widget _textFormField(
      String label, String initialValue, Function onSaved, Function validator,
      {TextInputType keyboardType = TextInputType.multiline,
      int maxLines = 2}) {
    return TextFormField(
      minLines: 1,
      maxLines: maxLines,
      keyboardType: keyboardType,
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontSize: 17)),
      style: TextStyle(color: Colors.white),
      validator: validator,
      onSaved: onSaved,
    );
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("Salvando produto...."),
          backgroundColor: Colors.pinkAccent[400],
          duration: Duration(minutes: 1),
        ),
      );

      bool success = await _productBloc.saveProduct();

      ScaffoldMessenger.of(_scaffoldKey.currentContext).removeCurrentSnackBar();

      ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(success
              ? "Produto salvo com sucesso"
              : "Falha ao salvar produto"),
          backgroundColor: Colors.pinkAccent[400],
        ),
      );
    }
  }
}
