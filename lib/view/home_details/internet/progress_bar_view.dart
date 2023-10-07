import 'package:flutter/material.dart';
import 'package:itargs_task/core/static/styles.dart';
import 'package:itargs_task/models/provider_models/states/audio_states.dart';

class ProgressBarHome extends StatelessWidget {

  final AudioStates internetState;
  const ProgressBarHome(this.internetState,{super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: internetState.isConnected? true : false,
      replacement: const LinearProgressIndicator(
        color: Colors.red,
        backgroundColor: Colors.blue,
        minHeight: 15,
      ),
      child: Dismissible(
        key: UniqueKey(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 26,
          color: Colors.green[400],
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Internet is connected",
                  style: kNotConnected,
                )
              ]),
        ),
      ),
    );
  }
}
