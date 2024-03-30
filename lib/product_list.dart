import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/common_tools/delete_feature.dart';
import 'package:onlineshop/product_model.dart';

import 'cartlist.dart';

String? ID;
var PHOTOGRAPH_FIRE = "Product";
var PHOTOGRAPH = "Photograph";

class ProductMain extends StatefulWidget {
  const ProductMain({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductMain> {
  List<ProductItem> cartItems = []; // List to store selected products


  @override
  Widget build(BuildContext context) {
    var reference = FirebaseFirestore.instance.collection(PHOTOGRAPH_FIRE);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart screen when the cart icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: StreamBuilder(
            stream: reference
                .where('ID', isEqualTo: ID)
                .orderBy('FileName', descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children:
                  List.generate(snapshot.data!.size, (index) {
                    return GestureDetector(
                      onTap: () {
                        // Add product to cart when tapped
                        setState(() {
                          cartItems.add(ProductItem('2', snapshot.data!.docs
                              .map((e) => e['Name'])
                              .elementAt(index), snapshot.data!.docs
                              .map((e) => e['Price'])
                              .elementAt(index), snapshot.data!.docs
                              .map((e) => e['URL'])
                              .elementAt(index)));
                        });
                      },
                      onLongPress: () {
                        deleteFireDialog(
                            context,
                            snapshot.data!.docs.elementAt(index).reference,
                            snapshot.data!.docs
                                .map((e) => e['URL'])
                                .elementAt(index),
                                () {});
                      },
                      child: Hero(
                        tag: snapshot.data!.docs
                            .map((e) => e['URL'])
                            .elementAt(index),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.green,
                                  style: BorderStyle.solid,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(snapshot.data!.docs
                                      .map((e) => e["URL"])
                                      .elementAt(index)
                                      .toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Text(
                                snapshot.data!.docs
                                    .map((e) => e['Time'])
                                    .elementAt(index) +
                                    " " +
                                    snapshot.data!.docs
                                        .map((e) => e['Date'])
                                        .elementAt(index),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 25,
                              right: 10,
                              child: Text(
                                snapshot.data!.docs
                                    .map((e) => e['Name'])
                                    .elementAt(index),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
