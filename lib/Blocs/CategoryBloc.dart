import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase {
  final _titleController = BehaviorSubject<String>();
  final _deleteController = BehaviorSubject<bool>();

  ValueStream<String> get outTitle => _titleController.stream;
  ValueStream<bool> get outDelete => _deleteController.stream;

  DocumentSnapshot category;

  CategoryBloc(this.category) {
    if (category != null) {
      _titleController.add(category["title"]);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  @override
  void dispose() {
    _deleteController.close();
    _titleController.close();
    super.dispose();
  }
}
