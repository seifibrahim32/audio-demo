import 'package:equatable/equatable.dart';

class AudioStates extends Equatable {
  final bool isConnected;

  const AudioStates({required this.isConnected});

  @override
  List<Object?> get props => [isConnected];
}

class InternetCheckingState extends AudioStates {
  @override
  bool get isConnected;

  const InternetCheckingState(
      {required bool isConnected})
      : super(isConnected: isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class AudioIsLoadingState extends AudioStates {

  @override
  bool get isConnected;

  const AudioIsLoadingState(
      {required bool isConnected})
      : super(isConnected: isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class AudioIsPlayingState extends AudioStates {

  @override
  bool get isConnected;

  const AudioIsPlayingState({required bool isConnected})
      : super(isConnected: isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class AudioPausedState extends AudioStates {

  @override
  bool get isConnected;

  const AudioPausedState({required bool isConnected,})
      : super(isConnected: isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class AudioIsFinishedState extends AudioStates {

  @override
  bool get isConnected;

  const AudioIsFinishedState(
      {required bool isConnected})
      : super(isConnected: isConnected);

  @override
  List<Object?> get props => [isConnected];
}