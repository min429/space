import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MySeatWidget extends StatefulWidget {
  const MySeatWidget({super.key});

  @override
  State<MySeatWidget> createState() => _MySeatWidgetState();
}

class MySeatRequestDto {
  final int userId;

  MySeatRequestDto({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}

class _MySeatWidgetState extends State<MySeatWidget> {
  late MySeatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 변수 선언
  late int? RuserId = -1;
  late int? seatId = -1;
  late int? leaveId = -1;
  late String userName = '';
  late int seatNumber = 0;
  late int dailyReservationTime = 0;
  late int dailyAwayTime = 0;
  late String Status = '';
  late Color statusColor = Colors.black; // 기본 텍스트 색상

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MySeatModel());
    int userIdNonNull=-999;
    if (userId != null) {
      userIdNonNull = userId!;
    }

    MySeatRequestDto requestDto = MySeatRequestDto(userId: userIdNonNull);
    // 서버로부터 데이터 받아오기
    fetchMySeat(requestDto);
  }

  String convertMinutesToHoursAndMinutes(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return '$hours시간 $remainingMinutes분';
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
        print('seatId: $RuserId');
        print('seatId: $seatId');
        print('leaveId: $leaveId');
        print('User Name: $userName');
        print('Seat Number: $seatNumber');
        print('Daily Reservation Time: $dailyReservationTime');
        print('Daily Away Time: $dailyAwayTime');

      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: mainColor,
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '나의 자리',
                textAlign: TextAlign.start,
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 25,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white, // 뒤로 가기 버튼의 색상
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                child: FaIcon(
                  FontAwesomeIcons.bars,
                  color: Color(0xCEFFFFFF),
                  size: 30,
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Container(
                        width: double.infinity,
                        height:260,
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

                        //열람실 발권 정보 / 좌석 정보 나누는 ROW
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 12),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                            AlignmentDirectional(-1, -1),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(30, 20, 0, 0),
                                              child: Text(
                                                '일일 사용 시간',
                                                style:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily:
                                                  'Readex Pro',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(1, -1),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 20, 30, 0),
                                                child: Text(
                                                  '남은 시간 ${convertMinutesToHoursAndMinutes(dailyReservationTime)}',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    color: Color(0xFF4AB1F3),
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                            AlignmentDirectional(-1, -1),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(30, 20, 0, 0),
                                              child: Text(
                                                '일일 자리비움 시간',
                                                style:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily:
                                                  'Readex Pro',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(1, -1),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 20, 30, 0),
                                                child: Text(
                                                  '남은 시간 ${convertMinutesToHoursAndMinutes(dailyAwayTime)}',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    color: Color(0xFF4AB1F3),
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      StyledDivider(
                                        thickness: 2,
                                        indent: 20,
                                        endIndent: 20,
                                        color: Color(0xFFC7CACE),
                                        lineStyle: DividerLineStyle.dotted,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(30, 10, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 5),
                                                        child: Text(
                                                          '사용자명',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            color: FlutterFlowTheme.of(
                                                                context)
                                                                .secondaryText,
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$userName 님',
                                                      textAlign:
                                                      TextAlign.start,
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily:
                                                        'Readex Pro',
                                                        fontSize: 15,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 10, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 5),
                                                        child: Text(
                                                          '좌석정보',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            color: FlutterFlowTheme.of(
                                                                context)
                                                                .secondaryText,
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$seatNumber 번',
                                                      textAlign:
                                                      TextAlign.start,
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily:
                                                        'Readex Pro',
                                                        fontSize: 15,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      StyledDivider(
                                        thickness: 2,
                                        indent: 20,
                                        endIndent: 20,
                                        color: Color(0xFFC7CACE),
                                        lineStyle: DividerLineStyle.dotted,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(30, 10, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 5),
                                                        child: Text(
                                                          '현재상태',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            color: FlutterFlowTheme.of(
                                                                context)
                                                                .secondaryText,
                                                            letterSpacing:
                                                            0,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 10, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      AlignmentDirectional(
                                                          -1, 0),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 5),
                                                        child: Text(
                                                          '$Status',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            color: statusColor,
                                                            letterSpacing:
                                                            0,
                                                            fontSize: 20, // 원하는 크기로 변경
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),


                // 아래 버튼 두개!!!!!!!!!!!!!!!
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 10, 20),
                                child: GestureDetector(
                                  onTap: () {
                                    print('자리반납이 선택되었습니다.');
                                    showReturnDialog(context);

                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color(0x00FFFFFF),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Text(
                                        '자리 반납',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10, 20, 20, 20),
                                child: GestureDetector(
                                  onTap: () {
                                    print('자리비움이 선택되었습니다.');
                                    // 다이얼로그 표시 함수 호출
                                    // 다이얼로그 표시 함수 호출
                                    showAwayDialog(context, dailyReservationTime, dailyAwayTime);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color(0x00FFFFFF),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Text(
                                        '자리 비움',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// 반납 다이얼로그를 표시하고 반납 요청을 보내는 함수
void showReturnDialog(BuildContext context) {
  // 다이얼로그 내에서 userId를 사용하여 반납 요청을 보냅니다.
  int? currentUserID = userId;
  print('Sending return request for user ID: $currentUserID');
  // 만약 userId가 null이면 반납 다이얼로그를 표시하지 않고 함수를 종료합니다.
  if (currentUserID == null) {
    print('User ID is null');
    return;
  }

  print('Sending return request for user ID: $currentUserID');


  // 여기에 반납 다이얼로그를 표시하는 코드를 작성합니다.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('자리 반납'),
        content: Text('자리 반납을 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              // 반납 요청 로직을 수행합니다.
              sendReturnRequest(currentUserID);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('예'),
          ),
          TextButton(
            onPressed: () {

              // 다이얼로그를 닫습니다.
              Navigator.of(context).pop();

            },
            child: Text('아니요'),
          ),
        ],
      );
    },
  );
}

//
void sendReturnRequest(int userId) async {
  final String url = 'http://10.0.2.2:8080/seat/return'; // 서버 엔드포인트 URL
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'userId': userId}), // 반납 요청 데이터를 JSON으로 직렬화하여 전송
    );
    if (response.statusCode == 200) {
      print('Return request successful');
      // 서버 응답에 대한 처리를 여기에 추가할 수 있습니다.
    } else {
      print('Return request failed with status code: ${response.statusCode}');
      // 에러 처리를 여기에 추가할 수 있습니다.
    }
  } catch (e) {
    print('Exception: $e');
    // 예외 처리를 여기에 추가할 수 있습니다.
  }
}

// 다이얼로그 표시 함수
void showAwayDialog(BuildContext context, int dailyReservationTime, int dailyAwayTime) {
  int maxAwayTime = dailyReservationTime < dailyAwayTime ? dailyReservationTime : dailyAwayTime;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      int selectedNumber = 0; // 초기 선택값은 0으로 설정

      return AlertDialog(
        title: Text("자리 비움 시간 선택"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("최대 $maxAwayTime분 까지 자리 비움을 하실 수 있습니다."),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '시간을 입력하세요',
                hintText: '0부터 $maxAwayTime분 까지 입력 가능합니다.',
              ),
              onChanged: (value) {
                // 입력된 값을 정수로 변환하여 selectedNumber에 할당
                selectedNumber = int.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () {
              if (selectedNumber <= maxAwayTime) {
                // 여기에 선택된 시간을 처리하는 코드를 추가하세요.
                _leaveSeat(selectedNumber); // leave 메서드 호출
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop();
              } else {
                // 최대 값보다 큰 값을 선택한 경우 경고 메시지 출력
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('최대 $maxAwayTime 시간까지 선택 가능합니다.'),
                ));
              }
            },
            child: Text("확인"),
          ),
        ],
      );
    },
  );
}

// 자리 비움 요청을 보내는 함수
Future<void> _leaveSeat(int selectedTime) async {
  final String url = 'http://10.0.2.2:8080/seat/leave';

  // leave 메서드에 전달할 데이터 구성
  final leaveData = {
    'userId': userId, // 사용자 ID
    'leaveTime': selectedTime, // 선택된 자리 비움 시간
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(leaveData),
    );

    if (response.statusCode == 200) {
      print('자리 비움 요청이 성공적으로 전송되었습니다.');
    } else {
      print('자리 비움 요청 실패: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('오류: $e');
  }
}

class MySeatModel extends FlutterFlowModel<MySeatWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

