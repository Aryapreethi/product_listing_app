import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    double size = MediaQuery.of(context).size.width * 0.22;
    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold)),

      ),
      body: cart.items.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("Your cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: Theme.of(context).brightness == Brightness.light
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.image,
                            width: size,
                            height: size,
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator(color: Colors.deepOrange,));
                            },
                          )
                          ,
                        ),
                        const SizedBox(width: 12),


                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "₹${item.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            IconButton(
                              onPressed: () => cart.removeItem(item.id),
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  _QtyButton(
                                    icon: Icons.remove,
                                    onTap: () => cart.decrease(item.id),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      item.quantity.toString(),
                                      style:  TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor

                                    ),
                                    ),
                                  ),
                                  _QtyButton(
                                    icon: Icons.add,
                                    onTap: () => cart.addToCart(item),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      "₹${cart.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}