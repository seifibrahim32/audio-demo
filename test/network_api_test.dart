// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const path = 'http://api.quran.com/api/v4/chapter_recitations/1/';
  group('Tests', () {
    final dio = Dio(BaseOptions());
    final dioAdapter = DioAdapter(dio: dio);

    List<int> endpoints = [1, 2];
    test('Test 1: First item', () {
      dioAdapter.onGet(
        path + endpoints[0].toString(),
        (server) => server.reply(
          200,
          {'message': 'Success!'},
          delay: const Duration(seconds: 1),
        ),
      );
    });

    test('Test 2: Second item', () {
      dioAdapter.onGet(
        path + endpoints[1].toString(),
        (server) => server.reply(
          200,
          {'message': 'Success!'},
          delay: const Duration(seconds: 1),
        ),
      );
    });
  });
}
