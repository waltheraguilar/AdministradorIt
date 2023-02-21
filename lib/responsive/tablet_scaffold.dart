import 'package:flutter/material.dart';
import 'package:itadministrador/constants.dart';
import 'package:itadministrador/utilities/my_tile.dart';

import '../utilities/my_box.dart';
class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:myAppBar,
      backgroundColor: myDefaultBackground,
      drawer: myDrawer,
      body: Column(
      children: [
        AspectRatio(
          aspectRatio: 4,
          child: SizedBox(
            width: double.infinity,
            child: GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index){
                return const MyBox();
              },
            ),
          ),
        ),


        Expanded(
          child: ListView.builder(
            itemCount: 5, 
            itemBuilder:(context, index){
          return const MyTile();
        }, 
        ),
        ),


      ],
     ),
    );
  }
}