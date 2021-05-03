import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:main/country_class.dart';
import 'package:main/state_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<dynamic, dynamic> data = {};
  Map<dynamic, dynamic> vData = {};
  Map<dynamic, dynamic> changeData = {};
  final String url = "https://covid-api.mmediagroup.fr/v1/cases";
  final String indiaChange =
      "https://api.apify.com/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST?disableRedirect=true";
  List<Country> countrys = [];
  List<Country> states = [];

  bool _srtAsc = false;
  int _srtIndex = 0;
  bool _stateAsc = false;
  int _stateIndex = 0;
  updateJson() async {
    final response = await http.get(Uri.https("covid-api.mmediagroup.fr", "/v1/cases"));

    if (response.statusCode == 200)
      setState(() {
        data = jsonDecode(response.body);
      });
    else
      throw Exception("Prolemo");
  }

  getVData() async {
    final response = await http.get(Uri.https("covid-api.mmediagroup.fr", "/v1/vaccines"));

    if (response.statusCode == 200) {
      setState(() {
        vData = jsonDecode(response.body);
      });
    } else
      throw Exception("POtty ho gyi");
  }

  Country toCountry(String country) {
    Map tData = data[country]["All"];

    return Country(
      country,
      tData["confirmed"],
      tData["recovered"],
      tData["deaths"],
      vaccinated: vData[country] != null ? vData[country]["All"]["administered"] : 0,
    );
  }

  getStates() {
    data["India"].forEach((key, value) {
      if (key != "All") {
        Country x = new Country(key, value["confirmed"], value["recovered"], value["deaths"]);
        setState(() {
          states.add(x);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getVData();
    updateJson().whenComplete(() {
      data.forEach((key, value) {
        Country tCnt = toCountry(key);
        setState(() {
          countrys.add(tCnt);
        });
      });
      getStates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            elevation: 2,
            title: Text("COVID-19",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Lemon",
                  color: Colors.grey[800],
                )),
            bottom: TabBar(
              indicatorColor: Colors.blueGrey[200],
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/world.png",
                      color: Colors.blueGrey[200],
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/india.png",
                      color: Colors.blueGrey[200],
                    ),
                  ),
                )
              ],
            )),
        body: TabBarView(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortAscending: _srtAsc,
                sortColumnIndex: _srtIndex,
                columns: [
                  DataColumn(
                      label: Text(
                        "Country",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onSort: (index, srtAsc) {
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
                      label: Text(
                        "Confirmed",
                        style: TextStyle(
                          color: Colors.redAccent[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      label: Text(
                        "Active",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
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
                  DataColumn(
                      label: Text(
                        "Recovered",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        print('heello');
                        if (srtAsc)
                          setState(() {
                            _srtIndex = index;
                            countrys.sort((a, b) => a.recovered.compareTo(b.recovered));
                            _srtAsc = !_srtAsc;
                          });
                        else
                          setState(() {
                            _srtIndex = index;
                            _srtAsc = !_srtAsc;
                            countrys.sort((a, b) => b.recovered.compareTo(a.recovered));
                          });
                      }),
                  DataColumn(
                      label: Text(
                        "Deceased",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        print('heello');
                        if (srtAsc)
                          setState(() {
                            _srtIndex = index;
                            countrys.sort((a, b) => a.deaths.compareTo(b.deaths));
                            _srtAsc = !_srtAsc;
                          });
                        else
                          setState(() {
                            _srtIndex = index;
                            _srtAsc = !_srtAsc;
                            countrys.sort((a, b) => b.deaths.compareTo(a.deaths));
                          });
                      }),
                  DataColumn(
                      label: Text(
                        "Vaccinated",
                        style: TextStyle(
                          color: Colors.orangeAccent[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        print('heello');
                        if (srtAsc)
                          setState(() {
                            _srtIndex = index;
                            countrys.sort((a, b) => a.vaccinated.compareTo(b.vaccinated));
                            _srtAsc = !_srtAsc;
                          });
                        else
                          setState(() {
                            _srtIndex = index;
                            _srtAsc = !_srtAsc;
                            countrys.sort((a, b) => b.vaccinated.compareTo(a.vaccinated));
                          });
                      }),
                ],
                rows: countrys
                    .map((element) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                element.name,
                                style: TextStyle(color: Colors.brown[900]),
                              ),
                            ),
                            DataCell(Text(element.confirmed.toString())),
                            DataCell(Text(element.getActive())),
                            DataCell(Text(element.recovered.toString())),
                            DataCell(Text(element.deaths.toString())),
                            DataCell(Text(element.vaccinated.toString())),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),

          //?2nd tab of india

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortAscending: _stateAsc,
                sortColumnIndex: _stateIndex,
                columns: [
                  DataColumn(
                      label: Text(
                        "State",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSort: (index, srtAsc) {
                        if (srtAsc)
                          setState(() {
                            _stateIndex = index;
                            states.sort((a, b) => a.name.compareTo(b.name));
                            _stateAsc = !_stateAsc;
                          });
                        else
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => b.name.compareTo(a.name));
                          });
                      }),
                  DataColumn(
                      label: Text(
                        "Confirmed",
                        style: TextStyle(
                          color: Colors.redAccent[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        print('heello');
                        if (srtAsc)
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;

                            states.sort((a, b) => a.confirmed.compareTo(b.confirmed));
                          });
                        else
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => b.confirmed.compareTo(a.confirmed));
                          });
                      }),
                  DataColumn(
                      label: Text(
                        "Active",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        if (srtAsc)
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => a.getActive().compareTo(b.getActive()));
                          });
                        else
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => b.getActive().compareTo(a.getActive()));
                          });
                      }),
                  DataColumn(
                      label: Text(
                        "Recovered",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        print('heello');
                        if (srtAsc)
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => a.recovered.compareTo(b.recovered));
                          });
                        else
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => b.recovered.compareTo(a.recovered));
                          });
                      }),
                  DataColumn(
                      label: Text(
                        "Deceased",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                      onSort: (index, srtAsc) {
                        print('heello');
                        if (srtAsc)
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => a.deaths.compareTo(b.deaths));
                          });
                        else
                          setState(() {
                            _stateIndex = index;
                            _stateAsc = !_stateAsc;
                            states.sort((a, b) => b.deaths.compareTo(a.deaths));
                          });
                      }),
                ],
                rows: states
                    .map((element) => DataRow(
                          cells: [
                            DataCell(
                              Text(element.name),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => StatePage(element)));
                              },
                            ),
                            DataCell(Text(element.confirmed.toString())),
                            DataCell(Text(element.getActive())),
                            DataCell(Text(element.recovered.toString())),
                            DataCell(Text(element.deaths.toString()))
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
