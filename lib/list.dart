import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:we_plant/my_plant.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:we_plant/entities/plant.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:we_plant/detail_plant.dart';
import 'package:we_plant/entities/user.dart';
import 'package:we_plant/user_settings.dart';

import 'main.dart';

class ListPage extends StatefulWidget {
  final User user;
  const ListPage({Key? key, required this.user}) : super(key: key);
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late User user;
  String dropdownValue = 'All';
  List<Plant> _plants = <Plant>[];

  final List<Plant> _allPlants = <Plant>[];

  @override
  void initState() {
    user = widget.user;
    fetchPlants().then((value) {
      setState(() {
        _allPlants.addAll(value);
      });
    });
    dropdownValue;
    super.initState();
  }

  Future fetchPlants() async {
    var url = 'https://weplant.zanhrastnik.com/plants/';
    var response = await http.post(Uri.parse(url), body: {
      "id": user.uId.toString(),
    });

    var plants = <Plant>[];

    if (response.statusCode == 200) {
      var plantsJson = jsonDecode(response.body);
      for (var plantJson in plantsJson) {
        plants.add(Plant.fromJson(plantJson));
      }
    }
    return plants;
  }

  @override
  Widget build(BuildContext context) {
    if(dropdownValue=='All'){
      _plants = _allPlants.toList();
    }
    else if(dropdownValue!='All'){
      _plants = _allPlants.where((element) => element.pType==dropdownValue).toList();
    }

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
                  tileColor: const Color.fromRGBO(156, 175, 136, 1.0),
                  leading: const Icon(LineAwesomeIcons.home, color: Color.fromRGBO(242, 212, 215, 1.0), size: 35,),
                  title: const Text('Home',
                    style: TextStyle(
                        color: Color(0xFFFEFFEE),
                        fontSize: 15
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPage(user: user,),
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
                          builder: (context) => myPlantsPage(userm: user),
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
                          builder: (context) => UserPage(userU: user),
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
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              width: MediaQuery. of(context). size. width/2,
              child: DropdownButtonFormField<String>(
              dropdownColor: const Color.fromRGBO(242, 212, 215, 1.0),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(242, 212, 215, 1.0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(242, 212, 215, 1.0)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(242, 212, 215, 1.0)),
                ),
                prefixIcon: Icon(LineAwesomeIcons.filter, color: Color.fromRGBO(242, 212, 215, 1.0), size: 25,),
              ),
                icon: const Icon(LineAwesomeIcons.caret_down, color: Color.fromRGBO(242, 212, 215, 1.0),),
                isExpanded: true,
                hint: const Text(
                  'Choose a type!',
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.65)
                ),
              ),
              items: <String>['All', 'Herbs', 'Climbers', 'Trees'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                      value,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.65)
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  _plants.clear();
                });
              },
            ),
            ),
            Expanded(
              child: Padding(
                child: _plants.isEmpty ? const Center(child: Text(
                  'Sorry, there are currently 0 plants with the picked type!',
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
                                    _plants[index].pImage,
                                    width: 60,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                trailing: const Icon(
                                  LineAwesomeIcons.angle_right,
                                ),
                                title: Text(
                                  _plants[index].pName,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.67059)
                                  ),
                                ),
                                subtitle: Text(
                                  _plants[index].pLatinName,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.49411)
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => DetailPage(plant: _plants[index], user: user,)));
                                },
                              ),
                            ],
                          ),
                        ));
                    },
                  itemCount: _plants.length,
                ),
                padding: const EdgeInsets.only(top:4.0)
              ),)
          ]),
    );
  }
}
