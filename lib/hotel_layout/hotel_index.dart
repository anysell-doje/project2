import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_MyPage.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_confirmList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_CancelList.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_ReservationList.dart';

class hotel_index extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String pw;
  const hotel_index(
      {required this.email,
      required this.name,
      required this.tel,
      required this.pw,
      super.key});

  @override
  createState() => _MainViewState(email, name, tel, pw);
}

class _MainViewState extends State<hotel_index> {
  String name;
  String email;
  String tel;
  String pw;
  late List<Widget> views;

  _MainViewState(this.email, this.name, this.tel, this.pw);

  @override
  void initState() {
    super.initState();
    views = [
      const Center(),
      const ReservationList(),
      const ReservationConfirmList(),
      const CancelList(),
      hotel_MyPage(email: email, name: name, tel: tel, pw: pw)
    ];
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AnyStay',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CantoraOne',
          ),
        ),
        shape: Border(
          bottom: BorderSide(width: 3, color: Colors.grey.shade200),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Sidebar(),
    );
  }

  Row Sidebar() {
    return Row(
      children: [
        Container(
          color: Colors.grey[200],
          child: SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: '메인화면',
              ),
              SideNavigationBarItem(
                icon: Icons.search_outlined,
                label: '예약확인대기 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.chat,
                label: '지불대기 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.auto_graph_outlined,
                label: '취소 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.auto_graph_outlined,
                label: '통계',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: '마이페이지',
              ),
            ],
            theme: SideNavigationBarTheme(
              itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black26,
                  iconSize: 32.5,
                  labelTextStyle:
                      const TextStyle(fontSize: 15, color: Colors.black)),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
            onTap: (index) {
              setState(() {
                if (index >= 0 && index < views.length) {
                  // views의 길이에 맞게 범위를 확인합니다.
                  selectedIndex = index;
                }
              });
            },
            toggler: SideBarToggler(
                expandIcon: Icons.keyboard_arrow_right,
                shrinkIcon: Icons.keyboard_arrow_left,
                onToggle: () {}),
          ),
        ),
        Expanded(
          child: views.elementAt(selectedIndex),
        )
      ],
    );
  }
}
