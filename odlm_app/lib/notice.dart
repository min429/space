import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:odlm_app/globals.dart';
import 'writeboard.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'globals.dart';

class NoticePage extends StatelessWidget {


  // 여러 공지사항을 담을 리스트
  final List<Map<String, String>> notices = [
    {
      'title': '공지사항 1',
      'date': '2024-10-01',
      'content1': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.',
      'content2': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.',
      'content3': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.'
    },
    {
      'title': '공지사항 2',
      'date': '2024-09-25',
      'content1': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.',
      'content2': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.',
      'content3': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.'
    },
    {
      'title': '공지사항 3',
      'date': '2024-09-15',
      'content1': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.',
      'content2': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.',
      'content3': '자리비움을 하지않고 자리에 벗어나는 행위를 지속적으로 할 경우 패널티를 받을 수 있습니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor, // mainColor가 정상적으로 정의되었는지 확인
        automaticallyImplyLeading: true,
        title: Text(
          '공지 사항',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            color: Colors.white, // 폰트 색상을 명시적으로 설정
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // 아이콘 색상
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: notices.length,  // 공지사항 개수만큼 아이템 생성
        itemBuilder: (context, index) {
          final notice = notices[index];  // 현재 공지사항 데이터 가져오기
          return ListTile(
            title: Text(notice['title']!), // 공지사항 제목
            subtitle: Text(notice['date']!), // 공지사항 날짜
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeDetailPage(notice: notice),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NoticeDetailPage extends StatelessWidget {
  final Map<String, String> notice;

  NoticeDetailPage({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor, // mainColor가 정상적으로 정의되었는지 확인
        automaticallyImplyLeading: true,
        title: Text(notice['title']! ,
            style: TextStyle(
          fontFamily: 'Readex Pro',
          color: Colors.white, // 폰트 색상을 명시적으로 설정
          fontSize: 25,
          fontWeight: FontWeight.w600,
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // 아이콘 색상
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice['date']!,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              notice['content1']!,
              style: TextStyle(fontSize: 25),
            ),
            Divider(
              color: Colors.grey,  // 회색 줄
              thickness: 1,        // 줄 두께
              height: 20,          // 줄 위아래 간격
            ),
            Text(
              notice['content2']!,
              style: TextStyle(fontSize: 25),
            ),
            Divider(
              color: Colors.grey,  // 회색 줄
              thickness: 1,        // 줄 두께
              height: 20,          // 줄 위아래 간격
            ),
            Text(
              notice['content3']!,
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
