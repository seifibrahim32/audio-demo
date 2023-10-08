import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/view_model/repository/network/network_repo.dart';
import 'package:itargs_task/models/provider_models/states/audio_states.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerCubit extends Cubit<AudioStates> {
  final subscription = Connectivity();

  AudioPlayer player = AudioPlayer();
  NetworkRepository repositoryNetwork = NetworkRepository();

  // Surat ElFateha - Surat ElFalak
  List<int> endpoints = [1, 113];

  int currentPlayingIndex = -1;

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

  startAudio(int endpointIndex) async {
    await player.stop();
    if(endpointIndex == 113){
      // If it is surat Al-Falaq
      currentPlayingIndex = 1;
    }
    else {
      currentPlayingIndex = endpointIndex - 1;
    }
    emit(AudioIsLoadingState(isConnected: state.isConnected));
    if (state.isConnected) {
      getAudioFromApi(endpointIndex);
    } else {
      getCachedAudio(endpointIndex);
    }
  }

  getAudioFromApi(int endpointIndex) async {
    var audioLink = await repositoryNetwork.getAudio(endpointIndex);
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

  getCachedAudio(int endpointIndex) async {

    await player.stop();
    debugPrint("Cached Audio");
    String audioAsset = "/data/user/0/com.example.itargs_task/cache/$endpointIndex.mp3";
    await player.play(DeviceFileSource(audioAsset));
    player.onPlayerComplete.listen((event) async{
      await player.stop();
      emit(AudioIsFinishedState(isConnected: state.isConnected));
    });
    emit(AudioIsPlayingState(isConnected: state.isConnected));
  }

  resumeAudio(int endpointIndex) async {
    await player.resume();
    emit(AudioIsPlayingState(isConnected: state.isConnected));
  }

  disableAudio(int endpointIndex) async {
    await player.pause();
    emit(AudioPausedState(isConnected: state.isConnected));
  }
}
