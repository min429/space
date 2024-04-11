import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_account.dart';

Future<void> _sendGetRequest(String action) async {
  final String url = 'http://10.0.2.2:8080/$action';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      // 서버 응답에 대한 처리를 여기에 추가할 수 있습니다.
      // if (action == ""){
      //   //해당 로직 실행
      // }

    } else {
      print('Error: ${response.statusCode}');
      // 에러 처리를 여기에 추가할 수 있습니다.
      // if (response.statusCode == ) {
      //   //해당 로직 실행
      // }
    }
  } catch (e) {
    print('Exception: $e');
    // 예외 처리를 여기에 추가할 수 있습니다.
  }
}



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

      // if (action == ""){
      //   //해당 로직 실행
      // }
    } else {
      print('Error: ${response.statusCode}');
      // 에러 처리를 여기에 추가할 수 있습니다.

      // if (response.statusCode == ) {
      //   //해당 로직 실행
      // }
    }
  } catch (e) {
    print('Exception: $e');
    // 예외 처리를 여기에 추가할 수 있습니다.
  }

}



class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('seat/reserve', requestData: {
                  'userId': 0,
                  'seatId': 456,
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Reserve'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('seat/return', requestData: {
                  'userId': 0,
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Return'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('user/login', requestData: {
                  'email': 'test01@google.com',
                  'password': 'pass123',
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('user/signup', requestData: {
                  'email': 'test01@google.com',
                  'password': 'pass123',
                  'name': 'test',
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Sign UP'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('user/signout', requestData: {
                  'userId': 0,
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Sign Out'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('board/create', requestData: {
                  'userId': 0,
                  'content': '도서관 게시판 테스트',
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });

              },
              child: Text('Board Create'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('board/update', requestData: {
                  'boardId': 152,
                  'userId': 0,
                  'content': '도서관 게시판 테스트 수정',
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Board Update'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendPostRequest('board/delete', requestData: {
                  'boardId': 152,
                  'userId': 2,
                }).then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                });
              },
              child: Text('Board Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendGetRequest('board/getAll').then((response) {
                  // 성공적으로 요청이 완료된 후에 수행할 작업 정의
                  // 예: 회원 가입 성공 시 다음 화면으로 이동 등
                }); // GET 요청 보내기
              },
              child: Text('Get All Boards'), // 버튼 텍스트
            ),

          ],
        ),
      ),
    );
  }
}