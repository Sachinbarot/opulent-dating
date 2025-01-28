// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_final_fields, avoid_function_literals_in_foreach_calls, prefer_is_empty, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Payment/boostScreen.dart';
import 'package:hookup4u/Screens/Payment/premium.dart';
import 'package:hookup4u/Screens/Payment/premium_plus.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import '../Profile/profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Tab.dart';

class Subscription extends StatefulWidget {
  final bool? isPaymentSuccess;
  final User? currentUser;
  final Map items;
  const Subscription(this.currentUser, this.isPaymentSuccess, this.items,
      {super.key});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  bool isAvailable = true;

  /// products for sale
  List<ProductDetails> products = [];

  /// Past purchases
  List<PurchaseDetails> purchases = [];

  /// Update to purchases
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
    _initialize();
    // Show payment failure alert.
    if (widget.isPaymentSuccess != null && !widget.isPaymentSuccess!) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.error,
          title: "Failed".tr().toString(),
          desc: "Oops !! something went wrong. Try Again".tr().toString(),
          buttons: [
            DialogButton(
              // ignore: sort_child_properties_last
              child: const Text(
                "Retry",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
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
      print(value);
      packageId.addAll(value.docs.map((e) => e['id']));
    });
    print("Package Id's: ==>>$packageId");

    return packageId;
  }

  void _initialize() async {
    isAvailable = await _iap!.isAvailable();
    if (isAvailable) {
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
            purchases.addAll(data);

            purchases.forEach(
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
                  : Text("Oops !! something went wrong. Try Again"
                      .tr()
                      .toString()),
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
      backgroundColor: backcolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 30, left: 20),
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
            // TextButton(
            //   child: Text("Fetch"),
            //   onPressed: () {
            //     _fetchPackageIds();
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ListTile(
                    dense: true,
                    title: Text(
                      "Get Out Premium Plans",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: black,
                          fontFamily: AppStrings.fontname,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  // ListTile(
                  //   dense: true,
                  //   leading: const Icon(
                  //     Icons.star,
                  //     color: Colors.blue,
                  //   ),
                  //   title: Text(
                  //     "Unlimited swipe.",
                  //     style: const TextStyle(
                  //         fontFamily: AppStrings.fontname,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w400),
                  //   ),
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   leading: const Icon(
                  //     Icons.star,
                  //     color: Colors.green,
                  //   ),
                  //   title: const Text(
                  //     "Search users around",
                  //     style: TextStyle(

                  //         // Color(0xFF1A1A1A),
                  //         fontSize: 16,
                  //         fontFamily: AppStrings.fontname,
                  //         fontWeight: FontWeight.w400),
                  //   ).tr(args: ["${widget.items['paid_radius'] ?? ''}"]),
                  // ),

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
                                    activeColor: btncolor)),
                            control: SwiperControl(
                              size: 20,
                              color: btncolor,
                              disableColor: secondryColor,
                            ),
                            loop: false,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  // InkWell(
                  //   splashColor: Colors.transparent,
                  //   highlightColor: Colors.transparent,
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //             builder: (context) => PremiumScreen()));
                  //   },
                  //   child: plancards(
                  //       context,
                  //       'Premium',
                  //       'Unlock all of our features to be in complete control of your experience',
                  //       'Upgrade From 100.00 INR',
                  //       bluecolor),
                  // ),
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  // InkWell(
                  //   splashColor: Colors.transparent,
                  //   highlightColor: Colors.transparent,
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //             builder: (context) => const BoostScreen()));
                  //   },
                  //   child: plancards(
                  //       context,
                  //       'Boost ',
                  //       'Unlock all of our features to be in complete control of your experience',
                  //       'Upgrade From 100.00 INR',
                  //       pink),
                  // ),
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  // InkWell(
                  //   splashColor: Colors.transparent,
                  //   highlightColor: Colors.transparent,
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //             builder: (context) => const PremiumPlusScreen()));
                  //   },
                  //   child: plancards(
                  //       context,
                  //       'Premium Plus ',
                  //       'Unlock all of our features to be in complete control of your experience',
                  //       'Upgrade From 100.00 INR',
                  //       bluecolor),
                  // ),

                  const SizedBox(
                    height: 40,
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
                                              width: 2, color: btncolor)),
                                      child: Center(
                                        child: (CupertinoPicker(
                                            squeeze: 1.4,
                                            looping: true,
                                            magnification: 1.08,
                                            offAxisFraction: -.2,
                                            backgroundColor: Colors.white,
                                            scrollController:
                                                FixedExtentScrollController(
                                                    initialItem: 0),
                                            itemExtent: 100,
                                            onSelectedItemChanged: (value) {
                                              setState(() {
                                                selectedProduct =
                                                    products[value];
                                              });
                                            },
                                            children: products.map((product) {
                                              var iosP;
                                              product
                                                  as GooglePlayProductDetails;
                                              if (Platform.isIOS) {
                                                iosP = product
                                                    as AppStoreProductDetails;
                                              }
                                              return Transform.rotate(
                                                angle: pi / 2,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      productList(
                                                        context: context,
                                                        product: product,
                                                        interval: Platform.isIOS
                                                            ? getInterval(
                                                                product)
                                                            : getIntervalAndroid(
                                                                product),
                                                        intervalCount: Platform
                                                                .isIOS
                                                            ? iosP
                                                                .skProduct
                                                                .subscriptionPeriod!
                                                                .numberOfUnits
                                                                .toString()
                                                            : product
                                                                .productDetails
                                                                .subscriptionOfferDetails
                                                                .toString()
                                                                .split("")[1],
                                                        price: product.price,
                                                        onTap: () {
                                                          null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList())),
                                      ),
                                    ),
                                  ),
                                ),
                                selectedProduct != null
                                    ? Center(
                                        child: ListTile(
                                          title: Text(
                                            selectedProduct!.price,
                                            textAlign: TextAlign.center,
                                          ),
                                          subtitle: Text(
                                            selectedProduct!.description,
                                            textAlign: TextAlign.center,
                                          ),
                                          trailing: Text(
                                              "${products.indexOf(selectedProduct!) + 1}/${products.length}"),
                                        ),
                                      )
                                    : Container()
                              ],
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.width * .8,
                              child: Center(
                                child: Text(
                                  "No Active Product Found!!".tr().toString(),
                                  style: const TextStyle(
                                    fontFamily: AppStrings.fontname,
                                  ),
                                ),
                              ),
                            )
                ],
              ),
            ),

            // Platform.isIOS
            //     ? InkWell(
            //         child: Container(
            //             decoration: BoxDecoration(
            //                 shape: BoxShape.rectangle,
            //                 borderRadius: BorderRadius.circular(25),
            //                 gradient: LinearGradient(
            //                     begin: Alignment.topRight,
            //                     end: Alignment.bottomLeft,
            //                     colors: [
            //                       primaryColor.withOpacity(.5),
            //                       primaryColor.withOpacity(.8),
            //                       primaryColor,
            //                       primaryColor
            //                     ])),
            //             height: MediaQuery.of(context).size.height * .055,
            //             width: MediaQuery.of(context).size.width * .55,
            //             child: Center(
            //                 child: Text(
            //               "RESTORE PURCHASE".tr().toString(),
            //               style: TextStyle(
            //                   fontSize: 15,
            //                   color: textColor,
            //                   fontWeight: FontWeight.bold),
            //             ))),
            //         onTap: () async {
            //           // var result = await _getpastPurchases();
            //           // if (result.length == 0) {
            //           //   showDialog(
            //           //       context: context,
            //           //       builder: (ctx) {
            //           //         return AlertDialog(
            //           //           content:
            //           //               Text("No purchase found".tr().toString()),
            //           //           title: Text("Past Purchases".tr().toString()),
            //           //         );
            //           //       });
            //           // }
            //         },
            //       )
            //     : Container(),
            // const SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: <Widget>[
            //       GestureDetector(
            //         child: Text(
            //           "Privacy Policy".tr().toString(),
            //           style: TextStyle(
            //             color: btncolor,
            //             fontFamily: AppStrings.fontname,
            //           ),
            //         ),
            //         onTap: () => launch(
            //             "https://www.deligence.com/apps/hookup4u/Privacy-Policy.html"),
            //       ),
            //       GestureDetector(
            //         child: Text(
            //           "Terms & Conditions".tr().toString(),
            //           style: TextStyle(
            //             color: btncolor,
            //             fontFamily: AppStrings.fontname,
            //           ),
            //         ),
            //         onTap: () => launch(
            //             "https://www.deligence.com/apps/hookup4u/Terms-Service.html"),
            //       ),
            //     ],
            //   ),
            // ),
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
              color: Colors.white,
              border: Border.all(width: 2, color: primaryColor))
          : null,
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Text(intervalCount,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up color if product get selected
                      ? Colors.black
                      : primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          Text(interval,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up color if product get selected
                      ? Colors.black
                      : primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          Text(price,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up product if product get selected
                      ? Colors.black
                      : primaryColor,
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
        print(products.length);
        print(response.productDetails);
      });

      //initial selected of products
      products.forEach((element) {});

      selectedProduct = (products.length > 0 ? products[0] : null)!;
    }
  }

  // Future<void> _getProducts(List<String> _productIds) async {
  //   print('----------${_productIds.length}');
  //   if (_productIds.length > 0) {
  //     Set<String> ids = Set.from(_productIds);
  //     print('====**$ids');
  //     ProductDetailsResponse response = await _iap!.queryProductDetails(ids);
  //     setState(() {
  //       products = response.productDetails;
  //       print(products.length);
  //       print(response.productDetails);
  //     });

  //     if (products.isNotEmpty) {
  //       // Do something with the products
  //       // For example, select the first product
  //       selectedProduct = products[0];
  //     } else {
  //       // Handle the case where there are no products
  //       // You might want to set selectedProduct to null or some default value
  //       selectedProduct = null;
  //     }
  //   }
  // }

  ///get past purchases of user
  // Future _getpastPurchases() async {
  //   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
  //   for (PurchaseDetails purchase in response.pastPurchases) {
  //     if (Platform.isIOS) {
  //       _iap.completePurchase(purchase);
  //     }
  //   }
  //   setState(() {
  //     purchases = response.pastPurchases;
  //   });
  //   if (purchases.length > 0) {
  //     purchases.forEach(
  //       (purchase) async {
  //         print('Plan    ${purchase.productID}');
  //         await _verifyPuchase(purchase.productID);
  //       },
  //     );
  //   } else {
  //     return purchases;
  //   }
  // }

  /// check if user has pruchased
  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere(
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
    } else if (purchase != null && purchase.status == PurchaseStatus.error) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                Subscription(widget.currentUser, false, widget.items)),
      );
    }
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
    //product.productDetails.subscriptionOfferDetails.toString().split("")[2];
    if (durCode == "M" || durCode == "m") {
      return "Month(s)";
    } else if (durCode == "Y" || durCode == "y") {
      return "Year";
    } else {
      return "Week(s)";
    }
  }
}

Widget plancards(context, plans, discriptions, amount, colorback) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.2,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      color: colorback,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          plans,
          style: const TextStyle(
            fontFamily: AppStrings.fontname,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          discriptions,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppStrings.fontname,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              amount,
              style: const TextStyle(
                fontFamily: AppStrings.fontname,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
