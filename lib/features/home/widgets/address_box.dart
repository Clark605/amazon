import 'package:amazon/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 226, 221),
            Color.fromARGB(255, 162, 236, 233),
          ],
          stops: [0.5, 1.0],
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(Icons.location_on_outlined, color: Colors.black),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Delivery to ${user.username} - ${user.address}",
                style: TextStyle(color: Colors.black, fontSize: 16),
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 2, right: 5),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
