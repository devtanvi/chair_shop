import 'package:chair_shop/model/cart_method.dart';
import 'package:chair_shop/model/product_detail_model.dart';
import 'package:flutter/material.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductData> cartItems = [];
  int currentIndex = 0;


  double calculateTotalPrice(List<ProductData> cartItems) {
    double totalPrice = 0.0;
    for (final item in cartItems) {
      double itemPrice = double.tryParse(item.price) ?? 0.0;
      int itemQuantity = item.quantity;

      totalPrice += itemPrice * itemQuantity;
    }
    return totalPrice;
  }


  double calculateTotalPriceWithShipping(
      List<ProductData> cartItems, double shippingCharge) {
    double totalPrice =
        calculateTotalPrice(cartItems); // Reuse the existing method

    // Add shipping charges to the total
    totalPrice += shippingCharge;

    return totalPrice;
  }

  showAlertDialog(BuildContext context, index) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.orange, fontSize: 16),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.orange, fontSize: 16),
      ),
      onPressed: () async {
        removeFromCart(index);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'PRODUCT DELETED FROM CART ',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3,
      title: Text(
        "CHAIR SHOP",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: Text(
        "Are you sure Want to Remove Item?",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final items = await CartProvider().getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      updateCart();
      setState(() {});
    }
  }

  void updateCart() {
    CartProvider().updateCartItems(cartItems);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice(cartItems);
    double shippingCharge = 50; // Replace with your actual shipping charge
    double shippingPrice =
        calculateTotalPriceWithShipping(cartItems, shippingCharge);
    return Scaffold(
      backgroundColor: Color(0xfff2f4f7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.10,
        ),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xfff2f4f7),
          title: const Text(
            "Cart",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Icon(
                Icons.arrow_back,
                size: 25,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Icon(
                Icons.delete_sharp,
                size: 25,
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
      body: cartItems.isNotEmpty
          ? Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12),
                        child: Card(
                          color: Colors.white,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  'https://dealkarde.com/image/${item.image}',
                                  height: 120,
                                  width: 120,
                                ),

                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text(
                                        item.name,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      "\$${item.price.toString()} ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      item.model,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 2.0),
                                            child: Row(
                                              children: [
                                                if (item.quantity > 1) ...[
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: InkWell(
                                                      child: Icon(Icons.remove,
                                                          color: Colors.orange),
                                                      onTap: () {
                                                        if (item.quantity > 1) {
                                                          setState(() {
                                                            item.quantity--;
                                                            updateCart();
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                                SizedBox(width: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${item.quantity}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: InkWell(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.orange,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        cartItems[index]
                                                            .updateQuantity(
                                                                cartItems[index]
                                                                        .quantity +
                                                                    1);
                                                        updateCart(); // Save the updated cart items in shared preferences
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      showAlertDialog(context, index);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white),
                                      child: const Icon(
                                        Icons.delete_sharp,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 220,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount of Products",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text("\$${totalPrice.toStringAsFixed(2)}")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery free",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text("$shippingCharge"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "\$${shippingPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 100,
                              ),
                              Text(
                                "Pay Now",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 25,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Text(
                    "your cartList is empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
    );
  }

}

