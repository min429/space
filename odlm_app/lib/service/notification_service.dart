import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initFirebaseMessaging() async {
    // 기기 등록 ID 토큰을 요청합니다.
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // 토큰 갱신 리스너를 설정합니다.
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      // 여기에서 서버에 토큰을 업데이트하는 로직을 추가할 수 있습니다.
    });

    // 추가적으로, iOS의 경우 알림 권한을 요청합니다.
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }
}
