import 'dart:ffi';
import 'dart:ui';
import 'package:logging/logging.dart';

int? userId;
final Logger logger = Logger('MyLogger');
const Color mainColor = Color(0xFF3E4466); // 어두운색: 0xFF3E4466, 밝은색: 0xFF6B7A9A, 중간색: 0xE114358C
String? Status;