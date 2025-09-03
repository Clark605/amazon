import 'dart:convert';

import 'package:amazon/core/constants/error_handler.dart';
import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/constants/utils.dart';
import 'package:amazon/core/models/product.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartItemDto {
  final Product product;
  final int quantity;
  CartItemDto({required this.product, required this.quantity});
}

class CartService {
  Future<List<CartItemDto>> getCart(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<CartItemDto> items = [];
    try {
      final response = await http.get(
        Uri.parse('$uri/api/cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          final list = jsonDecode(response.body)['cart'] as List<dynamic>;
          for (final Map<String, dynamic> item
              in list.cast<Map<String, dynamic>>()) {
            final product = Product.fromMap(
              item['product'] as Map<String, dynamic>,
            );
            items.add(
              CartItemDto(
                product: product,
                quantity: (item['quantity'] as num).toInt(),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return items;
  }

  Future<void> checkout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse('$uri/api/orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order placed!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
