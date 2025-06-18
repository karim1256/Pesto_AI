import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/payment/model/payment_method_model.dart';
import 'package:gradutionproject/Features/payment/model/visa_response_model.dart';
import 'package:gradutionproject/Features/payment/pay_with_code.dart';
import 'package:gradutionproject/Features/payment/web_view.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'model/payment_data_msary.dart';

class payment extends StatefulWidget {
  const payment({super.key});

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  bool isLoading = false;
  PaymentMethod? paymentMethod;
  VisaResponseModel? visaResponseModel;
  MsaaryModel? msaaryModel;
  String accessToken = 'd83a5d07aaeb8442dcbe259e6dae80a3f2e21a3a581e1a5acd';

  Future<void> getPaymentMethod() async {
    setState(() {
      isLoading = true;
    });
    const apiUrl = 'https://staging.fawaterk.com/api/v2/getPaymentmethods';
    Dio dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    dio.interceptors.add(PrettyDioLogger());

    try {
      var respone = await dio.get(apiUrl);
      paymentMethod = PaymentMethod.fromJson(respone.data);
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> processPaymentMethod(int paymentMethodID) async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    dio.interceptors.add(PrettyDioLogger());
    final apiUrl = 'https://staging.fawaterk.com/api/v2/invoiceInitPay';

    try {
      final requestData = {
        'payment_method_id': paymentMethodID,
        'cartTotal': '500',
        'currency': 'EGP',
        'customer': {
          'first_name': 'test',
          'last_name': 'test',
          'email': 'test@test.test',
          'phone': '01000000000',
          'address': 'test address',
        },
        'redirectionUrls': {
          'successUrl':
              'https://c8da-154-178-61-85.ngrok-free.app/api/v1/transactions/success',
          'failUrl':
              'https://c8da-154-178-61-85.ngrok-free.app/api/v1/transactions/fail',
          'pendingUrl':
              'https://c8da-154-178-61-85.ngrok-free.app/api/v1/transactions/pending',
        },
        'cartItems': [
          {'name': 'test', 'price': '500', 'quantity': '1'},
        ],
      };
      var response = await dio.post(apiUrl, data: requestData);
      if (paymentMethodID == 14 || paymentMethodID == 3) {
        print(
          '------------------------------------------${response.data['data']['payment_data']['masaryCode']}',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PayWithCode(
                  code:
                      paymentMethodID == 14
                          ? response.data['data']['payment_data']['masaryCode']
                              .toString()
                          : response.data['data']['payment_data']['fawryCode']
                              .toString(),
                ),
          ),
        );
      } else {
        visaResponseModel = VisaResponseModel.fromJson(response.data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => WebView(
                  url:   
          paymentMethodID == 4?
                   "https://staging.fawaterk.com/lk/40434":
                  visaResponseModel!.data!.paymentData!.redirectTo!,
                ),
          ),
        );
      }
    } catch (e) {
      print("error");
    }
  }

  @override
  void initState() {
    getPaymentMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight(context) * 0.06),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: screenWidth(context) * 0.01),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: MainColor,
                    size: screenWidth(context) * 0.1,
                  ),
                ),
                LoginUPFormat(
                  "Payment",
                  "Choose your Appropriate Payment Method",
                  context,
                ),
              ],
            ),
            SizedBox(height: screenHeight(context) * 0.015),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child: ListView.separated(
                    itemCount: paymentMethod!.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              processPaymentMethod(
                                paymentMethod!.data![index].paymentId!,
                              );
                            },
                            title: Text(paymentMethod!.data![index].nameEn!),
                            subtitle: Text(paymentMethod!.data![index].nameAr!),
                            leading: Image.network(
                              paymentMethod!.data![index].logo!,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: screenHeight(context) * 0.015),
                          Divider(
                            indent: screenWidth(context) * 0.17,
                            endIndent: screenWidth(context) * 0.17,
                            color: MainColor,
                            thickness: screenHeight(context) * 0.0012,
                          ),
                        ],
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
