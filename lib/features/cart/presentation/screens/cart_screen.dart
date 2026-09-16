// cart_screen.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List myCart = [];
  late Future getCartFuture;
  Future<List> getCart() async {
    try {
      final Dio dio = Dio();
      final Response response = await dio.get(
        'https://talabat639.runasp.net/api/Basket',
        options: Options(
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9naXZlbm5hbWUiOiJhbXIxMjMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhbXIxMjNAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJjNjJiODQzYi0wOWVlLTQxNWYtOWMwMC1kMmRkODViYmE1YmUiLCJleHAiOjE3ODk2NjQ1MzAsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjQiLCJhdWQiOiJNeVNlY3VyZWRBUElVc2VycyJ9.TeBERVi2Vo0_JgJ2ONf8pZYpasleeq8MQcjuojAlijk',
          },
        ),
      );
      log("Response: $response");

      myCart = response.data['items'];
      return myCart;
    } on DioException catch (e) {
      log(e.response?.data.toString() ?? 'Error');
      throw Exception(e.response?.data['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    getCartFuture = getCart();
    log(getCartFuture.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Cart", style: AppStyles.style30ExtraBold),
                Text(
                  "2 items",
                  style: AppStyles.style13Medium.copyWith(
                    color: AppColors.greyClr,
                  ),
                ),
                SizedBox(height: 10),

                Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(15),
                                      child: Image.network(
                                        myCart[index]['pictureUrl'],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ldbljeb',
                                        style: AppStyles.style14Bold,
                                      ),
                                      Text(
                                        '${myCart[index]['brand']} · ${myCart[index]['category']}',
                                        style: AppStyles.style11Medium,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${myCart[index]['price']} EGP',
                                            style: AppStyles.style14Bold,
                                          ),
                                          Spacer(),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.remove),
                                          ),
                                          Text(
                                            myCart[index]['quantity']
                                                .toString(),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.add),
                                          ),
                                        ],
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text("Order Summary", style: AppStyles.style14Bold),
                            SizedBox(height: 10),
                            CustomSummaryItem(title: 'Subtotal', value: '400'),
                            CustomSummaryItem(
                              title: 'Delivery Fee',
                              value: '25',
                            ),

                            Divider(),

                            Row(
                              children: [
                                Text('Total', style: AppStyles.style16Bold),
                                Spacer(),
                                Text(
                                  '420 EGP',
                                  style: AppStyles.style16Bold.copyWith(
                                    color: AppColors.primayClr,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSummaryItem extends StatelessWidget {
  const CustomSummaryItem({
    super.key,
    required this.title,
    required this.value,
  });
  final String title, value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppStyles.style14Medium.copyWith(color: AppColors.greyClr),
        ),
        Spacer(),
        Text('$value EGP', style: AppStyles.style14SemiBold),
      ],
    );
  }
}
