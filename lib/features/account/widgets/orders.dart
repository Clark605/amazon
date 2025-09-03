import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //temporary data for orders
  List orders = [
    'http://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'http://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'http://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'http://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'http://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Your Orders',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  'Your Orders',
                  style: TextStyle(color: GlobalVariables.selectedNavBarColor),
                ),
              ),
            ],
          ),
          Container(
            height: 170,
            padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SingleProduct(src: orders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
