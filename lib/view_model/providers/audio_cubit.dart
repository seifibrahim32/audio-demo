import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/view_model/repository/network/network_repo.dart';
import 'package:itargs_task/models/provider_models/states/audio_states.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerCubit extends Cubit<AudioStates> {
  final subscription = Connectivity();

  AudioPlayer player = AudioPlayer();
  NetworkRepository repositoryNetwork = NetworkRepository();

  List<int> endpoints = [1, 2];

  List<int> indicies = [];
  int currentIndex = 0;

  AudioPlayerCubit(super.initialState) {
    checkInternet();
  }

  checkInternet() async {
    subscription.onConnectivityChanged.listen((event) async {
      switch (event) {
        case ConnectivityResult.bluetooth:
        case ConnectivityResult.wifi:
        case ConnectivityResult.ethernet:
        case ConnectivityResult.mobile:
        case ConnectivityResult.vpn:
          emit(const InternetCheckingState(isConnected: true));
        case ConnectivityResult.none:
          emit(const InternetCheckingState(isConnected: false));
        case ConnectivityResult.other:
          emit(const InternetCheckingState(isConnected: false));
          break;
      }
    });
  }

  startAudio(int index) async {
    indicies.add(index-1);
    emit(AudioIsLoadingState(isConnected: state.isConnected));
    if (state.isConnected) {
      getAudioFromApi(index);
    } else {
      getCachedAudio(index);
    }
  }

  getAudioFromApi(int index) async {
    var audioLink = await repositoryNetwork.getAudio(index);
    audioLink.fold((url) async {
      await player.stop();
      await player.play(UrlSource(url!));
      player.onPlayerComplete.listen((event) {
        emit(AudioIsFinishedState(isConnected: state.isConnected));
      });
      emit(AudioIsPlayingState(isConnected: state.isConnected));
    }, (r) {
      debugPrint("Data isn't fetched");
    });
  }

  getCachedAudio(int index) async {
    emit(AudioIsLoadingState(isConnected: state.isConnected));
    String audioAsset = "assets/$index.mp3";
    Uri uri = await player.audioCache.load(audioAsset);
    player.onPlayerComplete.listen((event) {
      emit(AudioIsFinishedState(isConnected: state.isConnected));
    });
    Uint8List? audioBytes = uri.data?.contentAsBytes();
    await player.play(BytesSource(audioBytes!));
  }

  resumeAudio(int index) async {
    await player.resume();
    emit(AudioIsPlayingState(isConnected: state.isConnected));
  }

  disableAudio(int index) async {
    await player.pause();
    emit(AudioPausedState(isConnected: state.isConnected));
  }
}
