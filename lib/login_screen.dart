import 'package:flutter/material.dart';

import 'main.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  dynamic correctEmail;
  dynamic newObject;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                  color: Color(0xff87CEEB),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: emailController,
                        validator: (String? value){
                          for(int i=0;i<list.length;i++){
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            else if(list[i]['email']!=emailController.text.trim()){
                              return "Invalid Email";
                            }
                            else if(list[i]['email']==emailController.text.trim()){
                              setState(() {
                                newObject=list[i];
                              });
                            }
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText:"Enter your Email"
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_passwordVisible,
                        validator: (String? value){
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          else if(newObject.isNotEmpty){
                            if(passwordController.text.trim()!=newObject['password']){
                              return "Invalid password";
                            }
                          }return null;
                        },
                        decoration: InputDecoration(
                          hintText:"Enter your Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:  Colors.blueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 40,),
                      InkWell(
                        onTap: (){
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Welcome!"),
                                    content: Text("Hello ${newObject['name']}"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child:const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                        child: Container(
                          padding: const EdgeInsets.all( 12.0),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal:10.0),
                            child: Text("Login",style: TextStyle(fontSize:20,color: Colors.white),),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
