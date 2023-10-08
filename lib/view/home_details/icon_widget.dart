import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/models/provider_models/states/audio_states.dart';
import 'package:itargs_task/view_model/di/di_utils.dart';
import 'package:itargs_task/view_model/providers/audio_cubit.dart';

class IconWidget extends StatelessWidget {

  final int index;
  const IconWidget(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AudioPlayerCubit>(),
      child: BlocBuilder<AudioPlayerCubit, AudioStates>(
        bloc: sl<AudioPlayerCubit>(),
        builder: (ctx, state) {
          var bloc = BlocProvider.of<AudioPlayerCubit>(ctx);
          if (state is AudioIsLoadingState && bloc.currentPlayingIndex == index) {
            return const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            );
          }
          if (state is AudioIsPlayingState && bloc.currentPlayingIndex == index) {
            return Image.asset('assets/Play/Pause.png');
          } else {
            return Image.asset('assets/Play/icPlay Copy.png');
          }
        },
      ),
    );
  }
}
