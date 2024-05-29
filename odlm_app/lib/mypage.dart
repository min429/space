import 'dart:convert';
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

  List<BarChartGroupData> barChartData = [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 0,
          color: Colors.blue,
        ),
      ],
    ),
  ]; // 기본적으로 비어있지 않은 상태로 설정

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
    // 여기에 차트 데이터를 로드하는 코드를 추가합니다.
    // 예제 데이터로 설정
    setState(() {
      barChartData = [
        BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 5, color: Colors.lightBlueAccent)]),
        BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 10, color: Colors.lightBlueAccent)]),
        BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 15, color: Colors.lightBlueAccent)]),
        BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 20, color: Colors.lightBlueAccent)]),
        BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 25, color: Colors.lightBlueAccent)]),
      ];
    });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: const Color(0xE1960F29),
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
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
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
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
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
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
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
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
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
                  height: 300, // 고정된 높이 설정
                  padding: const EdgeInsets.all(8.0),
                  child: BarChart(
                    BarChartData(
                      barGroups: barChartData,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              );
                              Widget text;
                              switch (value.toInt()) {
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
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueAccent,
                        ),
                      ),
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
