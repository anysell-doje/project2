import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/travel_ReservationDetail.dart';
import 'package:http/http.dart' as http;

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List<Map<String, dynamic>> _userData = []; // 데이터베이스에서 가져온 사용자 데이터
  var reservation_id = "";

  bool isLoading = true; // 데이터 로딩 상태
  bool hasData = false; // 데이터 유무

  @override
  void initState() {
    super.initState();
    // 비동기적으로 데이터를 가져오는 시뮬레이션 (예: 네트워크 요청 등)
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    try {
      var response = await http.post(Uri.parse(TravelApi.resvSelect), body: {
        'travel_reservation_status': "0",
        'hotel_reservation_status': "0"
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          List<dynamic>? userDataList = responseBody['resv_list'];

          setState(() {
            _userData = userDataList!.map((userData) {
              return {
                'reservation_id': userData['reservation_id'].toString(),
                'inquirer_name': userData['inquirer_name'],
                'check_out_date': userData['check_out_date'],
                "travel_reservation_status":
                    userData['travel_reservation_status'],
                "hotel_reservation_status":
                    userData['hotel_reservation_status'],
                "room_count": userData['room_count'].toString(),
                "night_count": userData['night_count'].toString(),
                "hotel_id": userData['hotel_id'].toString(),
                "hotel_price": userData['hotel_price'].toString(),
                "guest_count": userData['guest_count'].toString(),
                "inquirer_tel": userData['inquirer_tel'],
                "check_in_date": userData['check_in_date'],
                "hotel_name": userData['hotel_name'],
              };
            }).toList();

            _fetchUserDataFromApi();
          });
        } else {
          throw "Failed to fetch user data";
        }
      } else {
        throw "Failed to load user data: ${response.statusCode}";
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> resvCancel() async {
    try {
      var response =
          await http.post(Uri.parse(TravelApi.resvcancelUpdate), body: {
        'reservation_id': reservation_id,
      });

      if (response.statusCode == 200) {
        _fetchUserDataFromApi();
      }
    } catch (e) {
      print("Error canceling reservation: $e");
    }
  }

  Future<void> _cancleConfirm() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약을 취소하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(fontFamily: 'Pretendard', color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                resvCancel();
              },
            ),
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void viewDetail(Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationDetail(ReserverInfo: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userData.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  const Divider(height: 10), // 각 항목 사이의 간격을 지정
              itemCount: _userData.length,
              itemBuilder: (context, index) {
                var user = _userData[index];
                return ListTile(
                  title: Text(
                    user['inquirer_name'].toString(),
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    user['hotel_name'].toString(),
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          print(user);
                          viewDetail(user);
                        },
                        child: const Text(
                          'Details',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            reservation_id = user['reservation_id'];
                          });
                          _cancleConfirm();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
