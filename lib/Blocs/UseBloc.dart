import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject();

  Map<String, Map> _users = {};

  UserBloc() {
    addUserListener();
  }

  void addUserListener() {
    FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String uid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.doc.data();
            subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.doc.data());
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            unsubscribeToOrders(uid);
            _users[uid].remove(uid);
            _usersController.add(_users.values.toList());
            break;
          default:
        }
      });
    });
  }

  void subscribeToOrders(String uid) async {
    _users[uid]["subscription"] = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders")
        .snapshots()
        .listen((snapshot) async {
      int pedidos = snapshot.docs.length;
      double moneySpent = 0.0;

      for (DocumentSnapshot doc in snapshot.docs) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection("orders")
            .doc(doc.id)
            .get();

        if (snap == null) continue;

        moneySpent += snap["totalPrice"];
      }

      _users[uid].addAll({"numOrders": pedidos, "moneySpent": moneySpent});

      _usersController.add(_users.values.toList());
    });
  }

  void unsubscribeToOrders(String uid) {
    _users[uid]["subscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
    super.dispose();
  }
}
