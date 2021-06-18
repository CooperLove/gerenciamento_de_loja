import 'package:flutter/material.dart';
import 'package:gerenciamento_de_loja/Blocs/CategoryBloc.dart';

class EditCategoryDialogue extends StatelessWidget {
  const EditCategoryDialogue({this.categoryBloc, Key key}) : super(key: key);

  final CategoryBloc categoryBloc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Editar nome da categoria",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
            ListTile(
              title: TextField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                    stream: categoryBloc.outDelete,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return TextButton(
                          onPressed: snapshot.data ? () {} : null,
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                                color:
                                    !snapshot.data ? Colors.grey : Colors.red),
                          ));
                    }),
                TextButton(onPressed: () {}, child: Text("Salvar")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
