import 'dart:convert';

import 'package:amazon/core/constants/error_handler.dart';
import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/constants/utils.dart';
import 'package:amazon/core/models/product.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:amazon/core/routing/routes.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<XFile> images,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic("du18nqtmd", "amazon");
      List<String> imageUrls = [];

      for (XFile image in images) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            image.path,
            resourceType: CloudinaryResourceType.Image,
            folder: name,
          ),
        );
        imageUrls.add(response.secureUrl);
      }
      Product product = Product(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imageUrls,
      );
      // Here you would typically send the product to your backend
      http.Response response = await http.post(
        Uri.parse('$uri/admin/add-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
        body: product.toJson(),
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product added successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          final responseData = jsonDecode(response.body);
          final productsList = responseData['products'];
          for (var product in productsList) {
            products.add(Product.fromMap(product));
          }
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
    return products;
  }

  Future<void> deleteProduct(BuildContext context, String id) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/admin/delete-product/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product deleted successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
