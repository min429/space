import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  Future<void> _sendRequest(String action,
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
      } else {
        print('Error: ${response.statusCode}');
        // 에러 처리를 여기에 추가할 수 있습니다.
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
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _sendRequest('seat/reserve', requestData: {
                  'userId': 123,
                  'seatId': 456,
                });
              },
              child: Text('Reserve'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendRequest('seat/return', requestData: {
                  'userId': 123,
                });
              },
              child: Text('Return'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendRequest('user/login', requestData: {
                  'email': 'test01@google.com',
                  'password': 'pass123',
                });
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendRequest('user/signup', requestData: {
                  'email': 'test01@google.com',
                  'password': 'pass123',
                  'name': 'test',
                });
              },
              child: Text('Sign UP'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendRequest('user/signout', requestData: {
                  'email': 'test@google.com',
                });
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}