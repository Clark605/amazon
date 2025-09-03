import 'package:amazon/core/widgets/loader.dart';
import 'package:amazon/features/home/services/home_services.dart';
import 'package:amazon/features/home/widgets/address_box.dart';
import 'package:flutter/material.dart';
import 'package:amazon/core/routing/routes.dart';

import '../../../core/constants/global_variables.dart';
import '../../../core/models/product.dart';

class SearchScreen extends StatefulWidget {
  final String query;
  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HomeServices _homeServices = HomeServices();
  final TextEditingController _controller = TextEditingController();
  List<Product>? _products;
  late String _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
    _controller.text = widget.query;
    _fetch();
  }

  Future<void> _fetch() async {
    final products = await _homeServices.searchProducts(
      context: context,
      query: _currentQuery,
    );
    if (!mounted) return;
    setState(() {
      _products = products;
    });
  }

  void _onSubmitted(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    setState(() {
      _currentQuery = q;
      _products = null;
    });
    _fetch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  margin: const EdgeInsets.only(right: 8),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 0,
                    child: TextFormField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: _onSubmitted,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 22),
                        hintText: 'Search Amazon.in',
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
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
            ],
          ),
        ),
      ),
      body: _products == null
          ? const Loader()
          : _products!.isEmpty
          ? const Center(child: Text('No products found'))
          : Column(
              children: [
                AddressBox(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _products!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = _products![index];
                      final bool inStock = product.quantity > 0;
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.productDetails,
                            arguments: {"id": product.id},
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.images.first,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${product.price.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Eligible for FREE Shipping',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      inStock ? 'In stock' : 'Out of stock',
                                      style: TextStyle(
                                        color: inStock
                                            ? Colors.teal
                                            : Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
