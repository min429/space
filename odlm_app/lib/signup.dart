import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'globals.dart';

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
      backgroundColor: mainColor,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 265, 0, 0),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'Sign Up',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 40,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 30, 30, 5),
              child: Container(
                width: double.infinity, // 전체 너비 설정
                height: 50,
              child: TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white), // 텍스트 색상 변경
                decoration: InputDecoration(
                  labelText: 'email',
                  labelStyle: FlutterFlowTheme.of(context)
                      .bodyMedium
                      .override(
                    fontFamily: 'Readex Pro',
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w300,
                  ), // 레이블 텍스트 색상 변경
                  fillColor: Color(0x3AFFFFFF), // 배경색 설정
                  filled: true, // 배경색을 적용할지 여부
                  border: OutlineInputBorder( // 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none, // 외곽선 색상 변경
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.white), // 포커스되었을 때 외곽선 색상 변경
                  ),
                  hintText: '이메일을 입력하세요', // 힌트 텍스트 변경
                  hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // 힌트 텍스트 위아래와 좌우로 패딩을 추가하여 가운데 정렬
                ),
              ),
            ),
            ),

            SizedBox(height: 5), // 간격 추가
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 5),
              child: Container(
                width: double.infinity, // 전체 너비 설정
                height: 50,
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white), // 텍스트 색상 변경
                  decoration: InputDecoration(
                    labelText: 'name',
                    labelStyle: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w300,
                    ), // 레이블 텍스트 색상 변경
                    fillColor: Color(0x3AFFFFFF), // 배경색 설정
                    filled: true, // 배경색을 적용할지 여부
                    border: OutlineInputBorder( // 외곽선 스타일 변경
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // 외곽선 색상 변경
                    ),
                    focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white), // 포커스되었을 때 외곽선 색상 변경
                    ),
                    hintText: '이름을 입력하세요', // 힌트 텍스트 변경
                    hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // 힌트 텍스트 위아래와 좌우로 패딩을 추가하여 가운데 정렬
                  ),
                ),
              ),
            ),

            SizedBox(height: 5), // 간격 추가
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 5),
              child: Container(
                width: double.infinity, // 전체 너비 설정
                height: 50,
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  style: TextStyle(color: Colors.white), // 텍스트 색상 변경
                  decoration: InputDecoration(
                    labelText: 'password',
                    labelStyle: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w300,
                    ), // 레이블 텍스트 색상 변경
                    fillColor: Color(0x3AFFFFFF), // 배경색 설정
                    filled: true, // 배경색을 적용할지 여부
                    border: OutlineInputBorder( // 외곽선 스타일 변경
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // 외곽선 색상 변경
                    ),
                    focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white), // 포커스되었을 때 외곽선 색상 변경
                    ),
                    hintText: '비밀번호를 입력하세요', // 힌트 텍스트 변경
                    hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // 힌트 텍스트 위아래와 좌우로 패딩을 추가하여 가운데 정렬
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      color: Colors.white, // 아이콘 색상 변경
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5), // 간격 추가
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 125),
              child: Container(
                width: double.infinity, // 전체 너비 설정
                height: 50,
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  style: TextStyle(color: Colors.white), // 텍스트 색상 변경
                  decoration: InputDecoration(
                    labelText: 'password check',
                    labelStyle: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w300,
                    ), // 레이블 텍스트 색상 변경
                    fillColor: Color(0x3AFFFFFF), // 배경색 설정
                    filled: true, // 배경색을 적용할지 여부
                    border: OutlineInputBorder( // 외곽선 스타일 변경
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // 외곽선 색상 변경
                    ),
                    focusedBorder: OutlineInputBorder( // 포커스되었을 때 외곽선 스타일 변경
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white), // 포커스되었을 때 외곽선 색상 변경
                    ),
                    hintText: '같은 비밀번호를 입력하세요', // 힌트 텍스트 변경
                    hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // 힌트 텍스트 위아래와 좌우로 패딩을 추가하여 가운데 정렬
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      color: Colors.white, // 아이콘 색상 변경
                    ),
                  ),
                ),
              ),
            ),



            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 5),
              child: Container(
                width: double.infinity, // 전체 너비 설정
                height: 50,
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
                    foregroundColor: MaterialStateProperty.all(mainColor), // 버튼 텍스트 색상 변경
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder( // 버튼 모양 변경
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  // 버튼의 크기 변경
                  // width: double.infinity,
                  // height: 50,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '회원 가입 완료',
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                        fontFamily: 'Readex Pro',
                        color: mainColor,
                        fontSize: 18,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
