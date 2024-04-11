import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BoardItem {
  final int id;
  final String usermail;
  final String userName;
  final String content;
  final String postDate;

  BoardItem({
    required this.id,
    required this.usermail,
    required this.userName,
    required this.content,
    required this.postDate,
  });

  factory BoardItem.fromJson(Map<String, dynamic> json) {
    final String postTimeString = json['postTime'];
    final DateTime postDateTime = postTimeString != null ? DateTime.parse(postTimeString) : DateTime.now();
    final formattedPostDate = '${postDateTime.year}-${postDateTime.month}-${postDateTime.day}';

    return BoardItem(
      id: json['id'],
      usermail: json['usermail'],
      userName: json['userName'],
      content: json['content'],
      postDate: formattedPostDate,
    );
  }
}

Future<List<BoardItem>> _sendGetRequest(String action) async {
  final String url = 'http://10.0.2.2:8080/$action';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<BoardItem> data = jsonData.map((item) => BoardItem.fromJson(item)).toList();
      return data;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Exception: $e');
    throw Exception('Failed to load data');
  }
}

class BoardWidget extends StatefulWidget {
  const BoardWidget({Key? key}) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  late Future<List<BoardItem>> _boardDataFuture;

  @override
  void initState() {
    super.initState();
    _boardDataFuture = _sendGetRequest('board/getAll');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '게시판',
          style: TextStyle(
            color: Colors.white, // 텍스트의 색상을 변경하려면 여기에 원하는 색상을 지정하세요
          ),
        ),
        backgroundColor: Color(0xFFE1960F29), // 원하는 배경색으로 변경
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // 뒤로 가기 버튼의 색상
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),


      body: FutureBuilder<List<BoardItem>>(
        future: _boardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final boardItems = snapshot.data!;
            return SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var item in boardItems) ...[
                      _buildBoardItem(item),
                      _buildDivider(),
                    ],
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBoardItem(BoardItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 50,
          color: Colors.white,
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
          child: Text(
            item.content,
            maxLines: 5,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  item.userName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  item.postDate,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BoardWidget(),
  ));
}
