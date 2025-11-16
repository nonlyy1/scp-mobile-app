import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
  Provider.of<ProductProvider>(context, listen: false).loadMockProducts();
  Provider.of<UserProvider>(context, listen: false).loginMockUser();
  // Use mock supplier links in demo mode to avoid backend calls when backend is not running.
  Provider.of<SupplierLinkProvider>(context, listen: false).loadMockLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final supplierLinkProvider = Provider.of<SupplierLinkProvider>(context);

    // Фильтруем товары только от подключенных поставщиков
    final connectedSupplierIds = supplierLinkProvider.connectedSuppliers
        .map((link) => link.supplierId)
        .toList();
    
    final filteredProducts = productProvider.featuredProducts
        .where((product) => connectedSupplierIds.contains(product.supplierId))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CaterChain Marketplace'),
        titleTextStyle: TextStyle( fontSize: 20, fontWeight: FontWeight.bold,),
        actions: [
          if (userProvider.isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userProvider.currentUser?.name.substring(0, 1) ?? 'U',
                  style: const TextStyle(
                    color: Color(0xFF6B8E23),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B8E23)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search suppliers, products, or categ...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24.0),
                  
                  const Text(
                    'Featured Suppliers',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSupplierBox('ROYAL FLOWERS Co.', 'Flowers', Icons.local_florist_outlined),
                        const SizedBox(width: 12),
                        _buildSupplierBox('Fresh Dairy', 'Dairy Products', Icons.agriculture_outlined),
                        const SizedBox(width: 12),
                        _buildSupplierBox('Global Meats', 'Meat Products', Icons.set_meal_outlined),
                        const SizedBox(width: 12),
                        _buildSupplierBox('Ocean Catch', 'Seafood', Icons.waves_outlined),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24.0),
                  
                  const Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  if (connectedSupplierIds.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.link_off, size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            const Text(
                              'No connected suppliers yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Go to Profile → Supplier Links to connect',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (filteredProducts.isNotEmpty)
                    Column(
                      children: filteredProducts.map((product) {
                        return _buildProductCard(product, context);
                      }).toList(),
                    )
                  else
                    const Text('No products available from connected suppliers'),
                  
                  const SizedBox(height: 24.0),
                  
                  const Text(
                    'Popular Categories',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildCategoryBox('Wholesale Goods', Icons.inventory_2_outlined),
                      _buildCategoryBox('Raw Materials', Icons.construction_outlined),
                      _buildCategoryBox('Beverages', Icons.emoji_food_beverage_outlined),
                      _buildCategoryBox('Fresh Produce', Icons.grass_outlined),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSupplierBox(String name, String category, IconData icon) {
    return Container(
      width: 150,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF6B8E23).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B8E23),
              size: 40,
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF6B8E23).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF6B8E23).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Icon(Icons.shopping_bag, color: Color(0xFF6B8E23)),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${product.price.toStringAsFixed(0)} ₸',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B8E23),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'per ${product.unit}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (product.stockQuantity > 0)
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'In stock: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF787A77), // normal text color
                      ),
                    ),
                    TextSpan(
                      text: '${product.stockQuantity}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B8E23),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6B8E23),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            padding: EdgeInsets.zero,
            onPressed: () {
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
              
              cartProvider.addToCart(product);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added ${product.name} to cart',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFF6B8E23),
                  action: SnackBarAction(
                    label: 'VIEW CART',
                    textColor: Colors.white,
                    onPressed: () {
                      navigationProvider.navigateToCart();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBox(String category, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6B8E23),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6B8E23),
                  const Color(0xFF6B8E23).withOpacity(0.8),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}