import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'idfind',
      home: PasswordFind(),
    );
  }
}

class PasswordFind extends StatefulWidget {
  const PasswordFind({super.key});

  @override
  State<PasswordFind> createState() => PasswordFindState();
}

class PasswordFindState extends State<PasswordFind> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디 찾기'),
        elevation: 10,
      ),
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: '등록했던 계정을 입력하세요.',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: '이름을 입력하세요.',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                OtpTextField(
                  margin: const EdgeInsets.all(10),
                  numberOfFields: 6,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: false,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        });
                  }, // end onSubmit
                ),
                Title(
                    color: Colors.black,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 30, top: 10),
                      child: Text(
                        '코드를 입력하세요.',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '아이디 찾기',
                      style: TextStyle(fontSize: 22.0),
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
