import 'package:flutter/material.dart';
import 'package:pppp/wishlist_page.dart';

import 'CategoryPage.dart';

import 'cart_page.dart';

import 'ProfilePage.dart';

import 'searchpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  // Cart items list to track items added to cart
  List<Map<String, dynamic>> _cartItems = [];

  // Sample data for featured products
  final List<Map<String, dynamic>> _featuredProducts = [
    {
      'name': 'Wireless Headphones',
      'price': 5999,
      'image': 'https://example.com/headphones.jpg',
      'rating': 4.5,
      'category': 'Electronics',
    },
    {
      'name': 'Laptop',
      'price': 11249,
      'image': 'https://example.com/smartwatch.jpg',
      'rating': 4.2,
      'category': 'Electronics',
    },
    {
      'name': 'Bluetooth Speaker',
      'price': 4499,
      'image': 'assets/mac.png',
      'rating': 4.8,
      'category': 'Electronics',
    },
    {
      'name': 'Laptop Backpack',
      'price': 2999,
      'image': 'https://example.com/backpack.jpg',
      'rating': 4.0,
      'category': 'Accessories',
    },
  ];

  // Sample data for categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Clothing', 'icon': Icons.checkroom},
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Beauty', 'icon': Icons.face},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
    {'name': 'Books', 'icon': Icons.book},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected index
    if (index == 1) {
      // Navigate to categories when categories tab is selected
      _navigateToCategory('All Categories');
    } else if (index == 2) {
      // Navigate to wishlist when wishlist tab is selected
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishlistPage(),
        ),
      );
      // Reset to home tab after navigating to wishlist
      setState(() {
        _selectedIndex = 0;
      });
    } else if (index == 3) {
      // Navigate to profile when profile tab is selected
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
      // Reset to home tab after navigating to profile
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  // Method to navigate to CategoryPage
  void _navigateToCategory(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(categoryName: categoryName),
      ),
    );
  }

  // Method to search products
  void _searchProducts(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(searchQuery: query),
        ),
      );
      // Clear search after navigating
      _searchController.clear();
      // Hide search bar after search
      setState(() {
        _showSearchBar = false;
      });
    }
  }

  // Method to add products to cart
  void _addToCart(Map<String, dynamic> product) {
    // Check if product already exists in cart
    final existingIndex =
        _cartItems.indexWhere((item) => item['name'] == product['name']);

    setState(() {
      if (existingIndex >= 0) {
        // If product exists, increment its quantity
        _cartItems[existingIndex]['quantity'] =
            (_cartItems[existingIndex]['quantity'] ?? 1) + 1;
      } else {
        // If product doesn't exist, add it with quantity 1
        final newItem = Map<String, dynamic>.from(product);
        newItem['quantity'] = 1;
        _cartItems.add(newItem);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'GO TO CART',
          onPressed: () {
            _navigateToCart();
          },
        ),
      ),
    );
  }

  // Method to navigate to cart
  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
            // Removed cartItems parameter since it's not defined in CartPage
            // Add these parameters once you've updated the CartPage class
            // cartItems: _cartItems,
            // onCheckout: _proceedToCheckout,
            // onUpdateCart: _updateCart,
            ),
      ),
    );
  }

  // Method to update cart items (for use when returning from CartPage)
  void _updateCart(List<Map<String, dynamic>> updatedItems) {
    setState(() {
      _cartItems = updatedItems;
    });
  }

  // Method to proceed to checkout
  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Calculate subtotal for checkout
    double subtotal = 0;
    for (var item in _cartItems) {
      subtotal += (item['price'] * (item['quantity'] ?? 1));
    }

    // Instead of using CheckoutPage directly, navigate to a temporary page or function
    // until you create the actual CheckoutPage
    _showCheckoutPlaceholder(subtotal);
  }

  // Temporary method to show a checkout placeholder until CheckoutPage is created
  void _showCheckoutPlaceholder(double subtotal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subtotal: ₹${subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                const Text('Checkout page is under construction.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleOrderPlaced();
              },
              child: const Text('Place Order'),
            ),
          ],
        );
      },
    );
  }

  // Method to handle order placed event
  void _handleOrderPlaced() {
    // Clear the cart after successful order
    setState(() {
      _cartItems = [];
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showSearchBar = false;
                        _searchController.clear();
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: _searchProducts,
              )
            : const Text(
                'Buy_N_Go',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        backgroundColor: Colors.lightBlueAccent,
        actions: _showSearchBar
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _showSearchBar = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    // TODO: Implement notifications functionality
                  },
                ),
                IconButton(
                  icon: Badge(
                    label: Text(_cartItems.isEmpty
                        ? '0'
                        : _cartItems.length.toString()),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  onPressed: () {
                    _navigateToCart();
                  },
                ),
              ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Summer Sale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Get up to 50% off on selected items',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to all products with sale items
                          _navigateToCategory('Sale Items');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text('Shop Now'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Search box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSearchBar = true;
                          });
                        },
                        child: Text(
                          'Search products...',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Categories
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to category page when tapped
                        _navigateToCategory(_categories[index]['name']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: Icon(
                                _categories[index]['icon'],
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _categories[index]['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Featured Products
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all products page
                      _navigateToCategory('All Products');
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _featuredProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _featuredProducts[index]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _featuredProducts[index]['rating']
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${_featuredProducts[index]['price']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        _addToCart(_featuredProducts[index]),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Special Offers
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange.shade100,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer,
                      color: Colors.orange,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Special Offer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Use code WELCOME15 for 15% off on your first order',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Proceed to Checkout button (visible when cart has items)
              if (_cartItems.isNotEmpty) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Proceed to Checkout (${_cartItems.length} ${_cartItems.length == 1 ? 'item' : 'items'})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      // Add floating action button for direct checkout access
      floatingActionButton: _cartItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: _proceedToCheckout,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.shopping_cart_checkout),
              tooltip: 'Checkout',
            )
          : null,
    );
  }
}
