import 'dart:convert';

import 'package:amazon/core/constants/error_handler.dart';
import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/constants/utils.dart';
import 'package:amazon/core/models/product.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<Product> products = [];
    try {
      final uriWithQuery = Uri.parse(
        '$uri/api/products',
      ).replace(queryParameters: {"category": category});

      final response = await http.get(
        uriWithQuery,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          final responseData = jsonDecode(response.body);
          final productsList = responseData['products'] as List<dynamic>;
          for (final Map<String, dynamic> product
              in productsList.cast<Map<String, dynamic>>()) {
            products.add(Product.fromMap(product));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return products;
  }

  Future<List<Product>> searchProducts({
    required BuildContext context,
    required String query,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<Product> products = [];
    try {
      final uriWithQuery = Uri.parse(
        '$uri/api/products',
      ).replace(queryParameters: {"q": query});

      final response = await http.get(
        uriWithQuery,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          final responseData = jsonDecode(response.body);
          final productsList = responseData['products'] as List<dynamic>;
          for (final Map<String, dynamic> product
              in productsList.cast<Map<String, dynamic>>()) {
            products.add(Product.fromMap(product));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return products;
  }
}
