import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  String categoryId;
  DocumentSnapshot document;
  Map<String, dynamic> unsaveData = {};

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  ValueStream<Map> get outData => _dataController.stream;
  ValueStream<bool> get outLoading => _loadingController.stream;
  ValueStream<bool> get outCreated => _createdController.stream;

  ProductBloc({this.categoryId, this.document}) {
    if (document != null) {
      unsaveData = Map.of(document.data());
      unsaveData["images"] = List.of(document["images"]);
      unsaveData["sizes"] = List.of(document["sizes"]);
      _createdController.add(true);
    } else {
      unsaveData = {
        "title": null,
        "description": null,
        "price": null,
        "images": [],
        "sizes": []
      };
      _createdController.add(false);
    }

    _dataController.add(unsaveData);
  }

  void saveTitle(String text) {
    unsaveData["title"] = text;
  }

  void saveDescription(String text) {
    unsaveData["description"] = text;
  }

  void savePrice(String text) {
    unsaveData["price"] = double.parse(text);
  }

  void saveImages(List images) {
    unsaveData["images"] = images;
  }

  void saveSizes(List sizes) {
    unsaveData["sizes"] = sizes;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);
    try {
      if (document != null) {
        unsaveData["images"] = await _uploadImages(document.id);
        await document.reference.update(unsaveData);
      } else {
        print(categoryId);
        DocumentReference dr = await FirebaseFirestore.instance
            .collection("products")
            .doc(categoryId)
            .collection("items")
            .add(Map.from(unsaveData)..remove("images"));

        unsaveData["images"] = await _uploadImages(dr.id);
        await dr.update(unsaveData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      print("Error: $e");
      // await Future.delayed(Duration(seconds: 2));
      _loadingController.add(false);
      return false;
    }
  }

  Future<List> _uploadImages(String productId) async {
    List<String> images = [];
    print("Salvando $productId em $categoryId");
    for (var i = 0; i < unsaveData["images"].length; i++) {
      if (unsaveData["images"][i] is String) {
        images.add(unsaveData["images"][i]);

        continue;
      }

      print("File: ${unsaveData["images"][i]}");
      await FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsaveData["images"][i])
          .then((snapshot) async {
        print(snapshot);
        String downloadUrl = await snapshot.ref.getDownloadURL().then((value) {
          return value;
        });
        images.add(downloadUrl);
      });
    }
    return images;
  }

  void deleteProduct() {
    document.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
    super.dispose();
  }
}
