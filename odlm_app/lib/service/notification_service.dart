import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _sendPostRequest(String action, {required Map<String, dynamic> requestData}) async {
    final String url = 'http://172.20.10.9:8080/$action';
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
        if (action == "fcm/register") {
          //해당 로직 실행
          print(response.body);
        }
      } else {
        print('Error: ${response.statusCode}');
        // 에러 처리를 여기에 추가할 수 있습니다.
      }
    } catch (e) {
      print('Exception: $e');
      // 예외 처리를 여기에 추가할 수 있습니다.
    }
  }

  Future<void> initFirebaseMessaging() async {
    // 기기 등록 ID 토큰을 요청합니다.
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    _sendPostRequest('fcm/register', requestData: {
      'userId': userId,
      'token': token,
    });

    // 토큰 갱신 리스너를 설정합니다.
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      // 여기에서 서버에 토큰을 업데이트하는 로직을 추가할 수 있습니다.
      _sendPostRequest('fcm/register', requestData: {
        'userId': userId,
        'token': newToken,
      });
    });
  }
}
