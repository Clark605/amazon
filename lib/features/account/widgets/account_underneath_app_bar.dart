import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountUnderneathAppBar extends StatelessWidget {
  const AccountUnderneathAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: 'Hello, ',
              style: const TextStyle(fontSize: 22, color: Colors.black),
              children: [
                TextSpan(
                  text: user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
