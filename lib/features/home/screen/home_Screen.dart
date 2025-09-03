import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/routing/routes.dart';
import 'package:amazon/features/home/widgets/address_box.dart';
import 'package:amazon/features/home/widgets/carousel_image.dart';
import 'package:amazon/features/home/widgets/deal_of_the_day.dart';
import 'package:amazon/features/home/widgets/top_categories.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 0,
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        final query = value.trim();
                        if (query.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            Routes.searchScreen,
                            arguments: {"q": query},
                          );
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 22),
                        hintText: "Search Amazon.in",
                        hintStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(21),
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.mic,
                      size: 22,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const SizedBox(height: 10),
            TopCategories(),
            const SizedBox(height: 10),
            const CarouselImage(),
            const SizedBox(height: 10),
            const DealOfTheDay(),
          ],
        ),
      ),
    );
  }
}
