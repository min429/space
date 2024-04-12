import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class MypageWidget extends StatefulWidget {
  const MypageWidget({Key? key}) : super(key: key);

  @override
  State<MypageWidget> createState() => _MypageWidgetState();
}

class _MypageWidgetState extends State<MypageWidget> {
  late MypageModel _model;

  @override
  void initState() {
    super.initState();
    _model = MypageModel();
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
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // 위쪽 정렬
              children: [
                // 첫 번째 컨테이너: 오늘의 학습시간
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
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
                            '0분',
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
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
                            // '총' 텍스트
                            Text(
                              '총 ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Readex Pro',
                              ),
                            ),
                            // 이달의 학습시간 값
                            Flexible(
                              child: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  '20시간 03분',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MypageModel {
  final FocusNode unfocusNode = FocusNode();

  void dispose() {
    unfocusNode.dispose();
  }
}
