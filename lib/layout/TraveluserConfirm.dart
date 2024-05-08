import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/admin_api.dart';

class DynamicTable extends StatefulWidget {
  const DynamicTable({super.key});

  @override
  _DynamicTableState createState() => _DynamicTableState();
}

class _DynamicTableState extends State<DynamicTable> {
  List<Map<String, dynamic>> _userData = []; // 데이터베이스에서 가져온 사용자 데이터

  @override
  void initState() {
    super.initState();
    // 비동기적으로 데이터를 가져오는 시뮬레이션 (예: 네트워크 요청 등)
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    try {
      var response = await http.post(Uri.parse(AdminApi.travelconfirm));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          // 'data' 필드가 null인지 확인 후 데이터 추출
          List<dynamic>? userDataList = responseBody['travel_list'];

          if (userDataList != null) {
            _userData = userDataList.map((userData) {
              return {
                'email': userData['travel_email'],
                'phone': userData['travel_tel'],
                'name': userData['travel_name'],
                'status': userData['travel_status'],
              };
            }).toList();

            setState(() {
              // 화면 업데이트
            });
          } else {
            throw "User data is null"; // 데이터가 null일 경우 처리
          }
        } else {
          throw "Failed to fetch user data"; // 요청이 실패하면 예외 발생
        }
      } else {
        throw "Failed to load user data: ${response.statusCode}";
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return _userData.isEmpty
        ? const Center(
            child: CircularProgressIndicator()) // 데이터가 로드될 때까지 로딩 스피너 표시
        : SingleChildScrollView(
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(
                      color: Colors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        '이름',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      color: Colors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        '전화번호',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      color: Colors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        '이메일',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                  Container(
                      color: Colors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        '승인 / 거절',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                ]),
                ..._userData.map((user) => TableRow(children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user['name'])),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user['phone'])),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user['email'])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              '승인',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                '거절',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      )
                    ])),
              ],
            ),
          );
  }
}
