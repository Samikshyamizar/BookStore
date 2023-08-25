import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectFirebase {
  Future<String> register(
      {required String name,
      required String email,
      required String pwd}) async {
    String res = "error";

    try {
      if (name.isNotEmpty || email.isNotEmpty || pwd.isNotEmpty) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pwd);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "user name": name,
          "email": email,
          "user id": FirebaseAuth.instance.currentUser!.uid
        });
        res = 'success';
      }
    } catch (error) {
      print(error);
    }
    return res;
  }

  Future<String> login({required String email, required String pwd}) async {
    String res = "error";

    if (email.isNotEmpty || pwd.isNotEmpty) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);

      res = 'success';
    }
    return res;
  }

  Future<String> addCart({
    //   required String name,
    // required String address,
    // required String contact,
    required String productName,
    required String img,
    required String price,
  }) async {
    String res = "error";

    String productId = const Uuid().v1();
    await FirebaseFirestore.instance.collection("cart").doc(productId).set({
      // "customer name": name,
      // "customer contact": contact,
      // "customer address": address,
      "product name": productName,
      "image url": img,
      "product id": productId,
      "price": price,
    });
    res = 'success';

    return res;
  }

  Future<String> del({required String productId}) async {
    String res = 'error';
    if (productId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(productId)
          .delete();
      res = "success";
    }

    return res;
  }

  Future<String> newQuantity(
      {required String productId, required String quantity}) async {
    String res = 'error';

    if (productId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(productId)
          .update({'quantity': quantity});
      res = 'success';
    }

    return res;
  }
}
