import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'list.dart';
import 'entities/user.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _validate = false;
  bool invisible = true;
  bool _validatep = false;
  bool _validaten = false;
  late final User userJ;

  Future register() async {
    if (_validate == true || _validatep == true || _validaten == true) {}
    else {
      var url = 'https://weplant.zanhrastnik.com/register.php';
      var response = await http.post(Uri.parse(url), body: {
        "name": name.text,
        "email": user.text,
        "password": pass.text,
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context),
        );
      } else {
        userJ = User.fromJson(data);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ListPage(user: userJ)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFEFFEE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFEFFEE),
        leading:
        IconButton( onPressed: (){
          Navigator.pop(context);
        },icon:const Icon(LineAwesomeIcons.angle_left,size: 30,color: Color.fromRGBO(156, 175, 136, 1.0),)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/5,
                      decoration: const BoxDecoration(
                          image:DecorationImage(image: AssetImage('assets/weplant_logo_green.png'))
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text("Create an account, it's free",style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(156, 175, 136, 1.0),
                        ),),
                        SizedBox(height: 30,)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40
                      ),
                      child: Column(
                        children: [
                          makeInput(label: "Name", controller: name, validate: _validaten, text: 'Name'),
                          makeInput(label: "Email", controller: user, validate: _validate, text: 'Email'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Password',style:TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(156, 175, 136, 1.0)
                              ),),
                              const SizedBox(height: 5,),
                              TextFormField(
                                style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.65)),
                                obscureText: invisible,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        invisible
                                            ? LineAwesomeIcons.eye
                                            : LineAwesomeIcons.eye_slash,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          invisible = !invisible;
                                        });
                                      }),
                                  //suffixIcon: const Icon(LineAwesomeIcons.eye),
                                  errorText: _validatep ? 'Password can\'t be empty' : null,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(156, 175, 136, 1.0),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(156, 175, 136, 1.0))
                                  ),
                                ),
                                controller: pass,
                              ),
                              const SizedBox(height: 30,)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3,left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height:60,
                          onPressed: (){
                            setState(() {
                              user.text.isEmpty ? _validate = true : _validate = false;
                              pass.text.isEmpty ? _validatep = true : _validatep = false;
                              name.text.isEmpty ? _validaten = true : _validaten = false;
                            });
                            register();
                          },
                          color: const Color.fromRGBO(242, 212, 215, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: const Text("Sign Up",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFFEFFEE)
                          ),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?", style: TextStyle(
                            color: Color.fromRGBO(156, 175, 136, 1.0)
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ));
                          },
                          child: const Text("Login",style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color.fromRGBO(156, 175, 136, 1.0)
                          ),),
                        )
                      ],
                    )
                  ],

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget makeInput({label,obsureText = false,controller,validate,text}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style:const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(156, 175, 136, 1.0)
      ),),
      const SizedBox(height: 5,),
      TextFormField(
        style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.65)),
        obscureText: obsureText,
        decoration: InputDecoration(
          errorText: validate ? text + ' can\'t be empty' : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(156, 175, 136, 1.0),
            ),
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(156, 175, 136, 1.0))
          ),
        ),
        controller: controller,
      ),
      const SizedBox(height: 30,)

    ],
  );
}

Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(242, 212, 215, 1.0),
      title: const Text("Error",
        style: TextStyle(
          color: Color(0xFFFEFFEE),
      ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Oops, a user with this email already exist!",
            style: TextStyle(
                color: Color(0xFFFEFFEE),
          ),),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close',
            style: TextStyle(
                color: Color(0xFFFEFFEE)
            ),),
        ),
      ],
    );
  }