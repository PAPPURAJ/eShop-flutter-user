import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlineshop/common_tools/delete_feature.dart';
import 'package:onlineshop/product_model.dart';

class CartScreen extends StatefulWidget {
  final List<ProductItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.cartItems[index].image_url ?? ''),
            ),
            title: Text(widget.cartItems[index].name!),
            subtitle: Text('Price: \৳${widget.cartItems[index].price ?? '0.00'}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeItem(index);
              },
            ),
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
        'products': widget.cartItems.map((item) {
          return {
            'id': item.id,
            'name': item.name,
            'price': item.price,
            'imageUrl': item.image_url,
          };
        }).toList(),
        'timestamp': Timestamp.now(), // Optional: You can add a timestamp for the order
      });

      widget.cartItems.clear();
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

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }
}
