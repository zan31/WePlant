import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:we_plant/entities/user.dart';
import 'package:we_plant/my_plant.dart';
import 'list.dart';
import 'main.dart';

class UserPage extends StatefulWidget {
  final User userU;

  const UserPage({Key? key, required this.userU}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPage();
}

  class _UserPage extends State<UserPage> {
    late User userU;
    bool invisible = true;
    bool _validate = false;
    bool _validatep = false;
    bool _validaten = false;
    late TextEditingController name;
    late TextEditingController email;
    late TextEditingController pass;

    Future update() async {
      if (_validate == true || _validatep == true || _validaten == true) {}
      if(name.text == userU.uName && email.text == userU.uEmail && pass.text == userU.uPass){
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialogn(context),
        );
      }
      else {
        var url = 'https://weplant.zanhrastnik.com/update.php';
        var response = await http.post(Uri.parse(url), body: {
          "id": userU.uId.toString(),
          "name": name.text,
          "email": email.text,
          "password": pass.text,
        });
        var data = json.decode(response.body);
        if (data == "Error") {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        } else {
          userU = User.fromJson(data);
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialogs(context),
          );
        }
      }
    }

    @override
    void initState() {
      invisible;
      userU = widget.userU;
      name = TextEditingController(text: userU.uName);
      email = TextEditingController(text: userU.uEmail);
      pass = TextEditingController(text: userU.uPass);
      super.initState();
    }


@override
    Widget build(BuildContext context) {
    return Scaffold(
        drawer: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0), bottom: Radius.circular(12.0)),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(156, 175, 136, 1.0),
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage('assets/weplant_logo_big.png'))), child: null,
                  ),
                  ListTile(
                    leading: const Icon(LineAwesomeIcons.home, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                    title: const Text('Home',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                          fontSize: 15
                      ),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListPage(user: userU,),
                          ))
                    },
                  ),
                  ListTile(
                    leading: const Icon(LineAwesomeIcons.leaf, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                    title: const Text('My plants',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                          fontSize: 15
                      ),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => myPlantsPage(userm: userU),
                          ))
                    },
                  ),
                  ListTile(
                    tileColor: const Color.fromRGBO(156, 175, 136, 1.0),
                    leading: const Icon(LineAwesomeIcons.user_edit, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                    title: const Text('Settings',
                      style: TextStyle(
                          color: Color(0xFFFEFFEE),
                          fontSize: 15
                      ),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPage(userU: userU),
                          ))
                    },
                  ),
                  ListTile(
                    leading: const Icon(LineAwesomeIcons.alternate_long_arrow_left, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                    title: const Text('Logout',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                          fontSize: 15
                      ),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ))
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      appBar: AppBar(
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20), topRight: Radius.circular(20),
            )
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFEFFEE)),
        title: Image.asset(
          'assets/weplant_logo.png',
          height: 50,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(156, 175, 136, 1.0),
      ),
    body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 30,),
                SizedBox(
                  height: MediaQuery.of(context).size.height/6,
                  child: const FittedBox(
                    child: Icon(LineAwesomeIcons.user, color: Color.fromRGBO(156, 175, 136, 1.0),),
                  )
                ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Update your information!",style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(156, 175, 136, 1.0),
                  ),
                  textAlign: TextAlign.center,
                ),
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
                      makeInput(label: "Email", controller: email, validate: _validate, text: 'Email'),
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
                          email.text.isEmpty ? _validate = true : _validate = false;
                          pass.text.isEmpty ? _validatep = true : _validatep = false;
                          name.text.isEmpty ? _validaten = true : _validaten = false;
                        });
                        update();
                        },
                      color: const Color.fromRGBO(242, 212, 215, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: const Text("Update",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFFEFFEE)
                      ),),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
          //suffixIcon: const Icon(LineAwesomeIcons.eye),
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
        Text("Oops, something went wrong, try again!",
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
Widget _buildPopupDialogs(BuildContext context) {
  return AlertDialog(
    backgroundColor: const Color.fromRGBO(156, 175, 136, 1.0),
    title: const Text("Success",
      style: TextStyle(
        color: Color(0xFFFEFFEE),
      ),),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("Your data has been updated successfully",
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
Widget _buildPopupDialogn(BuildContext context) {
  return AlertDialog(
    backgroundColor: const Color.fromRGBO(156, 175, 136, 1.0),
    title: const Text("Warning",
      style: TextStyle(
        color: Color(0xFFFEFFEE),
      ),),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("You didn't change anything! Change something before updating",
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