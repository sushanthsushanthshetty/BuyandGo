// CartPage.dart
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Sample cart items - in a real app, you would use state management
  List<CartItem> _cartItems = [
    CartItem(
      id: 'p1',
      name: 'Wireless Headphones',
      price: 5999,
      quantity: 1,
      image: 'https://example.com/headphones.jpg',
    ),
    CartItem(
      id: 'p2',
      name: 'Laptop',
      price: 11249,
      quantity: 2,
      image: 'https://example.com/smartwatch.jpg',
    ),
    CartItem(
      id: 'p3',
      name: 'Bluetooth Speaker',
      price: 4499,
      quantity: 1,
      image: 'assets/mac.png',
    ),
  ];

  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Logic to restore the item would go here
          },
        ),
      ),
    );
  }

  void _updateQuantity(String id, int newQuantity) {
    if (newQuantity < 1) {
      _removeItem(id);
      return;
    }
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index >= 0) {
        _cartItems[index] = CartItem(
          id: _cartItems[index].id,
          name: _cartItems[index].name,
          price: _cartItems[index].price,
          quantity: newQuantity,
          image: _cartItems[index].image,
        );
      }
    });
  }

  double get _totalAmount {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: _cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Add items to get started'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (ctx, index) {
                      final item = _cartItems[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _removeItem(item.id);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.shade200,
                                child: item.image.startsWith('assets/')
                                    ? Image.asset(item.image)
                                    : (item.image.startsWith('http')
                                        ? Image.network(
                                            item.image,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.image,
                                                  color: Colors.grey);
                                            },
                                          )
                                        : Icon(Icons.image,
                                            color: Colors.grey)),
                              ),
                              title: Text(item.name),
                              subtitle:
                                  Text('₹${item.price.toStringAsFixed(2)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _updateQuantity(
                                        item.id, item.quantity - 1),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[200],
                                    ),
                                    child: Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => _updateQuantity(
                                        item.id, item.quantity + 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '₹${_totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Shipping',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              _totalAmount > 10000 ? 'FREE' : '₹499',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    _totalAmount > 10000 ? Colors.green : null,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${(_totalAmount + (_totalAmount > 10000 ? 0 : 499)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _cartItems.isEmpty
                                ? null
                                : () {
                                    // Checkout logic
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Proceeding to checkout...'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                            child: const Text(
                              'PROCEED TO CHECKOUT',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Continue Shopping'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// Modifications to HomePage.dart - only showing the changes needed:

// Add this import at the top of HomePage.dart
// import 'CartPage.dart';

// Update the shopping cart icon onPressed method in HomePage.dart
// Replace the // TODO: Implement cart functionality with:
/*
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CartPage(),
    ),
  );
},
*/

// You can also add a method in HomePage to add products to cart:
/*
void _addToCart(Map<String, dynamic> product) {
  // In a real app, you would use state management to add to cart
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${product['name']} added to cart'),
      duration: const Duration(seconds: 2),
    ),
  );
  
  // Navigate to cart option
  // Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
}
*/

// Then update the add button in the featured products grid to use this method:
/*
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  child: InkWell(
    onTap: () => _addToCart(_featuredProducts[index]),
    child: const Padding(
      padding: EdgeInsets.all(4.0),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
    ),
  ),
),
*/
