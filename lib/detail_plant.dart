import 'entities/plant.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'entities/user.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final Plant plant;
  final User user;

  const DetailPage({Key? key, required this.plant, required this.user}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  late Plant plant;
  late User user;
  late bool fav;

  Future favourite() async {
    var url = 'https://weplant.zanhrastnik.com/favourite.php';
    var response = await http.post(Uri.parse(url), body: {
      "userid": user.uId.toString(),
      "plantid": plant.plantId.toString(),
      "fav": fav.toString()
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data == "Error") {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context),
        );
      }
      else if (data == "Delete") {
        setState(() {
          fav = false;
        });
      }
      else if (data == "Insert") {
        setState(() {
          fav = true;
        });
      }
    }
  }

  @override
  void initState() {
    user = widget.user;
    plant = widget.plant;
    fav = plant.pFavourite;
    super.initState();
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(242, 212, 215, 1.0),
      title: const Text('Error',
        style: TextStyle(
            color: Color(0xFFFEFFEE)
        ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Something went wrong, please try again later!",
            style: TextStyle(
                color: Color(0xFFFEFFEE)
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
            ),),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final plantType = Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(242, 212, 215, 1.0)),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        plant.pType,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color.fromRGBO(242, 212, 215, 1.0)),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 50.0),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(plant.pImage)),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          plant.pName,
          style: const TextStyle(color: Color.fromRGBO(254, 255, 238, 1.0), fontSize: 45.0),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      plant.pLatinName,
                      style: const TextStyle(color: Color.fromRGBO(254, 255, 238, 1.0), fontSize: 20),
                    ))),
            Expanded(flex: 2, child: plantType)
          ],
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.7,
            ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Color.fromRGBO(
              156, 175, 136, 1.0)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 6.0,
          top: 65.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(LineAwesomeIcons.angle_left, color: Color.fromRGBO(254, 255, 238, 1.0), size: 30),
          ),
        ),
        Positioned(
          right: 6.0,
          top: 65.0,
          child: InkWell(
            onTap: () {
              favourite();
            },
            child: Icon(
              fav
                ? LineAwesomeIcons.heart_1
                : LineAwesomeIcons.heart,
                color: const Color.fromRGBO(254, 255, 238, 1.0),
                size: 30),
          ),
        )
      ],
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(40.0),
      child: Text(
          plant.pDescription,
          style: const TextStyle(
            fontSize: 18.0,
            color: Color.fromRGBO(0, 0, 0, 0.65)
          ),
        textAlign: TextAlign.justify,
        ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[topContent, bottomContent],
      ),
      ),
    );
  }
}
