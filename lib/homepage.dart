import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:main/country_class.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<dynamic, dynamic> data = {};
  final String url = "https://covid-api.mmediagroup.fr/v1/cases";
  List<Country> countrys = [];

  updateJson() async {
    final response = await http.get(Uri.https("covid-api.mmediagroup.fr", "/v1/cases"));

    if (response.statusCode == 200)
      setState(() {
        print('hiii');
        print(jsonDecode(response.body));
        data = jsonDecode(response.body);
      });
    else
      throw Exception("Prolemo");
  }

  Country toCountry(String country) {
    Map tData = data[country]["All"];
    return Country(
      country,
      tData["confirmed"],
      tData["active"],
      tData["recovered"],
      tData["deaths"],
    );
  }

  @override
  void initState() {
    super.initState();
    updateJson().whenComplete(() {
      data.forEach((key, value) {
        Country tCnt = toCountry(key);
        setState(() {
          countrys.add(tCnt);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19"),
      ),
      body: ListView.builder(
        itemCount: countrys.length,
        itemBuilder: (context, index) {
          return Text(countrys[index].confirmed.toString());
        },
      ),
    );
  }
}
