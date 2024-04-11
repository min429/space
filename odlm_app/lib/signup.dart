import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'second_page.dart';


class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}



class _SignUpWidgetState extends State<SignUpWidget> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late bool _passwordVisible;
  late bool _confirmPasswordVisible;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //이메일 검증 함수
  bool _validateEmail(String email) {
    // 이메일 형식 검증을 위한 정규 표현식
    final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
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
        if (action == "user/signup"){
          Navigator.pop(context); // 로그인 페이지로 이동
        }
      } else {
        print('Error: ${response.statusCode}');

        if (response.statusCode == 500) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("중복 회원가입"),
                content: Text("회원이 이미 존재합니다."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                    },
                    child: Text("확인"),
                  ),
                ],
              );
            },
          );
        }
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
        title: Text(
          '회원가입',
          style: TextStyle(
            color: Colors.blue, // 텍스트 색상 변경
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue, // 아이콘 색상 변경
          ),
          onPressed: () {
            // 뒤로가기 버튼 클릭 시 수행할 동작
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blue), // 레이블 텍스트 색상 변경
                  border: OutlineInputBorder( // 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red), // 외곽선 색상 변경
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green), // 포커스되었을 때 외곽선 색상 변경
                  ),
                  hintText: '이메일을 입력하세요', // 힌트 텍스트 변경
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  labelStyle: TextStyle(color: Colors.blue), // 레이블 텍스트 색상 변경
                  border: OutlineInputBorder( // 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red), // 외곽선 색상 변경
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green), // 포커스되었을 때 외곽선 색상 변경
                  ),
                  hintText: '이름을 입력하세요', // 힌트 텍스트 변경
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: TextStyle(color: Colors.blue), // 레이블 텍스트 색상 변경
                  border: OutlineInputBorder( // 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red), // 외곽선 색상 변경
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green), // 포커스되었을 때 외곽선 색상 변경
                  ),
                  hintText: '비밀번호를 입력하세요', // 힌트 텍스트 변경
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  labelStyle: TextStyle(color: Colors.blue), // 레이블 텍스트 색상 변경
                  border: OutlineInputBorder( // 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red), // 외곽선 색상 변경
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green), // 포커스되었을 때 외곽선 색상 변경
                  ),
                  hintText: '같은 비밀번호를 입력하세요', // 힌트 텍스트 변경
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  String email = _emailController.text;
                  String name = _nameController.text;
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;

                  // 이메일 형식 검증
                  if (!_validateEmail(email)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("이메일 형식 오류"),
                          content: Text("유효한 이메일 주소를 입력하세요."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("확인"),
                            ),
                          ],
                        );
                      },
                    );
                    return; // 이메일 형식이 올바르지 않으면 함수 종료
                  }

                  // 비밀번호와 비밀번호 확인이 일치하는지 확인
                  if (password != confirmPassword) {
                    // 비밀번호와 비밀번호 확인이 일치하지 않으면 사용자에게 알림
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("비밀번호 확인"),
                          content: Text("비밀번호와 비밀번호 확인이 일치하지 않습니다."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 다이얼로그 닫기
                              },
                              child: Text("확인"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // 비밀번호와 비밀번호 확인이 일치하면 회원가입 요청 보내기 _sendRequest 작성이 아직 안되서 주석 처리
                    _sendPostRequest('user/signup', requestData: {
                      'email': email,
                      'name': name,
                      'password': password,
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white), // 버튼의 배경색 변경
                  foregroundColor: MaterialStateProperty.all(Colors.blue), // 버튼 텍스트 색상 변경
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder( // 버튼 모양 변경
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text('회원 가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
