import 'dart:io';

import 'package:amazon/core/constants/global_variables.dart';
import 'package:amazon/core/constants/utils.dart';
import 'package:amazon/core/widgets/custom_button.dart';
import 'package:amazon/core/widgets/custom_text_field.dart';
import 'package:amazon/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({super.key});

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final formKey = GlobalKey<FormState>();
  final AdminServices adminServices = AdminServices();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    productQuantityController.dispose();
  }

  String selectedCategory = 'Mobiles';

  List<String> categories = [
    'Mobiles',
    'Essentials',
    'Books',
    'Appliances',
    'Fashion',
  ];

  List<XFile> selectedImages = [];

  void selectImages() async {
    List<XFile> images = await pickImages();
    setState(() {
      selectedImages = images;
    });
  }

  void sellProduct() {
    if (formKey.currentState!.validate() && selectedImages.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: productDescriptionController.text,
        price: double.parse(productPriceController.text),
        quantity: double.parse(productQuantityController.text),
        category: selectedCategory,
        images: selectedImages,
      );
    } else {
      showSnackBar(context, 'Please fill all fields and select images.');
    }
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
          centerTitle: true,
          title: const Text(
            'Add Product',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                selectedImages.isNotEmpty
                    ? CarouselSlider(
                        items: selectedImages.map((image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Image.file(
                                  File(image.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                          ),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open, size: 40),
                                const SizedBox(height: 10),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: productDescriptionController,
                  hintText: 'Product Description',
                  maxLines: 8,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: productPriceController,
                  hintText: 'Product Price',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: productQuantityController,
                  hintText: 'Product Quantity',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: selectedCategory,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(text: "Sell", onTap: sellProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
