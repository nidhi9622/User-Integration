import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    checkData();
    super.initState();
  }

  checkData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("database")) {
      String? newList = preferences.getString('database');
      list = jsonDecode(newList!);
    } else {
      list = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff87CEEB),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: list.length != 0
                  ? ListView.builder(
                      itemCount: list.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Name:",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text("${list[index]['name']}",
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Email:",
                                              style: TextStyle(fontSize: 18)),
                                          Text("${list[index]['email']}",
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Dob:",
                                              style: TextStyle(fontSize: 18)),
                                          Text("${list[index]['dob']}",
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Password:",
                                              style: TextStyle(fontSize: 18)),
                                          Text("${list[index]['password']}",
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedIndex = 1;
                                            });
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TabBarWidget(
                                                          object: list[index],
                                                          buttonText: 'Update',
                                                        )));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            setState(() {
                                              list.removeAt(index);
                                            });
                                            SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            preferences.setString(
                                                'database', jsonEncode(list));
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          )),
                                    ],
                                  )),
                            ],
                          ),
                        );
                      })
                  : const Center(
                      child: Text(
                      "No Data",
                      style: TextStyle(fontSize: 26),
                    ))),
        ),
      ),
    );
  }
}
