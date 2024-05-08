import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/travel_ReservationDetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/admin_api.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List<Map<String, dynamic>> _userData = []; // 데이터베이스에서 가져온 사용자 데이터
  List<dynamic> userData = [];
  var reservation_id = "";
  int? reserverNum;

  @override
  void initState() {
    super.initState();
    // 비동기적으로 데이터를 가져오는 시뮬레이션 (예: 네트워크 요청 등)
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    try {
      var response = await http.post(Uri.parse(AdminApi.resvlist));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          // 'data' 필드가 null인지 확인 후 데이터 추출
          List<dynamic>? userDataList = responseBody['resv_list'];

          if (userDataList != null) {
            _userData = userDataList.map((userData) {
              return {
                'reservation_id': userData['reservation_id'].toString(),
                'inquirer_name': userData['inquirer_name'],
                'check_out_date': userData['check_out_date'],
                "reservation_status": userData['reservation_status'],
                "room_count": userData['room_count'].toString(),
                "hotel_id": userData['hotel_id'].toString(),
                "hotel_price": userData['hotel_price'].toString(),
                "guest_count": userData['guest_count'].toString(),
                "inquirer_tel": userData['inquirer_tel'],
                "check_in_date": userData['check_in_date'],
                "hotel_name": userData['hotel_name'],
              };
            }).toList();

            setState(() {
              // 화면 업데이트
              userData = userDataList;
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

  Future<void> _resvCancel(int reserverNum) async {
    try {
      var response = await http.post(Uri.parse(TravelApi.cancelUpdate), body: {
        'reservation_id': reservation_id,
      });

      if (response.statusCode == 200) {
        setState(() {
          _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _cancel(reserverNum) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('취소하시겠습니까?'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _resvCancel(int.parse(reserverNum.toString()));
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  viewDetail(Map<String, dynamic> userData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReservationDetail(
                  ReserverInfo: userData,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return _userData.isEmpty
        ? const Center(
            child: CircularProgressIndicator()) // 데이터가 로드될 때까지 로딩 스피너 표시
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '예약번호',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '이름',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '전화번호',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '호텔',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '상세정보',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ]),
                      ..._userData.map((user) => TableRow(children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user['reservation_id'],
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user['inquirer_name'],
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user['inquirer_tel'],
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user['hotel_name'],
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    viewDetail(userData[
                                        int.parse(user['reservation_id']) - 1]);
                                  },
                                  child: const Text(
                                    '상세정보',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Pretendard'),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      reservation_id = userData[int.parse(
                                                  user['reservation_id']) -
                                              1]['reservation_id']
                                          .toString();
                                    });
                                    _cancel(userData[
                                            int.parse(user['reservation_id']) -
                                                1]['reservation_id']
                                        .toString());
                                  },
                                  child: const Text(
                                    '예약취소',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Pretendard'),
                                  ),
                                ),
                              ],
                            )
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
