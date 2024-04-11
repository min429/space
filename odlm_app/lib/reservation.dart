import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;

// 예약 요청을 위한 DTO 클래스 정의
// 예약 요청을 위한 DTO 클래스 정의
class ReserveRequestDto {
  final int seatId;
  final int userId;

  ReserveRequestDto(this.seatId, this.userId);

  // JSON 직렬화 메서드
  Map<String, dynamic> toJson() {
    return {
      'seatId': seatId,
      'userId': userId,
    };
  }
}

// 예약 다이얼로그를 표시하고 서버에 요청을 보내는 함수
void _showReservationDialog(BuildContext context, int seatNumber) {
  // 사용자 ID와 좌석 ID 생성 (임의의 값 사용)
  int userId = 1;
  int seatId = seatNumber;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '좌석 예약',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '좌석 $seatNumber를 예약하시겠습니까?',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              '예',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            onPressed: () {
              // 예약 요청 데이터 생성
              ReserveRequestDto requestData = ReserveRequestDto(seatId, userId);
              // 예약 요청 함수 호출
              _sendReservationRequest(requestData);
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
          TextButton(
            child: Text(
              '아니요',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      );
    },
  );
}

// 서버에 예약 요청을 보내는 함수
void _sendReservationRequest(ReserveRequestDto requestData) async {
  final String url = 'http://10.0.2.2:8080/seat/reserve'; // 서버 엔드포인트 URL
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData.toJson()), // 예약 요청 데이터를 JSON으로 직렬화하여 전송
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

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({Key? key}) : super(key: key);

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  late ReservationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservationModel());
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xE1960F29),
          automaticallyImplyLeading: true,
          title: Text(
            '좌석발권',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              color: FlutterFlowTheme.of(context).primaryBackground,
              fontSize: 25,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500, // Adjust height as needed
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/seat.jpg',
                            width: MediaQuery.of(context).size.width,
                            height:700,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 좌석 1
                      Align(
                        alignment: Alignment(-0.51, -0.6),
                        child: GestureDetector(
                          onTap: () {
                            _showReservationDialog(context, 1); // 좌석 1을 선택한 경우 예약 다이얼로그 표시
                          },
                          child: Icon(
                            Icons.event_seat_sharp,
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            size: 50,
                          ),
                        ),
                      ),
                      // 좌석 2
                      Align(
                        alignment: Alignment(0.51, -0.6),
                        child: GestureDetector(
                          onTap: () {
                            _showReservationDialog(context, 2); // 좌석 2를 선택한 경우 예약 다이얼로그 표시
                          },
                          child: Icon(
                            Icons.event_seat_sharp,
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            size: 50,
                          ),
                        ),
                      ),

                      // 좌석 3
                      Align(
                        alignment: Alignment(-0.51, -0.25),
                        child: GestureDetector(
                          onTap: () {
                            _showReservationDialog(context, 3); // 좌석 3을 선택한 경우 예약 다이얼로그 표시
                          },
                          child: Icon(
                            Icons.event_seat_sharp,
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            size: 50,
                          ),
                        ),
                      ),

                      // 좌석 4
                      Align(
                        alignment: Alignment(0.51, -0.25),
                        child: GestureDetector(
                          onTap: () {
                            _showReservationDialog(context, 4); // 좌석 4를 선택한 경우 예약 다이얼로그 표시
                          },
                          child: Icon(
                            Icons.event_seat_sharp,
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
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

class ReservationModel extends FlutterFlowModel<ReservationWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
