import 'package:amazon/core/routing/routes.dart';
import 'package:amazon/core/widgets/bottom_bar.dart';
import 'package:amazon/features/admin/screen/add_products_screen.dart';
import 'package:amazon/features/admin/screen/admin_screen.dart';
import 'package:amazon/features/home/screen/category_products_screen.dart';
import 'package:amazon/features/home/screen/home_Screen.dart';
import 'package:amazon/features/home/screen/search_screen.dart';
import 'package:amazon/features/product_details/screen/product_details_screen.dart';
import 'package:amazon/features/cart/screen/cart_screen.dart';
import 'package:amazon/features/account/screen/orders_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/screen/auth_screen.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.authScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AuthScreen(),
      );
    case Routes.homeScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const HomeScreen(),
      );
    case Routes.bottomBar:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const BottomBar(),
      );
    case Routes.addProductsScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AddProductsScreen(),
      );
    case Routes.adminScreen:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const AdminScreen(),
      );
    case Routes.categoryProducts:
      final args = settings.arguments as Map<String, dynamic>?;
      final category = args?['category'] as String?;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            CategoryProductsScreen(category: category ?? 'Category'),
      );
    case Routes.searchScreen:
      final args = settings.arguments as Map<String, dynamic>?;
      final query = args?['q'] as String?;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => SearchScreen(query: query ?? ''),
      );
    case Routes.productDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      final id = args?['id'] as String?;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ProductDetailsScreen(productId: id ?? ''),
      );
    case Routes.cart:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const CartScreen(),
      );
    case Routes.orders:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const OrdersScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Page not found'))),
      );
  }
}
