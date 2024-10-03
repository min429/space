import 'dart:async';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odlm_app/service/messaging_service.dart';
import 'package:odlm_app/service/notification_service.dart';
import 'package:http/http.dart' as http;

import 'dto/ReadSeatResponseDto.dart';
import 'globals.dart';
import 'setting.dart';
import 'my_seat.dart';
import 'mypage.dart';
import 'reservation.dart';
import 'board.dart';
import 'no_my_seat.dart';
import 'notice.dart'; // notice.dart




class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

late int? RuserId = -1;
late int? seatId = -1;
late int? leaveId = -1;
late String userName = '';
late int seatNumber = 0;
late int dailyReservationTime = 0;
late int dailyAwayTime = 0;
late Color statusColor = Colors.black; // 기본 텍스트 색상

class MySeatRequestDto {
  final int userId;

  MySeatRequestDto({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late MainModel _model;

  int? studyTime;
  Timer? _timer; // 타이머 객체

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

  Future<void> initMessaging() async {
    NotificationService().initFirebaseMessaging();  // 서버와 통신을 관리하는 서비스 초기화
    MessagingService().setupForegroundNotificationListener();  // 포그라운드 알림 리스너 설정
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainModel());

    initMessaging();
    int userIdNonNull=-999;
    if (userId != null) {
      userIdNonNull = userId!;
    }
    MySeatRequestDto requestDto = MySeatRequestDto(userId: userIdNonNull);
    // 서버로부터 데이터 받아오기
    fetchMySeat(requestDto);

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    fetchAndDisplayStudyTime();
    startAutoRefresh(); // 자동 새로고침 시작
  }

  Future<void> fetchMySeat(MySeatRequestDto request) async {
    final String url = 'http://10.0.2.2:8080/user/myseat';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          RuserId = responseData['userId'] as int?;
          seatId = responseData['seatId'] as int?;
          leaveId = responseData['leaveId'] as int?;
          userName = responseData['name'] as String;
          seatNumber = responseData['seatId'] as int;
          dailyReservationTime = responseData['dailyReservationTime'] as int;
          dailyAwayTime = responseData['dailyAwayTime'] as int;
          // Status와 색상 설정
          if (RuserId != null && leaveId == null) {
            Status = "자리사용중";
            statusColor = Colors.blue;
          } else if (RuserId == null && leaveId != null) {
            Status = "자리비움중";
            statusColor = Colors.red;
          } else if (RuserId != null && leaveId != null) {
            Status = "임시자리사용중";
            statusColor = Colors.orange;
          } else {
            Status = "상태 없음";
            statusColor = Colors.black;
          }

        });
        print('Status: $Status');

      } else {
        Status = "상태 없음";
        statusColor = Colors.black;
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      Status = "상태 없음";
      statusColor = Colors.black;
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 해제
    _model.dispose();
    super.dispose();
  }

  // 자동 새로고침을 위한 타이머 시작 함수
  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchAndDisplayStudyTime(); // 1분마다 학습 시간을 갱신
    });
  }

  String formatTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      return '$hours시간 $minutes분';
    } else {
      return '$minutes분';
    }
  }

  String getCurrentDate() {
    // 현재 날짜를 "yyyy-MM-dd" 형식으로 리턴
    DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> fetchAndDisplayStudyTime() async {
    final int? fetchedStudyTime = await fetchStudyTime(userId!);

    if (fetchedStudyTime != null) {
      setState(() {
        studyTime = fetchedStudyTime; // 받은 데이터를 state에 저장
      });
    }
  }

  Future<int?> fetchStudyTime(int userId) async {
    final String url = 'http://10.0.2.2:8080/seat/$userId'; // 서버 URL

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // 서버로부터 성공적으로 데이터를 받았을 때
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final ReadSeatResponseDto seatData = ReadSeatResponseDto.fromJson(responseData);

        return seatData.studyTime; // studyTime 필드를 반환
      } else {
        print('Error: ${response.statusCode}');
        return 0; // 요청 실패 시 0 반환
      }
    } catch (e) {
      print('Exception: $e');
      return 0; // 예외 발생 시 0 반환
    }
  }

  Future<void> Check_My_Seat(MySeatRequestDto request) async {
    final String url = 'http://10.0.2.2:8080/user/myseat';
    print("user id $userId" );
    print("incode: ${jsonEncode(request.toJson())} ");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 500) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NoMySeatWidget()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MySeatWidget()),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
          backgroundColor: mainColor,
          // 앱 바의 배경색 설정
          automaticallyImplyLeading: false,
          // 뒤로 가기 버튼 자동 추가 안 함
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'SPACE', // 앱 타이틀 설정
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
                      color: mainColor,
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
                                                    alignment: AlignmentDirectional(0, 0),
                                                    child: Text(
                                                      formatTime(studyTime ?? 0), // 시간이 없을 때는 0분으로 처리
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Readex Pro',
                                                        color: Color(0xC9FFFFFF),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
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
                            int userIdNonNull=-999;
                            if (userId != null) {
                              userIdNonNull = userId!;
                            }
                            MySeatRequestDto requestDto = MySeatRequestDto(userId: userIdNonNull);
                            Check_My_Seat(requestDto);

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeDetailPage(
                              notice: const {
                                'title': '공지사항', // 공지사항 제목을 여기에 전달
                                'date': '20★★-XX-OO', // 공지사항 날짜를 여기에 전달
                                'content1': '- 자리 비움을 하지 않고 자리에 벗어나는 행위를 지속적으로 진행할 시 패널티를 받게 됩니다.\n엎드려서 이불을 덮고 잠을 자는 행위와 같은 사람의 형태를 가리는 활동을 자제해주세요.',
                                'content2': '- 자리를 비우고 20분 누적 시 경고 알림이 발송됩니다.\n- 자리를 비우고 30분 누적 시 자리가 박탈됩니다.\n- 자리 박탈 3회 누적 시 회원 등급이 낮아집니다.',
                                'content3': '- 자리 반납 시 반납버튼을 꼭 눌러주세요.'
                              },
                            ),
                          ),
                        );
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


