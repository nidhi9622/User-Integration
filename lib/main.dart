import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:user_intergraction/login_screen.dart';
import 'package:user_intergraction/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_page.dart';

void main() {
  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabBarWidget(object: {}, buttonText: 'Register',)));
}
class TabBarWidget extends StatefulWidget {
  Map object;
  String buttonText;
   TabBarWidget({Key? key,required this.object,required this.buttonText}) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}
List list=[];
int selectedIndex=0;
class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  void initState() {
    checkData();
    super.initState();
  }
  checkData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    if(preferences.containsKey("database")){
      String? newList=preferences.getString('database');
      list=jsonDecode(newList!);
    }
    else{
      list=[];
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          return true;
        },
        child: DefaultTabController(
          initialIndex: selectedIndex,
          length: 3,
          child: Scaffold(
            appBar: AppBar(automaticallyImplyLeading: false,
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.security)),
                  Tab(icon: Icon(Icons.person)),
                  Tab(icon: Icon(Icons.people)),
                ],
              ),
              title: const Text('User Integration'),
            ),
            body:  TabBarView(
              children: [
                 const LoginScreen(),
                 RegistrationScreen(object: widget.object, buttonText: widget.buttonText),
                 const DetailPage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

