import 'package:flutter/material.dart';

class Solution extends StatelessWidget {
  const Solution({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Founded"),),
      body: Column(children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("assets/person/Mister Black.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )
      ],),
    );
  }
}
