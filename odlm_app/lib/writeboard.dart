import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:odlm_app/globals.dart';



class WriteBoardWidget extends StatefulWidget {
  const WriteBoardWidget({Key? key}) : super(key: key);

  @override
  _WriteBoardWidgetState createState() => _WriteBoardWidgetState();
}

class _WriteBoardWidgetState extends State<WriteBoardWidget> {
  String userInput = ''; // 입력된 텍스트를 저장할 변수

  Future<void> _sendPostRequest(String action,
      {required Map<String, dynamic> requestData}) async {
    final String url = 'http://10.0.2.2:8080/$action';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
        // 서버 응답에 대한 처리를 여기에 추가할 수 있습니다.
        Navigator.of(context).pop();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      // 예외 처리를 여기에 추가할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기', style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        centerTitle: true, // 가운데 정렬

        leading: IconButton(
          icon: Icon(Icons.done, color: Colors.white), // '완료' 아이콘
          onPressed: () {
            // 완료 버튼을 눌렀을 때 수행할 동작
            if (userInput != '') {
              _sendPostRequest('board/create',
                  requestData: {
                    'userId': userId,
                    'content': userInput, // 입력된 텍스트 전송
                  }
              );
            }
            else{
              Navigator.of(context).pop();
            }
          },
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '취소',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '내용을 입력하세요.', // 힌트 메시지 설정
                    hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트의 색상 설정
                  ),
                  keyboardType: TextInputType.multiline, // 여러 줄 입력 가능하도록 설정
                  maxLines: null, // 최대 줄 수 설정 (null로 설정하면 자동으로 늘어남)
                  textInputAction: TextInputAction.done, // 입력 완료 버튼을 사용하여 줄 바꿈 방지
                  onChanged: (value) {
                    // 입력된 텍스트를 변수에 저장
                    setState(() {
                      userInput = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
