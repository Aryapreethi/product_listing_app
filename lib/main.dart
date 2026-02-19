import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_listing_app/service/api_service.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/cart/hive/cart_item_model.dart';
import 'features/cart/provider/cart_provider.dart';
import 'features/product/provider/product_provider.dart';
import 'features/product/repository/product_repo.dart';
import 'features/product/screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  final cartBox = await Hive.openBox<CartItem>('cartBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(cartBox),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            ProductRepository(ApiService()),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: const ProductListScreen(),
    );
  }
}



