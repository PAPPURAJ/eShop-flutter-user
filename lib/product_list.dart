import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/common_tools/delete_feature.dart';
import 'package:onlineshop/product_model.dart';

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

class CartScreen extends StatelessWidget {
  final List<ProductItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cartItems[index].image_url ?? ''),
            ),
            title: Text(cartItems[index].name!),
            subtitle: Text('Price: \৳${cartItems[index].price ?? '0.00'}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _placeOrder(context);
        },
        label: Text('Place Order'),
        icon: Icon(Icons.check),
      ),
    );
  }

  void _placeOrder(BuildContext context) async {
    try {
      // Get a Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the 'orderList' collection
      CollectionReference orders = firestore.collection('orderList');

      // Create a new document with a unique ID
      await orders.add({
        'products': cartItems.map((item) {
          return {
            'id': item.id,
            'name': item.name,
            'price': item.price,
            'imageUrl': item.image_url,
          };
        }).toList(),
        'timestamp': Timestamp.now(), // Optional: You can add a timestamp for the order
      });

      cartItems.clear();
      // Clear the cart after placing the order
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Order placed successfully!'),
      ));
    } catch (e) {
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to place order.'),
      ));
    }
  }
}