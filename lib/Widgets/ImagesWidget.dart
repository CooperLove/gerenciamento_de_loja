import 'package:flutter/material.dart';

import 'ImageSourceSheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget(
      {BuildContext context,
      FormFieldSetter<List> onSaved,
      FormFieldValidator<List> validator,
      List initialValue,
      AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autoValidateMode,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 124,
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value.map<Widget>((i) {
                        return Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            child:
                                i is String ? Image.network(i) : Image.file(i),
                            onLongPress: () {
                              state.didChange(state.value..remove(i));
                            },
                          ),
                        );
                      }).toList()
                        ..add(GestureDetector(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Icon(
                              Icons.camera_enhance,
                              color: Colors.white,
                            ),
                            color: Colors.white54,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => ImageSourceSheet(
                                      onImageSelected: (image) {
                                        state
                                            .didChange(state.value..add(image));
                                      },
                                    ));
                          },
                        )),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : Container(),
                ],
              );
            });
}
