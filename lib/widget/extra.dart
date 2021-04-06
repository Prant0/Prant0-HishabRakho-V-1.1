import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/my_friends.dart';
import 'package:anthishabrakho/screen/profile/my_profile.dart';
import 'package:anthishabrakho/screen/tabs/myStorageHubs.dart';
import 'package:anthishabrakho/screen/tabs/myTransection.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Extra extends StatefulWidget {
  @override
  _ExtraState createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MyStorageHubs(),
    MyTransection(),
  ];

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _currentSelected = 0;
  void _onItemTapped(int index) {
    index == 3
        ? _drawerKey.currentState.openDrawer()
        : setState(() {
      _currentSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentSelected==0? "pranto" :"Mucking"),
        leading: IconButton(

          icon: Icon(Icons.anchor),
          onPressed: (){

            _drawerKey.currentState.openDrawer();
          },
        ),
      ),
      key: _drawerKey,
      body: _widgetOptions.elementAt(_currentSelected),
      drawer: Drawerr(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _currentSelected,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[800],
        selectedItemColor: Color.fromRGBO(10, 135, 255, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Page 1'),
            icon: Icon(Icons.access_alarm),
          ),
          BottomNavigationBarItem(
            title: Text('Page 2'),
            icon: Icon(Icons.accessible),
          ),
          BottomNavigationBarItem(
            title: Text('Page 3'),
            icon: Icon(Icons.adb),
          ),
          BottomNavigationBarItem(

            title: Text('Drawer'),
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}