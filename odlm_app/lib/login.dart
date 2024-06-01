import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:odlm_app/service/messaging_service.dart';
import 'package:odlm_app/service/notification_service.dart';
import 'package:odlm_app/signup.dart';
import 'package:logging/logging.dart';

import 'main.dart';
import 'globals.dart';
import 'setting.dart';
import 'my_seat.dart';
import 'mypage.dart';
import 'reservation.dart';
import 'no_my_seat.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.time}: [${record.level}] ${record.loggerName}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 바인딩 초기화
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: LoginWidget(),
  ));
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late bool _passwordVisible;
  bool _isSelected = false;
  late String _errorMessage = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _model.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

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
        if (action == "") {
          //해당 로직 실행
        }
      } else {
        print('Error: ${response.statusCode}');
        // 에러 처리를 여기에 추가할 수 있습니다.
        if (response.statusCode == 200) {
          //해당 로직 실행
        }
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

        if (action == "user/login") {
          //해당 로직 실행
          userId = jsonDecode(response.body) as int?;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainWidget()),
          );
        }
      } else {
        print('Error: ${response.statusCode}');
        // 에러 처리를 여기에 추가할 수 있습니다

        if (action == "user/login") {
          setState(() {
            late bool _loading = false;
            _errorMessage = 'Invalid email or password'; // 에러 메시지 할당
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage,
                style: TextStyle(
                  fontSize: 25, // 원하는 크기로 조절하세요
                ),
              ),
            ),
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
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: mainColor,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 150, 0, 0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Text(
                        'SPACE',
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
                  padding: EdgeInsetsDirectional.fromSTEB(30, 30, 30, 12.5),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0x3AFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'email',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w300,
                                ),
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 5),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0x3AFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'password',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w300,
                                ),
                            enabledBorder: InputBorder.none,
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
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 110),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSelected = !_isSelected;
                      });
                    },
                    child: Opacity(
                      opacity: _isSelected ? 0.5 : 0.8,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0x00FFFFFF),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: Text(
                                '자동 로그인',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Opacity(
                    opacity: 0.9,
                    child: Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(30, 0, 30, 12.5),
                        child: GestureDetector(
                          onTap: () {
                            String email = _emailController.text;
                            String password = _passwordController.text;

                            _sendPostRequest('user/login', requestData: {
                              'email': email,
                              'password': password,
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '로그인',
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
                    ),
                  ),
                ),
                Flexible(
                  child: Opacity(
                    opacity: 0.9,
                    child: Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 50),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpWidget()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '회원가입',
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
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
