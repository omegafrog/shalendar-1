import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../data/Calendar.dart';
import '../dialog/dialog.dart';
import '../provider/bottom_nav_provider.dart';
import '../provider/home_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BottomNavigationProvider _bottomNavigationProvider;
  late HomeProvider _homeProvider;
  late HomeState state;

  @override
  initState(){
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getCalendar();
  }

  @override
  Widget build(BuildContext context){
    _homeProvider = Provider.of<HomeProvider>(context);
    _bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);
    state = _homeProvider.state;


    return Scaffold(
        floatingActionButton: floatingButtons(),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                routeListWidget(),
              ],
            )));
  }

  Widget routeListWidget() {
    if (state == HomeState.loading) {
      return messageWidget("로딩중");
    } else if (state == HomeState.empty) {
      return messageWidget("캘린더가 존재하지 않습니다");
    } else {
      final calendarList = _homeProvider.calendarList;
      return Expanded(
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: calendarList.length,
              itemBuilder: (BuildContext context, index) =>
                  listCard(calendarList[index]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10)));
    }
  }

  Widget messageWidget(String message) => Container(
    height: 100,
    alignment: Alignment.center,
    child: Text(
      message,
      style: const TextStyle(fontSize: 30),
    ),
  );

  Widget listCard(Calendar calendar) => Container(
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
              onTap: () {
                // 네비게이터로 이동
              },
              child: Stack(fit: StackFit.expand, children: <Widget>[
/*                Image.asset(
                  route.image!,
                  fit: BoxFit.fill,
                ),*/
                /// 테마에 따른 색상
                Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(7),
                    child: Text("${calendar.calendarName!}  ",
                        style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              ]))));

  Widget? floatingButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: const Color.fromARGB(0xFF, 0xFB, 0x95, 0x32),
      children: [
        SpeedDialChild(
            child: const Icon(Icons.settings_sharp, color: Colors.white),
            label: "생성",
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 13.0),
            backgroundColor: const Color.fromARGB(0xFF, 0xFB, 0x95, 0x32),
            labelBackgroundColor: const Color.fromARGB(0xFF, 0xFB, 0x95, 0x32),
            onTap: () {
              dialog(context, 1);
            }),
        SpeedDialChild(
          child: const Icon(
            Icons.add_chart_rounded,
            color: Colors.white,
          ),
          label: "참가",
          backgroundColor: const Color.fromARGB(0xFF, 0xFB, 0x95, 0x32),
          labelBackgroundColor: const Color.fromARGB(0xFF, 0xFB, 0x95, 0x32),
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13.0),
          onTap: () {
            dialog(context, 2);
          },
        )
      ],
    );
  }
}
