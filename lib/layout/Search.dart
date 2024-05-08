import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_name_api.dart';
import 'hotel_select.dart';
import 'package:http/http.dart' as http;

class searchBar extends StatefulWidget {
  const searchBar({super.key});

  @override
  State<searchBar> createState() => _searchBarState();
}

var queryController = TextEditingController();
List<dynamic> hotelName = [];
String status = '';
bool? success;

class _searchBarState extends State<searchBar> {
  Future<void> querySearch(String query) async {
    try {
      var response = await http
          .get(Uri.parse('${HotelNameApi.hotelName}?hotel_name=$query'));
      print('기달');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        success = jsonData['success'];
        hotelName = jsonDecode(response.body)['hotel_list'];
        print(hotelName);

        if (success = true) {
          setState(() {
            hotelName = jsonDecode(response.body)['hotel_list'];
          });
        }
      } else {
        print('실패');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          child: TextFormField(
            onFieldSubmitted: (value) {
              querySearch(queryController.text.trim());
            },
            controller: queryController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '호텔을 검색하세요.',
                suffixIcon: IconButton(
                    onPressed: () {
                      String query = queryController.text;
                      if (query.isNotEmpty) {
                        querySearch(query);
                      }
                    },
                    icon: const Icon(Icons.search))),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: hotelName.length,
          itemBuilder: (context, index) {
            if (hotelName.isEmpty) {
              return const Card(
                child: ListTile(
                  title: Text(
                    "검색된 결과가 존재하지 않습니다.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (success == true) {
              return Card(
                child: ListTile(
                  trailing: const Icon(Icons.arrow_right),
                  title: Text(
                    hotelName[index]['hotel_name'],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    hotelName[index]['hotel_address'],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => HotelSelect(
                                  hotelList: hotelName[index],
                                ))));
                  },
                ),
              );
            }
            return null;
          },
        ))
      ],
    );
  }
}
