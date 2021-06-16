import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List<DocumentSnapshot>>();

  List<DocumentSnapshot> _orders = [];

  ValueStream<List<DocumentSnapshot>> get outOrders => _ordersController.stream;

  OrdersBloc() {
    _addOrdersListener();
  }

  _addOrdersListener() {
    FirebaseFirestore.instance
        .collection("orders")
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String uid = change.doc.id;
        print("New order: $uid");

        switch (change.type) {
          case DocumentChangeType.added:
            print("Adding order: $uid");
            _orders.add(change.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.id == uid);
            _orders.add(change.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.id == uid);
            break;
          default:
        }
      });
      _ordersController.add(_orders);
    });
  }

  @override
  void dispose() {
    _ordersController.close();
    super.dispose();
  }
}
