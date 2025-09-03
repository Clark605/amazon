import 'package:amazon/app.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => UserProvider(), child: App()),
  );
}
