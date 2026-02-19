import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cart/hive/cart_item_model.dart';
import '../../cart/provider/cart_provider.dart';
import '../model/product_model.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final existing = cart.box.get(product.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              product.image,
              height: 100,
              fit: BoxFit.contain,

              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return SizedBox(
                  height: 100,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange,strokeWidth: 2),
                  ),
                );
              },

              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 60);
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.title, maxLines: 2),
            ),
            Text("₹${product.price}"),

            const SizedBox(height: 8),

            existing == null
                ? ElevatedButton(
              onPressed: () {
                cart.addToCart(
                  CartItem(
                    id: product.id,
                    title: product.title,
                    price: product.price,
                    image: product.image,
                  ),
                );
              },
              child: const Text("Add",style: TextStyle(color: Colors.deepOrange),),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => cart.decrease(product.id),
                  icon: const Icon(Icons.remove),
                ),
                Text(existing.quantity.toString()),
                IconButton(
                  onPressed: () => cart.addToCart(existing),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
