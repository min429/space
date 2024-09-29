import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';
import 'login.dart';

// 설정 화면 위젯
class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late SettingModel _model; // 설정 모델

  final scaffoldKey = GlobalKey<ScaffoldState>(); // Scaffold 상태 키

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingModel()); // 모델 초기화
  }

  @override
  void dispose() {
    _model.dispose(); // 모델 해제

    super.dispose();
  }

  Future<void> _sendPatchRequest(int userId, String action, bool value) async {
    final String url = 'http://10.0.2.2:8080/user/${userId.toString()}/$action/${value ? 'true' : 'false'}';
    print('Sending PATCH request to: $url');
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print('$action 설정이 성공적으로 업데이트되었습니다.');
      } else {
        print('$action 설정 업데이트에 실패했습니다. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground, // 배경색
        appBar: AppBar(
          backgroundColor: mainColor, // 앱바 배경색
          automaticallyImplyLeading: true,
          title: Text(
            '설정', // 앱바 타이틀
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              color: FlutterFlowTheme.of(context).primaryBackground,
              fontSize: 25,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white, // 뒤로 가기 버튼의 색상
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),


          actions: [], // 액션 버튼
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // 체크박스로 경고 알림 설정
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 25),
                      child: Text(
                        '경고 알림 보내기', // 항목 이름
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 23,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional(1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              unselectedWidgetColor:
                              FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: // 경고 알림 설정 체크박스
                            // 경고 알림 설정 체크박스
                            Checkbox(
                              value: _model.checkboxValue1 ??= true,
                              onChanged: (newValue) async {
                                setState(() => _model.checkboxValue1 = newValue!);

                                // 경고 알림 설정 PATCH 요청 보내기 (userId를 String으로 변환)
                                await _sendPatchRequest(userId!, 'warn', newValue!);
                              },
                              side: BorderSide(
                                width: 2,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 구분선
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                ),
              ),
              // 체크박스로 반납 알림 설정
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 25),
                      child: Text(
                        '반납 알림 보내기', // 항목 이름
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 23,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional(1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              unselectedWidgetColor:
                              FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: // 반납 알림 설정 체크박스
                            Checkbox(
                              value: _model.checkboxValue2 ??= true,
                              onChanged: (newValue) async {
                                setState(() => _model.checkboxValue2 = newValue!);

                                // 반납 알림 설정 PATCH 요청 보내기
                                await _sendPatchRequest(userId!, 'return', newValue!);
                              },
                              side: BorderSide(
                                width: 2,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 구분선
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                ),
              ),
              // 앱 버전
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 25),
                      child: Text(
                        '앱 버전',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 23,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Opacity(
                        opacity: 0.5,
                        child: Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
                            child: Text(
                              '1.0',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Readex Pro',
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
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                ),
              ),
              // 로그아웃 버튼
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 25),
                      child: GestureDetector(
                        onTap: () {
                          // Insert the logout logic here
                          // For example, clear user data or preferences

                          // Navigate to login screen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginWidget()),  // Use LoginWidget directly
                                (Route<dynamic> route) => false,  // Remove all routes below the pushed route
                          );
                        },
                        child: Text(
                          '로그아웃', // 항목 이름
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 23,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 구분선
              Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 설정 모델
class SettingModel extends FlutterFlowModel<SettingWidget> {
  final unfocusNode = FocusNode(); // 포커스 해제 노드
  // 체크박스 상태 필드
  bool? checkboxValue1;
  // 체크박스 상태 필드
  bool? checkboxValue2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose(); // 포커스 해제 노드 해제
  }
}
