import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:itargs_task/models/networks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:internet_file/internet_file.dart';

class NetworkRepository {
  static const String url = "https://api.quran.com/api/v4/"
      "chapter_recitations/1/";

  String? audioURL;

  NetworkModel networkModel = NetworkModel();

  Future<Either<String?, bool>> getAudio(int endpoint) async {
    await networkModel.fetchData("$url${endpoint.toString()}").then((value) {
      value.fold((url) {
        audioURL = url!;
      }, (r) {});
    });

    if (audioURL != null) {
      Uint8List bytes = await InternetFile.get(
        audioURL!,
        progress: (progress, finishingPercent) {
          if (kDebugMode) {
            print('downloadPercentage: $progress/$finishingPercent');
          }
        },
      );
      await getTemporaryDirectory().then((value) async {
        File file = File('${value.path.trim()}/$endpoint.mp3');
        debugPrint("temp path : ${file.path}");
        await file
            .writeAsBytes(bytes)
            .whenComplete(() => debugPrint("written file path : ${file.path}"));
      });
      return Left(
        audioURL,
      );
    } else {
      return const Right(false);
    }
  }
}
