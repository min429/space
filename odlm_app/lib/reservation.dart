import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:odlm_app/globals.dart';

// 좌석 정보 받는 dto 정의
class SeatDto {
  final int seatId;
  final int? userId;

  SeatDto(this.seatId, this.userId);

  // JSON에서 변환하여 좌석 정보를 생성하는 팩토리 메서드
  factory SeatDto.fromJson(Map<String, dynamic> json) {
    return SeatDto(
      json['seatId'] as int,
      json['userId'] as int?,
    );
  }
}

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
              Navigator.of(context).pop(); // 예약창 나가기
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

// 서버에서 모든 좌석 정보를 가져오는 함수
Future<List<SeatDto>> getAllSeats() async {
  final String url = 'http://10.0.2.2:8080/seat/getAll'; // 서버 엔드포인트 URL
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // JSON을 List<SeatDto>로 변환하여 반환
      final List<dynamic> seatList = jsonDecode(response.body);
      return seatList.map((seatJson) => SeatDto.fromJson(seatJson)).toList();
    } else {
      print('Error: ${response.statusCode}');
      return []; // 에러 발생 시 빈 리스트 반환
    }
  } catch (e) {
    print('Exception: $e');
    return []; // 예외 발생 시 빈 리스트 반환
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

  List<int> reservedSeats = []; // 예약된 좌석 목록

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservationModel());
    _fetchReservedSeats(); // 예약된 좌석 정보 가져오기
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // 예약된 좌석 정보 가져오기
  void _fetchReservedSeats() async {
    try {
      final List<SeatDto> seats = await getAllSeats();
      setState(() {
        reservedSeats = seats.where((seat) => seat.userId != null).map((seat) => seat.seatId).toList();
      });
    } catch (e) {
      print('Error fetching reserved seats: $e');
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white, // 뒤로 가기 버튼의 색상
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
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
                            height: 700,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 좌석 1
                      _buildSeatIcon(1),
                      // 좌석 2
                      _buildSeatIcon(2),
                      // 좌석 3
                      _buildSeatIcon(3),
                      // 좌석 4
                      _buildSeatIcon(4),
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

  Widget _buildSeatIcon(int seatNumber) {
    final isReserved = reservedSeats.contains(seatNumber); // 좌석이 예약되었는지 확인
    final iconColor = isReserved ? Colors.blue : FlutterFlowTheme.of(context).primaryBackground;

    return Align(
      alignment: _getSeatAlignment(seatNumber),
      child: GestureDetector(
        onTap: () {
          if (!isReserved || reservedSeats.isEmpty) {
            _showReservationDialog(context, seatNumber); // 좌석이 예약되지 않은 경우 다이얼로그 표시
          }
        },
        child: Icon(
          Icons.event_seat_sharp,
          color: iconColor,
          size: 50,
        ),
      ),
    );
  }

  Alignment _getSeatAlignment(int seatNumber) {
    switch (seatNumber) {
      case 1:
        return Alignment(-0.51, -0.6);
      case 2:
        return Alignment(0.51, -0.6);
      case 3:
        return Alignment(-0.51, -0.25);
      case 4:
        return Alignment(0.51, -0.25);
      default:
        return Alignment.center;
    }
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
