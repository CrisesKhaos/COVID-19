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
  List<DataRow> rows = [];
  bool _srtAsc = false;
  int _srtIndex = 0;
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
      tData["recovered"],
      tData["deaths"],
    );
  }

  toDataCells() {
    countrys.forEach((element) {
      DataRow x = DataRow(
        cells: [
          DataCell(Text(element.name)),
          DataCell(Text(element.confirmed.toString())),
          DataCell(Text(element.getActive())),
        ],
      );
      rows.add(x);
    });
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
    return Scaffold(
        appBar: AppBar(
          title: Text("COVID-19"),
        ),
        body: SingleChildScrollView(
          child: DataTable(
            sortAscending: _srtAsc,
            sortColumnIndex: _srtIndex,
            columns: [
              DataColumn(
                  label: Text("Country"),
                  onSort: (index, srtAsc) {
                    print('heello');
                    if (srtAsc)
                      setState(() {
                        _srtIndex = index;
                        countrys.sort((a, b) => a.name.compareTo(b.name));
                        _srtAsc = !_srtAsc;
                      });
                    else
                      setState(() {
                        _srtIndex = index;
                        _srtAsc = !_srtAsc;
                        countrys.sort((a, b) => b.name.compareTo(a.name));
                      });
                  }),
              DataColumn(
                  label: Text("Confirmed"),
                  numeric: true,
                  onSort: (index, srtAsc) {
                    print('heello');
                    if (srtAsc)
                      setState(() {
                        _srtIndex = index;
                        countrys.sort((a, b) => a.confirmed.compareTo(b.confirmed));
                        _srtAsc = !_srtAsc;
                      });
                    else
                      setState(() {
                        _srtIndex = index;
                        _srtAsc = !_srtAsc;
                        countrys.sort((a, b) => b.confirmed.compareTo(a.confirmed));
                      });
                  }),
              DataColumn(
                  label: Text("Active"),
                  numeric: true,
                  onSort: (index, srtAsc) {
                    print('heello');
                    if (srtAsc)
                      setState(() {
                        _srtIndex = index;
                        countrys.sort((a, b) => a.getActive().compareTo(b.getActive()));
                        _srtAsc = !_srtAsc;
                      });
                    else
                      setState(() {
                        _srtIndex = index;
                        _srtAsc = !_srtAsc;
                        countrys.sort((a, b) => b.getActive().compareTo(a.getActive()));
                      });
                  }),
            ],
            rows: countrys
                .map((element) => DataRow(
                      cells: [
                        DataCell(Text(element.name)),
                        DataCell(Text(element.confirmed.toString())),
                        DataCell(Text(element.getActive())),
                      ],
                    ))
                .toList(),
          ),
        ));
  }
}
