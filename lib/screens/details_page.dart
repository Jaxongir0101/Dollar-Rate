import 'package:dollar_kursi/veiwModels/api_response.dart';
import 'package:dollar_kursi/veiwModels/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage(AsyncSnapshot snapshot, int index, {Key? key})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  MainViewModel? _mainVM;

  @override
  void initState() {
    super.initState();
    _mainVM = Provider.of<MainViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: FutureBuilder(
        future: _mainVM?.getCurrencyRate(),
        builder: (
          context,
          snapshot,
        ) {
          return Card(
            child: Text(""),
          );
        },
      )),
    );
  }
}
