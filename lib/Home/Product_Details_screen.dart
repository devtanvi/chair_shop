import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chair_shop/model/cart_method.dart';
import 'package:http/http.dart' as http;
import 'package:chair_shop/model/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final String id;

  ProductDetails({
    super.key,
    required this.id,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final String accessToken = 'lmkstrgdj@\$2spqzmxz1p5su2uyrto@shwopqo928';
  bool initialDataLoaded = false;
  int currentIndex = 0;
  final String apiUrl = 'https://dealkarde.com/dealkarde_api/p/_pd';
  int numOfItems = 1;
  final String key = 'cart';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Future<void> addToCartWithProductId(String token, String productId) async {
  //   final product = await productDetails(token, productId);
  //
  //   if (product != null) {
  //     final prefs = await _prefs;
  //     final cartProvider = CartProvider();
  //
  //     List<Map<String, dynamic>> currentItemsJson = [];
  //
  //     List<ProductData> currentItems = await cartProvider.getCartItems();
  //     currentItems.add(product);
  //
  //     for (var item in currentItems) {
  //       currentItemsJson.add({
  //         'product_id': item.productId,
  //         'name': item.name,
  //         'price': item.price,
  //         'image': item.image,
  //       });
  //     }
  //     final cartJson = jsonEncode(currentItemsJson);
  //     await prefs.setString(key, cartJson);
  //   }
  // }
  Future<ProductData?> productDetails(token, productId) async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'access_token': token,
      'pid': productId,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> data = jsonResponse['Data'];
      final productData = ProductData.fromJson(data);
      return productData;
    } else {
      print('Failed to create product. Status code: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: productDetails(accessToken, widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !initialDataLoaded) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (!initialDataLoaded) {
              if (snapshot.hasData) {
                initialDataLoaded =
                    true; // Set the initialDataLoaded flag to true
              } else if (snapshot.hasError) {
                // Handle the error here if needed
                return Center(child: Text('Error: ${snapshot.error}'));
              }
            }
            final ProductData? product = snapshot.data;

            final List<Widget> imageWidgets = product!.images.map((imageData) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xffdcdee0),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                ),
                child: FadeInImage(
                  height: MediaQuery.of(context).size.height * 0.9,
                  placeholder: AssetImage('asset/image/placeholder.jpg'),
                  image: NetworkImage(
                    'https://dealkarde.com/image/${product.image.toString()}',
                  ),
                  fit: BoxFit.cover, // Adjust the fit property as needed
                ),
              );
            }).toList();
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        final List<String> imageUrls =
                            imageWidgets.map((widget) {
                          if (widget is FadeInImage) {
                            return (widget.image as NetworkImage).url;
                          } else {
                            return '';
                          }
                        }).toList();
                      },
                      child: Stack(
                        children:[
                          CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
                                aspectRatio: 16 / 9,
                                autoPlay: false,
                                enableInfiniteScroll: true,
                                viewportFraction: 1,
                                initialPage: currentIndex,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index % product.images.length;
                                  });
                                },
                              ),
                              items: imageWidgets
                            // product.images
                            //     .map((item) => Container(
                            //           height: 400,
                            //           child: Center(
                            //             child: FadeInImage(
                            //               placeholder: AssetImage(
                            //                   'asset/image/placeholder.jpg'),
                            //               image: NetworkImage(
                            //                 'https://dealkarde.com/image/${item.image.toString()}',
                            //               ),
                            //               fit: BoxFit
                            //                   .cover, // Adjust the fit property as needed
                            //             ),
                            //           ),
                            //         ))
                            //     .toList(),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 10,right: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                for (var i = 0; i < product.images.length; i++)
                                  buildIndicator(currentIndex == i)
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Stack(children: [
                          //   InkWell(
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //     },
                          //     child: Container(
                          //       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          //       height: 40,
                          //       width: 40,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(5),
                          //           color: Colors.white),
                          //       child: Icon(
                          //         Icons.arrow_back,
                          //         size: 25,
                          //       ),
                          //     ),
                          //   ),
                          // ]),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "model:${product.model}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.red),
                                        child: Image.asset(
                                          "asset/image/favorite_fill.png",
                                          height: 10,
                                          width: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Text(product.description,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black38),
                                textAlign: TextAlign.justify),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.orange),
            child: Text(
              "Go To Pay",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 12 : 10,
        width: isSelected ? 12 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
