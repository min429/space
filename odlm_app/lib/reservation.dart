import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
                      Align(  //1번 좌석
                        alignment: Alignment(-0.51, -0.6),
                        child: Icon(
                          Icons.event_seat_sharp,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 50,
                        ),
                      ),
                      Align( // 2번좌석
                        alignment: Alignment(0.51, -0.6),
                        child: Icon(
                          Icons.event_seat_sharp,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 50,
                        ),
                      ),

                      Align(// 3번좌석
                        alignment: Alignment(-0.51, -0.25),
                        child: Icon(
                          Icons.event_seat_sharp,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 50,
                        ),
                      ),
                      
                      Align( //4번좌석
                        alignment: Alignment(0.51, -0.25),
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
