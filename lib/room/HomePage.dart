import 'package:findwho/components/HomeComponents.dart';
import 'package:findwho/database/FetchData.dart';
import 'package:findwho/database/FetchZone.dart';
import 'package:findwho/room/GameClose.dart';
import 'package:findwho/room/Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int pageValue = 1;

  @override
  void initState() {
    super.initState();

    pageValue = 1;
    print(pageValue);
  }

  static const backImg = ["house.jpeg", "weapon.jpeg", "person.jpeg"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      key: _scaffoldKey,
      drawer: Drawer(
          child:myDrawer(context),
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            child: Image.asset(
              pageValue == 1
                  ? 'assets/background/${backImg[pageValue - 1]}'
                  : pageValue == 2
                      ? 'assets/background/${backImg[pageValue]}'
                      : 'assets/background/${backImg[pageValue + 1]}',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          topBar(_scaffoldKey),
          backGlassContainer(isLeft: true),
          backGlassContainer(isLeft: false),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: pageValue == 1
                ? GridContent(listRoom, 0)
                : pageValue == 2
                    ? GridContent(listWeapon, 1)
                    : GridContent(listPerson, 2),
          ),
          Padding(
            padding: EdgeInsets.only(top: Get.height / 1.2),
            child: pageValue == 1
                ? SwipeableCardDeck(playersCards: playersRoom)
                : pageValue == 2
                    ? SwipeableCardDeck(playersCards: playersWeapon)
                    : SwipeableCardDeck(playersCards: playersPerson),
          ),
        ],
      ),
    );
  }
}
