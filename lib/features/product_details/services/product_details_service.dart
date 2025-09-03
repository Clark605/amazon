import 'dart:convert';

import 'package:amazon/core/constants/error_handler.dart';
import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/constants/utils.dart';
import 'package:amazon/core/models/product.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsService {
  Future<Product?> fetchById({
    required BuildContext context,
    required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.get(
        Uri.parse('$uri/api/products/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      Product? product;
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          final map =
              jsonDecode(response.body)['product'] as Map<String, dynamic>;
          product = Product.fromMap(map);
        },
      );
      return product;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<List<Product>> fetchRelated({
    required BuildContext context,
    required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<Product> products = [];
    try {
      final response = await http.get(
        Uri.parse('$uri/api/products/related/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          final list = jsonDecode(response.body)['products'] as List<dynamic>;
          for (final Map<String, dynamic> item
              in list.cast<Map<String, dynamic>>()) {
            products.add(Product.fromMap(item));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return products;
  }

  Future<void> addToCart({
    required BuildContext context,
    required String productId,
    required int quantity,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse('$uri/api/cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Added to cart');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> rateProduct({
    required BuildContext context,
    required String productId,
    required int rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse('$uri/api/products/$productId/rate'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'rating': rating}),
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Thanks for your rating!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
