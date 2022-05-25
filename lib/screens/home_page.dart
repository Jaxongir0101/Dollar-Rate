import 'dart:ui';

import 'package:dollar_kursi/screens/details_page.dart';
import 'package:dollar_kursi/veiwModels/api_response.dart';
import 'package:dollar_kursi/veiwModels/main_view_model.dart';
import 'package:provider/provider.dart';

import 'package:dollar_kursi/models/currency_rate.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List rateImage = [
    "assets/images/AED.png",
    "assets/images/AUD.png",
    "assets/images/CAD.png",
    "assets/images/CHF.png",
    "assets/images/CNY.png",
    "assets/images/DKK.png",
    "assets/images/EGP.png",
    "assets/images/EUR.png",
    "assets/images/GBP.png",
    "assets/images/ISK.png",
    "assets/images/JPY.png",
    "assets/images/KRW.png",
    "assets/images/KWD.png",
    "assets/images/KZT.png",
    "assets/images/LBP.png",
    "assets/images/MYR.png",
    "assets/images/NOK.png",
    "assets/images/PLN.png",
    "assets/images/RUB.png",
    "assets/images/SEK.png",
    "assets/images/SGD.png",
    "assets/images/TRY.png",
    "assets/images/UAH.png",
    "assets/images/USD.png",
  ];
  Future<ApiResponse>? futureWords;

  MainViewModel? _mainVM;
  List list = [];

  @override
  void initState() {
    super.initState();
    _mainVM = Provider.of<MainViewModel>(context, listen: false);
    futureWords = MainViewModel().getCurrencyRate(delay: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        title: const Text("Dollar Exchange Rate"),
        actions: [
          IconButton(
              onPressed: () {
                _pullRefresh();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
          child: FutureBuilder(
              future: futureWords,
              builder: (context, snapshot) {
                return RefreshIndicator(
                  child: _listView(snapshot),
                  onRefresh: _pullRefresh,
                );
              })),
    );
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if (snapshot.data?.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data?.status == Status.SUCCES) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: ListView.builder(
            itemCount: snapshot.data?.data?.length,
            itemBuilder: (BuildContext context, int index) {
              print(snapshot.data?.data[index].code);
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 132,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  rateImage[index],
                                  height: 18,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  snapshot.data?.data[index].code ?? "..",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.black54,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "MB kursi",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  snapshot.data?.data[index].cb_price
                                              .toString()
                                              .length ==
                                          0
                                      ? "-"
                                      : snapshot.data?.data[index].cb_price ??
                                          "...",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Sotib olish",
                                    style: TextStyle(color: Colors.black54)),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  snapshot.data?.data[index].nbu_buy_price
                                              .toString()
                                              .length ==
                                          0
                                      ? "-"
                                      : snapshot.data?.data[index]
                                              .nbu_buy_price ??
                                          "...",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Sotish",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  snapshot.data?.data[index].nbu_cell_price
                                              .toString()
                                              .length ==
                                          0
                                      ? "-"
                                      : snapshot.data?.data[index]
                                              .nbu_cell_price ??
                                          "...",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    }
    if (snapshot.data?.status == Status.ERROR) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage(
                'assets/images/internet.gif',
              ),
              fit: BoxFit.cover,
            ),
          ],
        ),
      );
    }

    return buildError(snapshot.data?.message);
  }

  Future<void> _pullRefresh() async {
    ApiResponse freshFutureWords =
        await MainViewModel().getCurrencyRate(delay: 2);
    setState(() {
      futureWords = Future.value(freshFutureWords);
    });
  }

  Widget buildError(String? errorMsg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMsg ?? "",
            
          ),
          Image.asset("assets/images/gif.gif"),
         const SizedBox(height: 30,),
        
        ],
      ),
    );
  }
}
