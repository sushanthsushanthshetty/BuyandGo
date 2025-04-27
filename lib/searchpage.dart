import 'package:flutter/material.dart';

// SearchPage widget to show search results
class SearchPage extends StatefulWidget {
  final String searchQuery;

  const SearchPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;

  // Sample product data (in a real app, this would come from a database or API)
  final List<Map<String, dynamic>> _allProducts = [
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
    {
      'name': 'Smartphone',
      'price': 15999,
      'image': 'https://example.com/smartphone.jpg',
      'rating': 4.7,
      'category': 'Electronics',
    },
    {
      'name': 'Fitness Tracker',
      'price': 3499,
      'image': 'https://example.com/tracker.jpg',
      'rating': 4.3,
      'category': 'Electronics',
    },
    {
      'name': 'T-shirt',
      'price': 999,
      'image': 'https://example.com/tshirt.jpg',
      'rating': 4.1,
      'category': 'Clothing',
    },
    {
      'name': 'Jeans',
      'price': 2499,
      'image': 'https://example.com/jeans.jpg',
      'rating': 4.4,
      'category': 'Clothing',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _performSearch(widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to perform search
  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        return;
      }

      // Filter products based on search query
      final results = _allProducts.where((product) {
        final productName = product['name'].toString().toLowerCase();
        final productCategory = product['category'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return productName.contains(searchLower) ||
            productCategory.contains(searchLower);
      }).toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    });
  }

  // Method to add products to cart
  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 18),
          onSubmitted: _performSearch,
          onChanged: (value) {
            if (value.isEmpty) {
              _performSearch('');
            }
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips (could be expanded in a real app)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Filters:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Electronics'),
                  onSelected: (selected) {
                    _performSearch('Electronics');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Clothing'),
                  onSelected: (selected) {
                    _performSearch('Clothing');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Accessories'),
                  onSelected: (selected) {
                    _performSearch('Accessories');
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              _searchResults.isEmpty
                  ? (_isLoading ? 'Searching...' : 'No results found')
                  : 'Found ${_searchResults.length} results',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Search results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try a different search term',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
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
                                            product['rating'].toString(),
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
                                            '₹${product['price']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => _addToCart(product),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
          ),
        ],
      ),
    );
  }
}
