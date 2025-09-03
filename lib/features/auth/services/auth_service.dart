import 'dart:convert';

import 'package:amazon/core/constants/error_handler.dart';
import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/constants/utils.dart';
import 'package:amazon/core/models/user.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:amazon/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //signUp user
  void signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      User user = User(
        id: "",
        username: username,
        email: email,
        password: password,
        address: " ",
        type: " ",
        token: "",
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/signup"),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Account is created!!. Login with same credentials",
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'x-auth-token',
            jsonDecode(response.body)['token'],
          );
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).setUser(response.body);

          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.bottomBar,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  /// This method retrieves user data from the server and updates the UserProvider.
  /// It checks if the token is valid and if so, fetches the user data.
  /// If the token is invalid, it navigates to the AuthScreen.
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenResponse = await http.post(
        Uri.parse("$uri/tokenISValid"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      var isValid = jsonDecode(tokenResponse.body);
      if (isValid == true) {
        http.Response userResponse = await http.get(
          Uri.parse("$uri/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
      }
    } catch (e) {
      print("Error fetching user data: ${e.toString()}");
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token');
      Provider.of<UserProvider>(context, listen: false).setUser(
        jsonEncode({
          'id': '',
          'username': '',
          'email': '',
          'password': '',
          'address': '',
          'type': '',
          'token': '',
        }),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.authScreen,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
