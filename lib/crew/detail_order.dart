import 'dart:convert';

import 'package:brothers88/crew/main_page.dart';
import 'package:brothers88/theme.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailOrder extends StatefulWidget {
  String id;

  String meja;
  String? note;
  String nama;

  DetailOrder(
      {Key? key,
      required String this.id,
      required String? this.note,
      required String this.nama,
      required String this.meja})
      : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  late Future<List<Detail>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: [],
            title: Text("Detail Order"),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                 left:MediaQuery.of(context).size.width/20,  top: 20,right: MediaQuery.of(context).size.width/20),
            child: ListView(
              children: [
                Text(
                  'Nama Pemesan: ${widget.nama}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text("${widget.note}"),
                 SizedBox(
                   height: MediaQuery.of(context).size.height/2,
                   child:  FutureBuilder<List<Detail>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Detail>? data = snapshot.data;
                        return ListView.builder(
                            itemCount: data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Colors.grey[900],
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10,top: 10),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${data![index].menu['name']} - ${data[index].qty}",style: TextStyle(color: Colors.white, fontSize: 18)),
                                    Text(data[index].detail == null ? "-" : data[index].detail.toString().replaceAll("<br />", " "),style: TextStyle(color: Colors.white, fontSize: 15)),
                                    const SizedBox(height: 20,)
                                  ],
                                ),
                                )
                              );
                            }
                              );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                 ),
                 Center(
                   child: SizedBox(
                  width: MediaQuery.of(context).size.width/3,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      validate(widget.id);
                    },
                  child: Text("Validasi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                ),
                 ))
              ],
            ),
          )),
    );
  }

  validate(id) async{
     final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.post(
        Uri.parse("https://api.brothers-88.com/crew/order/valid/${widget.id}"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        },body: {
          "_method" : "PUT"
        });
        print(response.body);
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Crew(),));
    } else {
      throw Exception('Unexpected error occured!');
    }
  }


  Future<List<Detail>> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.get(
        Uri.parse("https://api.brothers-88.com/crew/order/detail/${widget.id}"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        });
        print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];

      // return "";
      return jsonResponse.map((data) => Detail.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}

class Detail {
  final Map menu;
  final String table_id;
  final int qty;
  final String? detail;

  Detail({
    required this.menu,
    required this.table_id,
    required this.qty,
    required this.detail,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      menu: json['menu'],
      table_id: json['table_id'],
      qty: json['qty'],
      detail: json['detail'],
    );
  }
}
