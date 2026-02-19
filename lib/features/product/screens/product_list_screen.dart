import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../cart/provider/cart_provider.dart';
import '../../cart/screen/cart_screen.dart';
import '../provider/product_provider.dart';
import '../widgets/product_screen.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override

  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().loadProducts();
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    int crossAxis = MediaQuery.of(context).size.width > 600 ? 4 : 2;

    return PopScope(
        canPop: kIsWeb,
        onPopInvokedWithResult: (didPop, result) {
          if (kIsWeb) return;
          if (didPop) return;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Exit App"),
              content: const Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text("Exit", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
        child:Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
              onPressed: provider.sortLowToHigh,
              icon: const Icon(Icons.arrow_upward)),
          IconButton(
              onPressed: provider.sortHighToLow,
              icon: const Icon(Icons.arrow_downward)),
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () =>
                context.read<ThemeProvider>().toggleTheme(),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: context.watch<CartProvider>().count == 0
                    ? const SizedBox()
                    : CircleAvatar(
                  radius: 8,
                  child: Text(
                    context.watch<CartProvider>().count.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange,))
          :Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: provider.search,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                childAspectRatio: 0.75,
              ),
              itemCount: provider.filtered.length,
              itemBuilder: (_, i) => ProductCard(provider.filtered[i]),
            ),
          )

        ],
      ),
    ));
  }
}
