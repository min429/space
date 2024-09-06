import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'globals.dart';

class MypageWidget extends StatefulWidget {
  const MypageWidget({Key? key}) : super(key: key);

  @override
  State<MypageWidget> createState() => _MypageWidgetState();
}

class _MypageWidgetState extends State<MypageWidget> {
  final FocusNode unfocusNode = FocusNode();
  String dailyStudyTime = '0분';
  String monthlyStudyTime = '0시간 0분';

  List<BarChartGroupData> barChartData = List.generate(
    12,
        (index) => BarChartGroupData(
      x: index + 1,
      barRods: [
        BarChartRodData(toY: 0, color: Colors.lightBlueAccent, borderRadius: BorderRadius.zero),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadStudyTimes();
    _loadBarChartData();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStudyTimes() async {
    try {
      final int today = DateTime.now().day;
      final int thisMonth = DateTime.now().month;

      final dailyTimeInMinutes = await _fetchDailyStudyTime(today);
      final monthlyTimeInMinutes = await _fetchMonthlyStudyTime(thisMonth);

      setState(() {
        dailyStudyTime = '$dailyTimeInMinutes분';
        final monthlyMinutes = int.parse(monthlyTimeInMinutes);
        final hours = monthlyMinutes ~/ 60;
        final minutes = monthlyMinutes % 60;
        monthlyStudyTime = '$hours시간 $minutes분';
      });
    } catch (e) {
      print('Failed to load study times: $e');
    }
  }

  Future<void> _loadBarChartData() async {
    try {
      final monthlyTimes = await _fetchAllMonthlyStudyTime();
      final int thisMonth = DateTime.now().month;

      setState(() {
        barChartData = List.generate(12, (index) {
          double value = monthlyTimes.length > index ? monthlyTimes[index] / 60 : 0; // 시간 단위로 변환
          Color barColor = (index + 1) > thisMonth ? Colors.blue[100]! : Colors.lightBlueAccent; // 작년과 올해 색상 구분
          return BarChartGroupData(
            x: index + 1,
            barRods: [
              BarChartRodData(toY: value, color: barColor, borderRadius: BorderRadius.zero),
            ],
          );
        });
      });
    } catch (e) {
      print('Failed to load bar chart data: $e');
    }
  }

  Future<String> _fetchDailyStudyTime(int day) async {
    final String url = 'http://10.0.2.2:8080/mypage/day/$day';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode == 200) {
      return response.body; // 서버에서 받은 "분" 데이터
    } else {
      throw Exception('Failed to load daily study time');
    }
  }

  Future<String> _fetchMonthlyStudyTime(int month) async {
    final String url = 'http://10.0.2.2:8080/mypage/month/$month';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode == 200) {
      return response.body; // 서버에서 받은 "분" 데이터
    } else {
      throw Exception('Failed to load monthly study time');
    }
  }

  Future<List<int>> _fetchAllMonthlyStudyTime() async {
    final String url = 'http://10.0.2.2:8080/mypage/monthly/all';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode == 200) {
      return List<int>.from(jsonDecode(response.body)); // 서버에서 받은 "분" 데이터 리스트
    } else {
      throw Exception('Failed to load all monthly study times');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: mainColor,
          automaticallyImplyLeading: true,
          title: Text(
            '마이페이지',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              color: FlutterFlowTheme.of(context).primaryBackground,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // 위쪽 정렬
                  children: [
                    // 첫 번째 컨테이너: 오늘의 학습시간
                    Expanded(
                      child: Container(
                        height: 160,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        child: Column(
                          children: [
                            // 오늘의 학습시간 타이틀
                            Container(
                              height: 70,
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  '오늘의 학습시간',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                  ),
                                ),
                              ),
                            ),
                            // 오늘의 학습시간 값
                            Container(
                              height: 90,
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  dailyStudyTime,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 구분선
                    Padding(
                      padding: const EdgeInsets.only(top: 10), // 위쪽 패딩 추가
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: 1,
                          height: 120,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                    // 두 번째 컨테이너: 이달의 학습시간
                    Expanded(
                      child: Container(
                        height: 160,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        child: Column(
                          children: [
                            // 이달의 학습시간 타이틀
                            Container(
                              height: 70,
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  '이달의 학습시간',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                  ),
                                ),
                              ),
                            ),
                            // 이달의 학습시간 값
                            Container(
                              height: 90,
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 이달의 학습시간 값
                                  Flexible(
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        monthlyStudyTime,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600,
                                        ),
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
                  ],
                ),
                const SizedBox(height: 20),
                // 막대 그래프 추가
                Container(
                  height: 400, // 고정된 높이 설정
                  padding: const EdgeInsets.only(left: 10.0, right: 35.0),
                  child: BarChart(
                    BarChartData(
                      barGroups: barChartData,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 1:
                                  text = const Text('1월', style: style);
                                  break;
                                case 2:
                                  text = const Text('2월', style: style);
                                  break;
                                case 3:
                                  text = const Text('3월', style: style);
                                  break;
                                case 4:
                                  text = const Text('4월', style: style);
                                  break;
                                case 5:
                                  text = const Text('5월', style: style);
                                  break;
                                case 6:
                                  text = const Text('6월', style: style);
                                  break;
                                case 7:
                                  text = const Text('7월', style: style);
                                  break;
                                case 8:
                                  text = const Text('8월', style: style);
                                  break;
                                case 9:
                                  text = const Text('9월', style: style);
                                  break;
                                case 10:
                                  text = const Text('10월', style: style);
                                  break;
                                case 11:
                                  text = const Text('11월', style: style);
                                  break;
                                case 12:
                                  text = const Text('12월', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: text,
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (![0, 10, 20, 30, 40, 50].contains(value.toInt())) {
                                return Container(); // 빈 컨테이너 반환
                              }
                              const style = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              );
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 0, // 그래프와 숫자 간의 공간을 줄입니다.
                                child: Text(value.toInt().toString(), style: style),
                              );
                            },
                            interval: 10,
                            reservedSize: 28, // 공간을 줄이기 위해 예약 크기를 조정합니다.
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true, // 그래프 테두리를 추가합니다.
                        border: const Border(
                          top: BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueAccent,
                        ),
                      ),
                      gridData: FlGridData(
                        show: true, // 가로줄을 추가합니다.
                        drawHorizontalLine: true,
                        horizontalInterval: 10, // 간격을 10으로 설정
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                            dashArray: [1, 0], // 점선으로 그리려면 이 부분을 추가합니다.
                          );
                        },
                        drawVerticalLine: false,
                      ),
                      maxY: 50, // 세로 축의 최대 값을 50으로 설정합니다.
                    ),
                    swapAnimationDuration: Duration(milliseconds: 500), // 애니메이션 지속 시간
                    swapAnimationCurve: Curves.easeInOut, // 애니메이션 곡선
                  ),
                ),
                // 범례 추가
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: Colors.lightBlueAccent,
                          ),
                          const SizedBox(width: 5),
                          const Text('올해'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: Colors.blue[100],
                          ),
                          const SizedBox(width: 5),
                          const Text('작년'),
                        ],
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
