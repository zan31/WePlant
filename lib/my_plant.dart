import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:we_plant/entities/plant.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:we_plant/detail_plant.dart';
import 'package:we_plant/entities/user.dart';
import 'package:we_plant/user_settings.dart';
import 'list.dart';
import 'main.dart';
import 'dart:math' as math;

class myPlantsPage extends StatefulWidget {
  final User userm;
  const myPlantsPage({Key? key, required this.userm}) : super(key: key);
  @override
  State<myPlantsPage> createState() => _myPlantsPageState();
}

class _myPlantsPageState extends State<myPlantsPage> {
  late User userm;
  final List<Plant> _allMyPlants = <Plant>[];

  @override
  void initState() {
    userm = widget.userm;
    fetchMyPlants().then((value) {
      setState(() {
        _allMyPlants.addAll(value);
      });
    });
    super.initState();
  }

  Future fetchMyPlants() async {
    var url = 'https://weplant.zanhrastnik.com/myplants.php';
    var response = await http.post(Uri.parse(url), body: {
      "id": userm.uId.toString(),
    });

    var myPlants = <Plant>[];

    if (response.statusCode == 200) {
      var plantsJson = jsonDecode(response.body);
      for (var plantJson in plantsJson) {
        myPlants.add(Plant.fromJson(plantJson));
      }
    }
    return myPlants;
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
                          builder: (context) => ListPage(user: userm,),
                        ))
                  },
                ),
                ListTile(
                  tileColor: const Color.fromRGBO(156, 175, 136, 1.0),
                  leading: const Icon(LineAwesomeIcons.leaf, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                  title: const Text('My plants',
                    style: TextStyle(
                        color: Color(0xFFFEFFEE),
                        fontSize: 15
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => myPlantsPage(userm: userm,),
                        ))
                  },
                ),
                ListTile(
                  leading: const Icon(LineAwesomeIcons.user_edit, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                  title: const Text('Settings',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                        fontSize: 15
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPage(userU: userm),
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Transform.rotate(
              angle: 270 * math.pi / 180,
              child: const Icon(
                  LineAwesomeIcons.search,
                  color: Color(0xFFFEFFEE)
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromRGBO(156, 175, 136, 1.0),
      ),


      body: Column(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height/8,
                child: const FittedBox(
                  child: Icon(LineAwesomeIcons.leaf, color: Color.fromRGBO(156, 175, 136, 1.0),),
                )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("These are all of your liked plants!",style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(156, 175, 136, 1.0),
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,)
              ],
            ),
            Expanded(
              child: Padding(
                  child: _allMyPlants.isEmpty ? const Center(child: Text(
                    'You currently have 0 liked plants!',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(0, 0, 0, 0.65)
                    ),
                  )) : ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                          color: const Color.fromRGBO(254, 255, 238, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Color.fromRGBO(230, 227, 211, 1.0), width: 1)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left:6.0, right: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      _allMyPlants[index].pImage,
                                      width: 60,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  trailing: const Icon(
                                    LineAwesomeIcons.angle_right,
                                  ),
                                  title: Text(
                                    _allMyPlants[index].pName,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(
                                            0, 0, 0, 0.67059)
                                    ),
                                  ),
                                  subtitle: Text(
                                    _allMyPlants[index].pLatinName,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(
                                            0, 0, 0, 0.49411)
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => DetailPage(plant: _allMyPlants[index], user: userm,)));
                                  },
                                ),
                              ],
                            ),
                          ));
                    },
                    itemCount: _allMyPlants.length,
                  ),
                  padding: const EdgeInsets.only(top:4.0)
              ),)
          ]),
    );
  }
}