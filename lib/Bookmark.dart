import 'package:bookstore/Backend/ConnectFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookMark extends StatelessWidget {
  const BookMark({super.key});

  Widget _cartItems() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('bookmark').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return Container(
              height: 100,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    _item(snapshot.data!.docs[index].data(), context),
              ),
            );
          } else {
            return Container(
              child: const Center(
                child: Text("No items has been added yet"),
              ),
            );
          }
        }
      },
    );
  }

  Widget _item(snap, context) {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Image.asset(snap['image url']),
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
            title: Text(
              snap['product name'],
            ),
            subtitle: Row(
              children: <Widget>[
                Text(
                  '\$ ',
                ),
                Text(
                  snap['price'].toString(),
                ),
              ],
            ),
            trailing: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete item"),
                      content: const Text(
                          "Do you want to remove the selected item from cart?"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              String res = await ConnectFirebase()
                                  .del(productId: snap['product id']);
                              if (res == 'success') {
                                Navigator.of(context).pop();

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Selected Item Deleted Successfully")));
                              }
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"))
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete)),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _cartItems(),
            Divider(
              thickness: 1,
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
