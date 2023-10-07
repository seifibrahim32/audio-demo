import 'package:dio/dio.dart';
import 'package:itargs_task/models/entities/quran_model.dart';
import 'package:dartz/dartz.dart';

class NetworkModel {
  static final _dio = Dio();
  late Response _res;

  Future<Either<String?, bool>> fetchData(String url) async {
    _res = await _dio.get(url);
    var model = QuranModel.fromJson(_res.data);
    if (_res.statusCode == 200) {
      return Left(model.audioFile?.audioUrl!);
    } else {
      return const Right(false);
    }
  }
}
