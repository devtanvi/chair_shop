import 'dart:convert';
import 'package:chair_shop/Home/Product_Details_screen.dart';
import 'package:chair_shop/Home/cart_screen.dart';
import 'package:chair_shop/Home/profile_screen.dart';
import 'package:chair_shop/favourite_screen.dart';
import 'package:chair_shop/model/cart_method.dart';
import 'package:chair_shop/model/category_model.dart';
import 'package:chair_shop/model/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final SearchController searchController = SearchController();
  List<dynamic> dataList = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> filteredItems = [];
  final String apiUrl = 'https://dealkarde.com/dealkarde_api/p/_al';
  final String accessToken = 'lmkstrgdj@\$2spqzmxz1p5su2uyrto@shwopqo928';
  final String key = 'cart';
  List<Category> categories = [];

  //final ProductData? product = snapshot.data;

  Future<List<Category>> fetchCategory(String accessToken) async {

    final response = await http.post(
      Uri.parse('https://dealkarde.com/dealkarde_api/g/_hm/'),
      body: {'access_token': accessToken},
    );

    if (response.statusCode == 200) {
      print("called");
      // Assuming response.body is a map containing a key 'categories'
      Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);

      // Extract the 'categories' list from the map
      List<dynamic> nameCategory = responseBody['categories'] ?? [];

      // Assuming each item in nameCategory is a map, you need to map it to Category
      List<Category> cartCategories = nameCategory.map((item) => Category.fromJson(item)).toList();

      return cartCategories;
    } else {
      return [];
    }
  }




  Future<void> ProductList(String accessToken) async {
    isLoading = true;
    String accessToken = 'lmkstrgdj@\$2spqzmxz1p5su2uyrto@shwopqo928';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'access_token': accessToken,
    });

    if (response.statusCode == 200) {
      isLoading = false;
      print(response.body);
      Map<String, dynamic> responseMap = json.decode(response.body);
      // List<dynamic> dataList = responseMap['Data'];
      final data = responseMap['Data'];
      print(data);

      setState(() {
        dataList = data;
      });
      print(dataList.length);
    } else {
      setState(() {
        dataList = [];
      });
      print('Request failed with status ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    ProductList(accessToken);
    fetchCategory(accessToken).then((result) {
      setState(() {
        categories = result;
      });
    });
  }

  showAlertDialog(BuildContext context) {
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
        Navigator.pop(context);
        // FirebaseService service = new FirebaseService();
        // await service.signOutFromGoogle();
        // Navigator.pushReplacementNamed(context, Constants.signInNavigate);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Successfully Logout',
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
        "Are you sure Want to LogOut?",
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

  int _currentIndex = 0;
  var intIndex = 0;
  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            _children[_currentIndex])); // this has changed
  }

  final List<Widget> _children = [
    HomeScreen(),
    FavouriteScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  Future<void> addToCartWithProductId(String token, String productId) async {
    final product = await productDetails(token, productId);
    if (product != null) {
      setState(() {
        isLoading = true;
      });
      final prefs = await _prefs;
      final cartProvider = CartProvider();

      List<Map<String, dynamic>> currentItemsJson = [];

      List<ProductData> currentItems = await cartProvider.getCartItems();
      currentItems.add(product);

      for (var item in currentItems) {
        currentItemsJson.add({
          'product_id': item.productId,
          'name': item.name,
          'price': item.price,
          'image': item.image,
        });
      }
      final cartJson = jsonEncode(currentItemsJson);
      await prefs.setString(key, cartJson);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<ProductData?> productDetails(token, productId) async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'access_token': token,
      'pid': productId,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if 'Data' is a List
      if (jsonResponse['Data'] is List<dynamic>) {
        final List<dynamic> dataList = jsonResponse['Data'];
        // Handle the list data accordingly (for example, taking the first element)
        if (dataList.isNotEmpty) {
          final productData = ProductData.fromJson(dataList[0]);
          return productData;
        } else {
          print('Empty data list for product details');
          return null;
        }
      } else {
        print('Invalid data format for product details');
        return null;
      }
    } else {
      print('Failed to create product. Status code: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f4f7),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFff9900),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Name'),
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        "asset/image/user.png",
                        fit: BoxFit.fill,
                      ),
                    ), // Image radius
                    // backgroundImage: AssetImage('asset/image/placeholder.jpg'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("HOME"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("CART"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
            ListTile(
              title: Text("LOGOUT"),
              onTap: () {
                showAlertDialog(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xfff2f4f7),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Icon(Icons.dehaze_rounded),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
        actions: [
          CircleAvatar(
            radius: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                "asset/image/user.png",
                fit: BoxFit.fill,
              ),
            ), // Image radius
            // backgroundImage: AssetImage('asset/image/placeholder.jpg'),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.17,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0, right: 15, left: 15),
              child: SearchAnchor(
                viewBackgroundColor: Color(0xfff2f4f7),
                searchController: searchController,
                headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                viewHintText: 'Search Here',
                dividerColor: Colors.black,
                // isFullScreen: false,
                viewElevation: 100,
                viewConstraints: const BoxConstraints(
                  maxHeight: 900,
                ),
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xfff2f4f7)),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none),
                    hintText: "Search . . .",
                    controller: searchController,
                    leading: Icon(
                      Icons.search,
                      color: Colors.orange,
                      size: 30,
                    ),
                    onTap: () {
                      searchController.openView();
                    },
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  final keyword = controller.value.text;
                  final matchingItems = dataList
                      .where((element) => element['name']
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase()))
                      .toList();

                  return matchingItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            focusColor: Colors.grey,
                            title: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text(
                                        item['name'],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'PRICE:${item["original_price"]}\nM.R.P${item["price"]}RS',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Spacer(),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    'https://dealkarde.com/image/${item['image']}',
                                    height: 120,
                                    width: 120,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                controller.closeView(item['name']);
                                FocusScope.of(context).unfocus();
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(id: item["product_id"]),
                                ),
                              );
                              controller.clear();
                            },
                          ),
                          InkWell(
                            onTap: () async {
                              isLoading == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    )
                                  : await addToCartWithProductId(
                                      accessToken, item["product_id"]);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.orange,
                                  content: Text(
                                    'Item Added to Cart',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange),
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                   // final item = categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                      child: InkWell(
                        onTap: () => _onSelected(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                            // _selectedIndex != null && _selectedIndex == index
                            //     ? Colors.orange
                               // :
                            Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chair,
                                  color: Colors.black45,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("name",
                                 // item.name, // Display the category name here
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended Chairs",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    size: 25,
                    color: Colors.red,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = dataList[index];
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        id: item["product_id"])));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Image.network(
                                  'https://dealkarde.com/image/${item['image']}',
                                  height: 120,
                                  width: 120,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          item['name'] ?? '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$${item["original_price"]}',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            isLoading == true
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                : await addToCartWithProductId(
                                                    accessToken,
                                                    item["product_id"]);
                                            print(item["product_id"]);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.orange,
                                                content: Text(
                                                  'Item Added to Cart',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: 12.0, top: 5),
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recently Reviewed",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    size: 25,
                    color: Colors.red,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = dataList[index];
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        id: item["product_id"])));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Image.network(
                                  'https://dealkarde.com/image/${item['image']}',
                                  height: 120,
                                  width: 120,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          item['name'] ?? '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$${item["original_price"]}',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            print(item["product_id"]);
                                            await addToCartWithProductId(
                                                accessToken,
                                                item["product_id"]);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.orange,
                                                content: Text(
                                                  'Item Added to Cart',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: 12.0, top: 5),
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onTap();
        },
        items: <SalomonBottomBarItem>[
          SalomonBottomBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text("Home"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text("Likes"),
              selectedColor: Colors.orange),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Cart"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.orange),
        ],
      ),
    );
  }
}
