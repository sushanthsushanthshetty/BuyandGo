import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Sample product data for each category
  late List<Map<String, dynamic>> _categoryProducts;

  @override
  void initState() {
    super.initState();
    // Initialize with sample products based on category
    _loadCategoryProducts();
  }

  void _loadCategoryProducts() {
    // This is sample data - in a real app, you would fetch this from an API or database
    switch (widget.categoryName) {
      case "Electronics":
        _categoryProducts = [
          {
            'name': 'Wireless Headphones',
            'price': 5999,
            'rating': 4.5,
          },
          {
            'name': 'Smart Watch',
            'price': 11249,
            'rating': 4.2,
          },
          {
            'name': 'Bluetooth Speaker',
            'price': 4499,
            'rating': 4.8,
          },
          {
            'name': 'Smartphone',
            'price': 18999,
            'rating': 4.6,
          },
          {
            'name': 'Tablet',
            'price': 25999,
            'rating': 4.3,
          },
          {
            'name': 'Power Bank',
            'price': 1499,
            'rating': 4.7,
          },
        ];
        break;
      case "Clothing":
        _categoryProducts = [
          {
            'name': 'Men\'s T-Shirt',
            'price': 899,
            'rating': 4.1,
          },
          {
            'name': 'Women\'s Dress',
            'price': 2499,
            'rating': 4.4,
          },
          {
            'name': 'Jeans',
            'price': 1999,
            'rating': 4.3,
          },
          {
            'name': 'Casual Shirt',
            'price': 1299,
            'rating': 4.0,
          },
        ];
        break;
      case "All Products":
        _categoryProducts = [
          {
            'name': 'Wireless Headphones',
            'price': 5999,
            'rating': 4.5,
          },
          {
            'name': 'Smart Watch',
            'price': 11249,
            'rating': 4.2,
          },
          {
            'name': 'Men\'s T-Shirt',
            'price': 899,
            'rating': 4.1,
          },
          {
            'name': 'Home Decor Item',
            'price': 1499,
            'rating': 4.0,
          },
          {
            'name': 'Face Cream',
            'price': 599,
            'rating': 4.6,
          },
          {
            'name': 'Sports Shoes',
            'price': 2999,
            'rating': 4.5,
          },
          {
            'name': 'Novel',
            'price': 349,
            'rating': 4.8,
          },
        ];
        break;
      // Add cases for other categories
      default:
        // Default products if category doesn't match
        _categoryProducts = [
          {
            'name': 'Product 1',
            'price': 1999,
            'rating': 4.5,
          },
          {
            'name': 'Product 2',
            'price': 2499,
            'rating': 4.2,
          },
          {
            'name': 'Product 3',
            'price': 999,
            'rating': 4.0,
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_categoryProducts.length} Products',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categoryProducts.length,
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
                                _categoryProducts[index]['name'],
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
                                    _categoryProducts[index]['rating']
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
                                    '₹${_categoryProducts[index]['price']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Container(
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
      ),
    );
  }
}
