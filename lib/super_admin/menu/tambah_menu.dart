import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TambahMenu extends StatefulWidget {
  TambahMenu({Key? key}) : super(key: key);

  @override
  _TambahMenuState createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  TextEditingController _price = TextEditingController();
  TextEditingController _nama = TextEditingController();
  List<dynamic> categoryData = [];
  late Future<List<CategoryList>> futureData;
  late int id = 0;
   String cat_name ='GRILL';
  // String cat_name;
  @override
  void initState() {
    super.initState();
    fetchData();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Tambah Menu"),
          actions: [],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 6, top: 5),
          child: ListView(
            children: [
              Text(
                "Nama",
                style: TextStyle(color: Colors.white),
              ),
              TextField(

                style: TextStyle(color: Colors.white),
                controller: _nama,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: "Nama Menu"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 18,
              ),
              Text(
                "Harga",
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: _price,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: "Harga"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 18,
              ),
               Text(
                "Kategori",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: DropdownButton(
                  underline: SizedBox(),
                dropdownColor: Colors.red,
                iconEnabledColor: Colors.red,
                items: categoryData.map((item) {
                  return DropdownMenuItem(
                    value: item['name'],
                    child: Text(item['name'],style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    cat_name = newValue.toString();
                    print(newValue);
                  });
                },
                value: cat_name,
              ),
              ),
              // DropdownButton(
              //   value: cat_name,
              //   icon: Icon(Icons.keyboard_arrow_down),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       cat_name = newValue!;
              //     });
              //   },
              //   items: <String>[
              //     'GRILL',
              //     'redvelvet',
              //     'lapislegit',
              //     'bikaambon',
              //     'rotitawar',
              //     'puding'
              //   ].map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList()),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              Center(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // update(_price.text, _nama.text, widget.id);
                    insert(_price.text, _nama.text, cat_name);
                  },
                  child: Text(
                    "Tambah",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  insert(price,name,category) async {
     final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.post(
        Uri.parse("https://api.brothers-88.com/superadmin/menu/insert"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        },body: {
          "category" : category,
          "price": price,
          "name":name
        });
        print(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<CategoryList>> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.get(
        Uri.parse("https://api.brothers-88.com/superadmin/category/list/"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      
      setState(() {
        categoryData = jsonResponse;
        print(categoryData);
      });
      // return "";
      return jsonResponse.map((data) => CategoryList.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}

class CategoryList {
  final int id;
  final String name;

  CategoryList({
    required this.id,
    required this.name,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(id: json['id'], name: json['name']);
  }
}
