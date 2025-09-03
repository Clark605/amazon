import 'package:amazon/core/routing/routes.dart';
import 'package:amazon/features/account/widgets/account_button.dart';
import 'package:amazon/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Orders',
              onPressed: () {
                Navigator.pushNamed(context, Routes.orders);
              },
            ),
            AccountButton(text: 'Turn Seller', onPressed: () {}),
          ],
        ),
        Row(
          children: [
            AccountButton(
              text: 'Log Out',
              onPressed: () {
                _authService.logOut(context);
              },
            ),
            AccountButton(text: 'Your Wishlist', onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
