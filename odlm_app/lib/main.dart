import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odlm_app/service/notification_service.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';
import 'setting.dart';
import 'my_seat.dart';
import 'mypage.dart';
import 'reservation.dart';
import 'board.dart';


class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late MainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 90),
          end: Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 60),
          end: Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 170),
          end: Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 90),
          end: Offset(0, 0),
        ),
      ],
    ),
  };

  Future<void> initFirebaseMessaging() async {
    await NotificationService().initFirebaseMessaging();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainModel());

    initFirebaseMessaging();

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }


  @override
  void dispose() {
    _model.dispose();

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

        if (action == "") {
          //해당 로직 실행
        }
      } else {
        print('Error: ${response.statusCode}');
        // 에러 처리를 여기에 추가할 수 있습니다

        // if (response.statusCode == ) {
        //   //해당 로직 실행
        // }
      }
    } catch (e) {
      print('Exception: $e');
      // 예외 처리를 여기에 추가할 수 있습니다.
    }
  }


  @override
  Widget build(BuildContext context) {
    // GestureDetector를 사용하여 화면을 탭하면 포커스를 처리합니다.
    return GestureDetector(
      onTap: () =>
      _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey, // Scaffold의 GlobalKey 설정
        backgroundColor: FlutterFlowTheme
            .of(context)
            .secondaryBackground, // 배경색 설정
        appBar: AppBar(
          backgroundColor: Color(0xE1960F29),
          // 앱 바의 배경색 설정
          automaticallyImplyLeading: false,
          // 뒤로 가기 버튼 자동 추가 안 함
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'ODLM', // 앱 타이틀 설정
                style: FlutterFlowTheme
                    .of(context)
                    .headlineLarge
                    .override(
                  fontFamily: 'Outfit', // 글꼴 설정
                  color: Colors.white, // 글자색 설정
                  fontSize: 25, // 글자 크기 설정
                  letterSpacing: 0, // 글자 간격 설정
                ),
              ),
            ],
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                child:GestureDetector(
                  onTap: () {
                    // 예약 메뉴를 터치했을 때 실행할 동작을 여기에 작성합니다.
                    print('예약 메뉴가 선택되었습니다.');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingWidget()),
                    );
                  },
                  child: FaIcon(
                    FontAwesomeIcons.bars, // 바 아이콘 설정
                    color: Color(0xCEFFFFFF), // 아이콘 색상 설정
                    size: 30, // 아이콘 크기 설정
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          // 타이틀 가운데 정렬 설정
          elevation: 0, // 그림자 효과 없앰
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Column의 크기를 자식의 크기에 맞춤
              children: [
                // 상단 컨테이너
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xE1960F29),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // 좌측 컨테이너
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0x00FFFFFF),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 0),
                                  children: [
                                    // 중앙 원
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Color(0x00FFFFFF),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0x43FFFFFF),
                                            width: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 내부 원
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Container(
                                        width: 105,
                                        height: 105,
                                        decoration: BoxDecoration(
                                          color: Color(0x00FFFFFF),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0x43FFFFFF),
                                            width: 10,
                                          ),
                                        ),
                                        child: Align(
                                            alignment: AlignmentDirectional(
                                                0, 0),
                                            child: Center(
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Align(
                                                    alignment: AlignmentDirectional(
                                                        0, 0),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 0, 10),
                                                      child: Text(
                                                        '학습시간',
                                                        style: FlutterFlowTheme
                                                            .of(
                                                            context)
                                                            .bodyMedium
                                                            .override(
                                                          fontFamily: 'Readex Pro',
                                                          color: Color(
                                                              0x85FFFFFF),
                                                          fontSize: 10,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // 학습시간 표시
                                                  Align(
                                                    alignment: AlignmentDirectional(
                                                        0, 0),
                                                    child: Text(
                                                      '0분',
                                                      style: FlutterFlowTheme
                                                          .of(
                                                          context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily: 'Readex Pro',
                                                        color: Color(
                                                            0xC9FFFFFF),
                                                        fontSize: 15,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 우측 컨테이너
                        Flexible(
                          flex: 4,
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0x00FFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 메뉴 그리드
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                    child: GridView(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        GestureDetector(
                        onTap: () {
                          // 예약 메뉴를 터치했을 때 실행할 동작을 여기에 작성합니다.
                          print('예약 메뉴가 선택되었습니다.');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationWidget()),
                            );
                          },
                        // 예약 메뉴
                        child:Container(
                          width: MediaQuery
                              .sizeOf(context)
                              .width * 0.4,
                          height: 160,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme
                                .of(context)
                                .primaryBackground,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                              child: Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Icon(
                                      Icons.space_dashboard,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText,
                                      size: 32,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 12),
                                      child: Text(
                                        '예약',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .displaySmall
                                            .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 30,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation1']!),
                        ),
                        GestureDetector(
                          onTap: () {
                            // 마이페이지가를 터치했을 때 실행할 동작을 여기에 작성합니다.
                            print('마이페이지가 선택되었습니다.');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MypageWidget()),
                            );
                          },
                        // 마이페이지 메뉴
                        child: Container(
                          width: MediaQuery
                              .sizeOf(context)
                              .width * 0.4,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Color(0xFFA4A9B0),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Icon(
                                      Icons.supervisor_account_rounded,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText,
                                      size: 37,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 12),
                                      child: Text(
                                        '마이페이지',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .displaySmall
                                            .override(
                                          fontFamily: 'Outfit',
                                          color:
                                          FlutterFlowTheme
                                              .of(context)
                                              .info,
                                          fontSize: 29,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation2']!),
                        ),

                        GestureDetector(
                          onTap: () {

                            // 나의자리를 터치했을 때 실행할 동작을 여기에 작성합니다.
                            print('나의자리가 선택되었습니다.');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MySeatWidget()),
                            );

                          },
                        // 나의 자리 메뉴
                        child:Container(
                          width: MediaQuery
                              .sizeOf(context)
                              .width * 0.4,
                          height: 160,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme
                                .of(context)
                                .primaryBackground,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Icon(
                                      Icons.event_seat,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText,
                                      size: 34,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 12),
                                      child: Text(
                                        '나의 자리',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .displaySmall
                                            .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 30,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation3']!),

                        ),
                      GestureDetector(
                        onTap: () {
                          // 게시판를 터치했을 때 실행할 동작을 여기에 작성합니다.
                          print('게시판 선택되었습니다.');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BoardWidget()),
                          );

                        },
                        // 게시판 메뉴
                        child:Container(
                          width: MediaQuery
                              .sizeOf(context)
                              .width * 0.4,
                          height: 160,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme
                                .of(context)
                                .primaryBackground,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.bookOpenReader,
                                      color: FlutterFlowTheme
                                          .of(context)
                                          .primaryText,
                                      size: 30,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 12),
                                      child: Text(
                                        '게시판',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme
                                            .of(context)
                                            .displaySmall
                                            .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 30,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation4']!),
                        ),
                      ],
                    ),
                  ),
                ),
                // 공지사항 컨테이너
                Flexible(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                    child:GestureDetector(
                      onTap: () {
                        // 공지사항를 터치했을 때 실행할 동작을 여기에 작성합니다.
                        print('공지사항 선택되었습니다.');

                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme
                              .of(context)
                              .primaryBackground,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Icon(
                                Icons.event_note,
                                color: FlutterFlowTheme
                                    .of(context)
                                    .primaryText,
                                size: 30,
                              ),
                              Center(
                                child: Text(
                                  '공지사항',
                                  style: FlutterFlowTheme
                                      .of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 30,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainModel extends FlutterFlowModel<MainWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
