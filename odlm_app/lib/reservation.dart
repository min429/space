import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({super.key});

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 700,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/KakaoTalk_20240410_125405800.jpg',
                          width: MediaQuery.sizeOf(context).width,
                          height: 700,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.53, -0.5),
                      child: Icon(
                        Icons.event_seat_sharp,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        size: 50,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.51, -0.5),
                      child: Icon(
                        Icons.event_seat_sharp,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        size: 50,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.51, -0.2),
                      child: Icon(
                        Icons.event_seat_sharp,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        size: 50,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.53, -0.2),
                      child: Icon(
                        Icons.event_seat_sharp,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReservationModel extends FlutterFlowModel<ReservationWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}