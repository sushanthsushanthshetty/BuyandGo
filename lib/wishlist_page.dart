import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Sample wishlist it-ems
  List<WishlistItem> wishlistItems = [
    WishlistItem(
      id: '1',
      name: 'Wireless Headphones',
      price: 79.99,
      imageUrl: 'https://example.com/headphones.jpg',
      inStock: true,
    ),
    WishlistItem(
      id: '2',
      name: 'Smart Watch',
      price: 129.99,
      imageUrl: 'https://example.com/watch.jpg',
      inStock: true,
    ),
    WishlistItem(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 59.99,
      imageUrl: 'https://example.com/speaker.jpg',
      inStock: false,
    ),
    WishlistItem(
      id: '4',
      name: 'Mechanical Keyboard',
      price: 89.99,
      imageUrl: 'https://example.com/keyboard.jpg',
      inStock: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navigate to cart')),
              );
            },
          ),
        ],
      ),
      body: wishlistItems.isEmpty
          ? _buildEmptyWishlist()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${wishlistItems.length} items',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add all in-stock items to cart
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('All in-stock items added to cart'),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                onPressed: () {
                                  // Navigate to cart
                                },
                              ),
                            ),
                          );
                        },
                        child: Text('Add All to Cart'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      return _buildWishlistItem(wishlistItems[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Save items you love to your wishlist',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to products page
              Navigator.pop(context);
            },
            child: Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(WishlistItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          wishlistItems.remove(item);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} removed from wishlist'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  wishlistItems.add(item);
                });
              },
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                ),
              ),
              SizedBox(width: 15),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: item.inStock ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text(
                          item.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: item.inStock ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: item.inStock
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onPressed: item.inStock
                                ? () {
                                    // Add to cart functionality
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('${item.name} added to cart'),
                                        action: SnackBarAction(
                                          label: 'VIEW CART',
                                          onPressed: () {
                                            // Navigate to cart
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: Text('Add to Cart'),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.share_outlined),
                          onPressed: () {
                            // Share product functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Sharing ${item.name}...')),
                            );
                          },
                          constraints: BoxConstraints.tightFor(
                            height: 36,
                            width: 36,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wishlist item model
class WishlistItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool inStock;

  WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.inStock,
  });
}

// Main function to run the app
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: WishlistPage(),
    ),
  );
}
