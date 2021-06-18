import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddSizeDialogue.dart';

class ProductSizes extends FormField<List> {
  ProductSizes({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 34,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.5,
                        mainAxisSpacing: 8.0,
                        crossAxisCount: 1),
                    children: state.value.map<Widget>((s) {
                      return GestureDetector(
                        onLongPress: () {
                          state.didChange(state.value..remove(s));
                        },
                        child: Container(
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border:
                                Border.all(color: Colors.pinkAccent, width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text(s,
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      );
                    }).toList()
                      ..add(GestureDetector(
                        onTap: () async {
                          String size = await showDialog(
                              context: context,
                              builder: (context) => AddSizeDialogue());

                          if (size != null) {
                            state.didChange(state.value..add(size));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(
                                color: state.hasError
                                    ? Colors.red
                                    : Colors.pinkAccent,
                                width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text("+",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      )),
                  ),
                ),
                state.hasError
                    ? Text(
                        state.errorText,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container()
              ],
            );
          },
        );
}
