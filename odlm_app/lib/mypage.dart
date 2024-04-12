import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';



class MypageWidget extends StatefulWidget {
  const MypageWidget({super.key});

  @override
  State<MypageWidget> createState() => _MypageWidgetState();
}

class _MypageWidgetState extends State<MypageWidget> {
  late MypageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MypageModel());
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
            '마이페이지',
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: 160,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 70,
                          decoration: BoxDecoration(
                            color:
                            FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Opacity(
                            opacity: 0.7,
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '오늘의 학습시간',
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
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 90,
                          decoration: BoxDecoration(
                            color:
                            FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Opacity(
                            opacity: 0.7,
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '0분',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 23,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600,
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
                      width: 1,
                      height: 120,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: 160,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 70,
                          decoration: BoxDecoration(
                            color:
                            FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Opacity(
                            opacity: 0.7,
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '이달의 학습시간',
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
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 90,
                          decoration: BoxDecoration(
                            color:
                            FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Text(
                                  ' 총 ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: Text(
                                      '20시간 03분',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 23,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class MypageModel extends FlutterFlowModel<MypageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
