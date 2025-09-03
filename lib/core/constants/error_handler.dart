import 'package:amazon/core/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandler({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  String errorMessage = 'An unexpected error occurred';

  switch (response.statusCode) {
    case 200:
      onSuccess();
      return;
    case 400:
      errorMessage = 'Bad Request: ${response.body}';
      break;
    case 500:
      errorMessage = 'Internal Server Error: ${response.body}';
      break;
    default:
      errorMessage = 'Error: ${response.statusCode} - ${response.body}';
  }
  showSnackBar(context, errorMessage);
  debugPrint(errorMessage);
}
