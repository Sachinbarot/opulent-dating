// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_final_fields, avoid_function_literals_in_foreach_calls, prefer_is_empty, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/util/color.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import '../Profile/profile.dart';

import '../Tab.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen();

  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool? isAvailable = true;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];

  StreamSubscription? _streamSubscription;
  ProductDetails? selectedPlan;
  ProductDetails? selectedProduct;
  var response;
  bool _isLoading = true;
  InAppPurchase? _iap = InAppPurchase.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    products = [];
    purchases = [];
    _initialize();
  }

  @override
  void dispose() {
    _streamSubscription!.cancel();
    super.dispose();
  }

  Future<List<String>> _fetchPackageIds() async {
    List<String> packageId = [];

    await FirebaseFirestore.instance
        .collection("Packages")
        .where('status', isEqualTo: true)
        .get()
        .then((value) {
      packageId.addAll(value.docs.map((e) => e['id']));
    });

    return packageId;
  }

  Future<void> _initialize() async {
    isAvailable = await _iap!.isAvailable();
    if (isAvailable!) {
      List<Future>? futures = [
        _getProducts(await _fetchPackageIds()),
        //_getpastPurchases(false),
      ];
      await Future.wait(futures);

      /// removing all the pending puchases.
      if (Platform.isIOS) {
        var paymentWrapper = SKPaymentQueueWrapper();
        var transactions = await paymentWrapper.transactions();
        transactions.forEach((transaction) async {
          print(transaction.transactionState);
          await paymentWrapper
              .finishTransaction(transaction)
              .catchError((onError) {
            print('finishTransaction Error $onError');
          });
        });
      }

      _streamSubscription = _iap!.purchaseStream.listen((data) {
        setState(
          () {
            purchases!.addAll(data);

            purchases!.forEach(
              (purchase) async {
                await _verifyPuchase(purchase.productID);
              },
            );
          },
        );
      });
      _streamSubscription!.onError(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: error != null
                  ? Text('$error')
                  : Text("Oops !! something went wrong. Try Again"),
            ),
          );
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: btncolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50, left: 20),
              alignment: Alignment.topLeft,
              child: IconButton(
                alignment: Alignment.topLeft,
                color: Colors.black,
                icon: const Icon(
                  Icons.cancel,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ListTile(
                    dense: true,
                    title: Text(
                      "Get Premium",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: black,
                          fontFamily: AppStrings.fontname,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 100,
                        width: MediaQuery.of(context).size.width * .85,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Swiper(
                            key: UniqueKey(),
                            curve: Curves.linear,
                            autoplay: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index2) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          adds[index2]["icon"],
                                          color: adds[index2]["color"],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          adds[index2]["title"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: AppStrings.fontname,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      adds[index2]["subtitle"],
                                      style: const TextStyle(
                                        fontFamily: AppStrings.fontname,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]);
                            },
                            itemCount: adds.length,
                            pagination: SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                    activeSize: 10,
                                    color: secondryColor,
                                    activeColor: white)),
                            control: SwiperControl(
                              size: 20,
                              color: pink,
                              disableColor: white,
                            ),
                            loop: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _isLoading
                      ? SizedBox(
                          height: MediaQuery.of(context).size.width * .8,
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor)),
                          ),
                        )
                      : products.length > 0
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Transform.rotate(
                                    angle: -pi / 2,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              .16,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .8,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: btncolor),
                                      ),
                                      child: Center(
                                        child: CupertinoPicker(
                                          squeeze: 1.4,
                                          looping: true,
                                          magnification: 1.1,
                                          offAxisFraction: -.2,
                                          backgroundColor: btncolor,
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: 0),
                                          itemExtent: 100,
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              selectedProduct = products[value];
                                            });
                                          },
                                          children: products.map((product) {
                                            return Transform.rotate(
                                              angle: pi / 2,
                                              child: productList(
                                                context: context,
                                                product: product,
                                                interval: Platform.isIOS
                                                    ? getInterval(product)
                                                    : getIntervalAndroid(
                                                        product),
                                                intervalCount: Platform.isIOS
                                                    ? (product
                                                            as AppStoreProductDetails)
                                                        .skProduct
                                                        .subscriptionPeriod!
                                                        .numberOfUnits
                                                        .toString()
                                                    : product.price
                                                            .toString()
                                                            .split(" ")[
                                                        1], // Adjust this as per your subscriptionOfferDetails format
                                                price: product.price,
                                                onTap: () {
                                                  // Handle onTap event if needed
                                                },
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.width * .8,
                              child: const Center(
                                child: Text(
                                  "No Active Product Found!!",
                                  style: TextStyle(
                                      fontFamily: AppStrings.fontname),
                                ),
                              ),
                            ),
                ],
              ),
            ),
            Platform.isIOS
                ? InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor
                                ])),
                        height: MediaQuery.of(context).size.height * .055,
                        width: MediaQuery.of(context).size.width * .55,
                        child: Center(
                            child: Text(
                          "RESTORE PURCHASE",
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {},
                  )
                : Container(),
            const SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 49,
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    color: white),
                child: Center(
                  child: Text(
                    'Get 1 Month For selectedProduct!.price INR',
                    style: TextStyle(
                        fontFamily: AppStrings.fontname,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productList({
    required BuildContext context,
    required String intervalCount,
    required String interval,
    required Function onTap,
    required ProductDetails product,
    required String price,
  }) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      height: 100, //setting up dimention if product get selected
      width: selectedProduct !=
              product //setting up dimention if product get selected
          ? MediaQuery.of(context).size.width * .19
          : MediaQuery.of(context).size.width * .22,
      decoration: selectedProduct == product
          ? BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: cardback,
              border: Border.all(width: 2, color: cardback))
          : null,
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Text(intervalCount,
              style: TextStyle(
                  color: selectedProduct != product ? Colors.black : black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          Text(interval,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up color if product get selected
                      ? Colors.black
                      : black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          Text(price,
              style: TextStyle(
                  color: selectedProduct != product ? Colors.black : black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
        //      )),
      ),
    );
  }

  ///fetch products
  Future<void> _getProducts(List<String> _productIds) async {
    print('----------${_productIds.length}');
    if (_productIds.length > 0) {
      Set<String> ids = Set.from(_productIds);
      print('====**$ids');
      ProductDetailsResponse response = await _iap!.queryProductDetails(ids);
      setState(() {
        products = response.productDetails;
        print(products!.length);
        print(response.productDetails);
      });

      //initial selected of products
      if (products!.isNotEmpty) {
        // Check if products list is not empty
        selectedProduct = products![0];
      }
    }
  }

  PurchaseDetails _hasPurchased(String productId) {
    return purchases!.firstWhere(
      (purchase) => purchase.productID == productId,
      //orElse: () => null
    );
  }

  ///verifying opurhcase of user
  Future<void> _verifyPuchase(
    String id,
  ) async {
    PurchaseDetails purchase = _hasPurchased(id);
    if (purchase != null && purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      print('===***${purchase.productID}');

      // if (Platform.isIOS) {
      await _iap!.completePurchase(purchase);
      //}
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) {
          return Tabbar(
            purchase.productID,
            true,
          );
        }),
      );
    } else if (purchase != null && purchase.status == PurchaseStatus.error) {}
    return;
  }

  ///buying a product
  void _buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap!.buyNonConsumable(purchaseParam: purchaseParam);
  }

  String getInterval(ProductDetails product) {
    product as AppStoreProductDetails;
    SKSubscriptionPeriodUnit periodUnit =
        product.skProduct.subscriptionPeriod!.unit;
    if (SKSubscriptionPeriodUnit.month == periodUnit) {
      return "Month(s)";
    } else if (SKSubscriptionPeriodUnit.week == periodUnit) {
      return "Week(s)";
    } else {
      return "Year";
    }
  }

  String getIntervalAndroid(ProductDetails product) {
    product as GooglePlayProductDetails;
    String durCode = product.productDetails.description.split("")[2];
    // add by bhanu
    product.productDetails.subscriptionOfferDetails.toString().split("")[2];
    if (durCode == "M" || durCode == "m") {
      return "Month(s)";
    } else if (durCode == "Y" || durCode == "y") {
      return "Year";
    } else {
      return "Week(s)";
    }
  }
}
