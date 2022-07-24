import 'dart:convert';

import 'package:brothers88/admin/main_page.dart';
import 'package:brothers88/crew/main_page.dart';
import 'package:brothers88/super_admin/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brothers88/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:brothers88/widgets/custom_checkbox.dart';
import 'package:brothers88/widgets/primary_button.dart';
import 'theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late ScaffoldMessengerState scaffoldMessenger;

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width/2,
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textBlack,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: textGrey),
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textBlack,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: textGrey),
                        controller: _passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: togglePassword,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),

              SizedBox(
                height: 32,
              ),
              Center(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    login(_emailController.text, _passwordController.text);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              )),
              // GestureDetector(
              //   OnPRess: () {
              //     login(_emailController, _passwordController);
              //   },
              //   child: CustomPrimaryButton(
              //     buttonColor: Colors.red,
              //     textValue: 'Login',
              //     textColor: Colors.white,
              //   ),
              // ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  login(email, password) async {
    Map body = {'email': email, 'password': password};
    print(body.toString());
    final response =
        await http.post(Uri.parse("https://api.brothers-88.com/auth/login"),
            headers: {
              "Accept": "application/json",
              "Access-Control-Allow-Origin": "*",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: body,
            encoding: Encoding.getByName("utf-8"));
    print(response.body);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      var token = data['data']['token'];
      var role = data['data']['user']['role'];
      print(role);
      if (response.statusCode != 402) {
        savePref(token);
        if (role == "Admin") {
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin(),
              ));
        } else if (role == "Crew") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Crew(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SupperAdmin(),
              ));
        }
      } else {
        // print(data.);
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text("Mohon cek  username dan password anda!")));
      }
      // scaffoldMessenger
      //     .showSnackBar(SnackBar(content: Text("${data['message']}")));
    } else {
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(
              "Uppss, Ada yang salah!!,Silahkan cek kembali username dan password anda")));
    }
  }

  savePref(String token) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    // preferences.commit();
  }
}
