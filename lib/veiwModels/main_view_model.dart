import 'dart:convert';
import 'dart:io';

import 'package:dollar_kursi/models/currency_rate.dart';
import 'package:dollar_kursi/veiwModels/api_response.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MainViewModel extends ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial("Empty");
  List<CurrencyRate> _currencyList = [];

  ApiResponse get response {
    return _apiResponse;
  }

  List<CurrencyRate> get currencies {
    return _currencyList;
  }

  Future<ApiResponse> getCurrencyRate({int? delay}) async {
    String url = "https://nbu.uz/uz/exchange-rates/json/";
    Uri myUrl = Uri.parse(url);

    try {
      var response = await http.get(myUrl);
      List data = jsonDecode(response.body);

      _currencyList.clear();

      data.forEach((element) {
        _currencyList.add(CurrencyRate.fromJson(element));
      });

      _apiResponse = ApiResponse.succes(_currencyList);
    } catch (exception) {
      if (exception is SocketException) {
        _apiResponse = ApiResponse.error("No Internet Connection");
      } else {
        _apiResponse = ApiResponse.error(exception.toString());
      }
    }
    return _apiResponse;
  }
}
