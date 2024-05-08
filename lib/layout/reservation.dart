import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/hotel_reservation.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key, required this.hotelList});
  final List<Map<String, dynamic>> hotelList;

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  var userNameController = TextEditingController();
  var userPhoneController = TextEditingController();
  var guestCountController = TextEditingController();
  var nightCountController = TextEditingController();
  var hotelPriceController = TextEditingController();
  var roomCountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  var _nightCount = 0;
  bool resvConfirm = false;
  @override
  void initState() {
    super.initState();
    roomCountController.addListener(updatePrice);
    nightCountController.addListener(updatePrice);
  }

  void updatePrice() {
    int roomCount = int.tryParse(roomCountController.text) ?? 0;
    int basePrice = 0;
    String priceStr =
        widget.hotelList[0]['hotel_price'].toString().replaceAll(",", "");
    basePrice = int.tryParse(priceStr) ?? 0;

    int totalPrice;
    setState(() {
      totalPrice = basePrice * roomCount * _nightCount;
      hotelPriceController.text = totalPrice.toString();
    });
  }

  Future<void> selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now(),
        end: _endDate ?? DateTime.now().add(const Duration(days: 1)),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _nightCount = picked.end.difference(picked.start).inDays;
        updatePrice();
      });
    }
  }

  hotelReservation() async {
    try {
      print('yes');
      print('hotel_id : ${widget.hotelList[0]['hotel_id']}');
      print('inquirer_name : ${userNameController.text.trim()}');
      print('inquirer_tel : ${userPhoneController.text.trim()}');
      print('guest_count : ${guestCountController.text.trim()}');
      print('night_count : ${_nightCount.toString()}');
      print('room_count : ${roomCountController.text.trim()}');
      print('hotel_price : ${hotelPriceController.text.trim()}');
      print('check_in_date : ${_startDate.toString()}');
      print('check_out_date : ${_endDate.toString()}');
      var res = await http.post(
        Uri.parse(HotelReservation.reservation),
        body: {
          "hotel_id":
              widget.hotelList[0]['hotel_id'].toString(), // int를 String으로 변환
          "inquirer_name": userNameController.text.trim(),
          "inquirer_tel": userPhoneController.text.trim(),
          "guest_count": guestCountController.text.trim(),
          "night_count": _nightCount.toString(), // int를 String으로 변환
          "room_count": roomCountController.text.trim(),
          "hotel_price": hotelPriceController.text.trim(),
          "check_in_date": _startDate.toString(), // DateTime을 String으로 변환
          "check_out_date": _endDate.toString(), // DateTime을 String으로 변환
        },
      );

      if (res.statusCode == 200) {
        print('200');
        var resReservation = jsonDecode(res.body);
        reservationComplete();

        if (resReservation['success'] == true) {
          userNameController.clear();
          userPhoneController.clear();
          guestCountController.clear();
          nightCountController.clear();
          roomCountController.clear();
          hotelPriceController.clear();
          _startDate = null;
          _endDate = null;
          _nightCount = 0; // 선택한 날짜와 박수 초기화
        }
      }
    } catch (e) {
      print(e);
    }
  }

  reservationComplete() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('예약이 접수 되었습니다.', textAlign: TextAlign.center)));
    Navigator.pop(context);
  }

  reservationFiled() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('예약이 취소 되었습니다.', textAlign: TextAlign.center)));
  }

  @override
  Widget build(BuildContext context) {
    String hotelName = widget.hotelList[0]['hotel_name'];
    String hotelAddress = widget.hotelList[0]['hotel_address'];
    String hotelRating = widget.hotelList[0]['hotel_rating'].toString();
    String hotelPrice = widget.hotelList[0]['hotel_price'].toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hotelName,
          style: const TextStyle(
            fontFamily: 'Pretendard',
          ),
        ),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '이름',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '이름을 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '전화번호',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: userPhoneController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '전화번호를 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '인원수',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: guestCountController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '인원수를 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '객실수',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: roomCountController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '객실수를 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '날짜',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: selectDateRange,
                  child: AbsorbPointer(
                    child: SizedBox(
                      width: 270,
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _endDate != null
                              ? '${DateFormat('yyyy-MM-dd').format(_startDate!)} ~ ${DateFormat('yyyy-MM-dd').format(_endDate!)}'
                              : '',
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: '날짜 선택',
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '총가격',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: hotelPriceController,
                    readOnly: true,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: 270,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        hotelReservation();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
