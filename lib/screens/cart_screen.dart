import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: const Color(0xFF6B8E23),
        foregroundColor: Colors.white,
        actions: [
          if (cartProvider.itemCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Badge(
                backgroundColor: Colors.red,
                label: Text(
                  cartProvider.itemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
        ],
      ),
      body: cartProvider.itemCount == 0
          ? const _EmptyCartState()
          : _CartWithItems(cartProvider: cartProvider),
      bottomNavigationBar: cartProvider.itemCount > 0
          ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${cartProvider.totalAmount.toStringAsFixed(0)} ₸',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B8E23),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully!'),
                          backgroundColor: Color(0xFF6B8E23),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B8E23),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add some products to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
              navigationProvider.navigateToHome();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B8E23),
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}

class _CartWithItems extends StatelessWidget {
  final CartProvider cartProvider;

  const _CartWithItems({required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return _CartItemCard(item: item, cartProvider: cartProvider);
            },
          ),
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartProvider cartProvider;

  const _CartItemCard({
    required this.item,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
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
          item.product.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.product.price.toStringAsFixed(0)} ₸ per ${item.product.unit}',
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: ${item.totalPrice.toStringAsFixed(0)} ₸',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B8E23),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.remove, size: 16, color: Colors.black54),
              ),
              onPressed: () {
                if (item.quantity > 1) {
                  cartProvider.updateQuantity(item.product.id, item.quantity - 1);
                } else {
                  cartProvider.removeFromCart(item.product.id);
                }
              },
            ),
            Text(
              item.quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B8E23),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
              onPressed: () {
                cartProvider.updateQuantity(item.product.id, item.quantity + 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}