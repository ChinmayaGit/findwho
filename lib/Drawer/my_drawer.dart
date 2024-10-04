import "package:findwho/Pages/Exit/exit.dart";
import "package:findwho/Pages/Lobby/components/lobby_components.dart";
import "package:findwho/Pages/Result/Result.dart";
import "package:findwho/components/controller/zone_game_contoller.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:get/get.dart';

final ZoneGameController _zoneGameController = Get.put(ZoneGameController());

myDrawer({context,required bool outside}) {
  return SafeArea(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        outside==false?DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            children: [
              Text(
                "Player ${_zoneGameController.zoneGameDoc.value?.playerTurn.toString()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Invite Code: "),
              ),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: invitationCode))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to your clipboard !'),
                      ),
                    );
                  });
                },
                child: Text(invitationCode),
              ),
            ],
          ),
        ):Container(),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () {
            // Handle the action here
          },
        ),
        outside==false? ListTile(
          leading: const Icon(Icons.scoreboard_outlined),
          title: const Text('Result'),
          onTap: () {
            Get.to(Result());
          },
        ):Container(),
        ListTile(
          leading: const Icon(Icons.settings_applications_outlined),
          title: const Text('Settings'),
          onTap: () {
            // Handle the action here
          },
        ),
        Spacer(),
        ListTile(
          leading: const Icon(Icons.exit_to_app_sharp),
          title: const Text('Exit'),
          onTap: () {
            Get.to(Exit(last: false,));
          },
        ),
      ],
    ),
  );
}