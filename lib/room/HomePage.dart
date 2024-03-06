import 'package:findwho/database/Global.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/database/roomGlobal.dart';
import 'package:findwho/room/ListPage.dart';
import 'package:findwho/player/solution.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  late int selectedIndex = 0;
  //todo get map
  // List<AssetInfo> selectNow = listRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu),
        //TODO here only player one selected
        title: Text(authQuerySnapshot.data()!["userName"]),
        centerTitle: true,
        actions: <Widget>[

          GestureDetector(
            onTap: () {
              //todo call if needed
              // getAndDistributeOffline(listRoom, listWeapon, listPerson, 2);
              // globalState=true;
            },
            child: Container(
              color: Colors.purple,
              width: 100,
              child: Center(child: Text("Test")),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(const Solution());
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 36,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text("0")),
              ),
            ),
          )
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //
      //   },
      //   tooltip: 'Increment',
      //   child:const Icon(Icons.arrow_upward_sharp),
      // ),
      bottomNavigationBar: GFTabBar(
        tabBarHeight: 75,
        tabBarColor: Colors.black,
        length: 3,
        controller: tabController,
        tabs:const [
          Tab(
            icon: Icon(Icons.image),
            child: Text("Tab1"),
          ),
          Tab(
            icon: Icon(Icons.picture_as_pdf),
            child: Text("Tab2"),
          ),
          Tab(
            icon: Icon(Icons.directions_railway),
            child: Text("Tab3"),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
       children: [
         TabBarView(
           controller: tabController,
           children: <Widget>[
             //todo get map
             // GridContent(listRoom),
             // GridContent(listWeapon),
             // GridContent(listPerson),
           ],
         ),
//          Row(
//            children: [
//              GestureDetector(
//                onTap: (){
//                  showModalBottomSheet(
//                      context: context,
//                      shape: const RoundedRectangleBorder(
//                        borderRadius: BorderRadius.only(
//                          // <-- SEE HERE
//                          topLeft: Radius.circular(30.0),
//                          topRight: Radius.circular(30.0),
//                        ),
//                      ),
//                      builder: (context) {
//                        return SizedBox(
//                          height: 320,
//                          child: GridView.count(
//                            crossAxisCount: 4,
//                            crossAxisSpacing: 6,
//                            mainAxisSpacing: 6,
//
//                            children: selectNow
//                                .map((assetInfo) => Card(
//                                color: Colors.transparent,
//                                elevation: 0,
//                                child: Container(
//                                  decoration: ShapeDecoration(
//                                      shape: RoundedRectangleBorder(
//                                        borderRadius: BorderRadius.circular(25.0),
//                                      ),
//                                      color: Colors.black),
//                                  child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: [
//                                      Container(
//                                        height: 50,
//                                        width: 50,
//                                        decoration: BoxDecoration(
//                                          borderRadius: BorderRadius.circular(20),
//                                          image: DecorationImage(
//                                            image: AssetImage(assetInfo.img),
//                                            fit: BoxFit.cover,
//                                          ),
//                                        ),
//                                      ),
//                                      Text(
//                                        assetInfo.name,
//                                        style: const TextStyle(
//                                          color: Colors.white,
//                                          fontWeight: FontWeight.bold,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                )))
//                                .toList(),
//                          ),
//                        );
//                      });
//                },
//                child: Container(
//                  decoration: const ShapeDecoration(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.only(
//                        topRight: Radius.circular(20.0),
//                      ),
//                    ),
//                    color: Colors.black,
//                  ),
//                  height: 60,
//                  width: 60,
//                  child:const Icon(Icons.upload_sharp,color: Colors.white,),
//                ),
//              ),
// const Spacer(),
//              Container(
//                decoration: const ShapeDecoration(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(20.0),
//                    ),
//                  ),
//                  color: Colors.black,
//                ),
//                height: 60,
//                width: 60,
//                child:const Icon(Icons.next_plan,color: Colors.white,),
//              ),
//            ],
//          ),
       ],
      ),
    );
  }
}

class GridContent extends StatelessWidget {
  final List<AssetInfo> objects;

  const GridContent(this.objects, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: objects
          .map((assetInfo) => GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            child: Text(
                              assetInfo.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(assetInfo.img))),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    //todo room solution
                                   //  if(assetInfo.name==solution['room'])
                                   // {
                                   //
                                   // }else{
                                   //
                                   //  }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Colors.green),
                                    height: 60,
                                    child: const Center(
                                        child: Text(
                                      "Select",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Colors.red),
                                    height: 60,
                                    child: const Center(
                                        child: Text(
                                      "Reject",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(assetInfo.img),
                            fit: BoxFit.cover,
                            colorFilter: assetInfo.state == true
                                ? ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.bookmark_border,
                            size: 15,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Text(
                            assetInfo.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
