import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'country_class.dart';

class StatePage extends StatefulWidget {
  final Country stateData;
  StatePage(this.stateData);
  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  Map changeData = {};

  get24() async {
    final response =
        await http.get(Uri.https("api.apify.com", "v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST"));

    if (response.statusCode == 200) {
      List x = jsonDecode(response.body)["regionData"];
      x.forEach((element) {
        if (element["region"].toString() == widget.stateData.name)
          setState(() {
            changeData = element;
          });
      });
    } else
      throw Exception(response.statusCode);
  }

  @override
  void initState() {
    get24();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(changeData);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 2,
        title: Text("State Data",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[800],
            )),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Center(
                    child: Text(
                  widget.stateData.name,
                  style: TextStyle(fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Card(
                      color: Color.fromRGBO(231, 76, 60, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 21),
                        child: Column(
                          children: [
                            Text(
                              "Confirmed",
                            ),
                            Text(widget.stateData.confirmed.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Color.fromRGBO(41, 128, 185, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(children: [
                          Text("Active"),
                          Text(widget.stateData.getActive().toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Color.fromRGBO(149, 165, 166, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(children: [
                          Text("Deceased"),
                          Text(widget.stateData.deaths.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text("Recent(24h) data",
                      style: TextStyle(
                        fontSize: 21,
                      )),
                ),
              ),
              Column(
                children: [
                  Divider(
                    thickness: 1.1,
                    endIndent: 30,
                    indent: 30,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Confirmed",
                        style: TextStyle(
                          color: Colors.redAccent[100],
                        ),
                      ),
                      Text(
                        (changeData["newRecovered"] + changeData["newDeceased"] + changeData["newInfected"])
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.1,
                    endIndent: 30,
                    indent: 30,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Active",
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        changeData["newInfected"].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.1,
                    endIndent: 30,
                    indent: 30,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Recovered",
                        style: TextStyle(
                          color: Colors.green[400],
                        ),
                      ),
                      Text(
                        changeData["newRecovered"].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.1,
                    endIndent: 30,
                    indent: 30,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Deceased",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        changeData["newDeceased"].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.1,
                    endIndent: 30,
                    indent: 30,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: -50,
              left: -50,
              child: Transform(
                transform: Matrix4.rotationZ(.5),
                child: Image.asset(
                  "assets/images/COVID.png",
                  width: 300,
                  height: 300,
                ),
              ))
        ],
      ),
    );
  }
}
