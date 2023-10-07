import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/models/provider_models/states/brightness_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessCubit extends Cubit<BrightnessStates> {
  BrightnessCubit(super.initialState) {
    getCachedBrightnessData();
  }

  bool isDark = false;

  void getCachedBrightnessData() async {
    var cachedBrightness = await SharedPreferences.getInstance();
    if (cachedBrightness.containsKey('darkMode')) {
      isDark = cachedBrightness.get('darkMode') as bool;
      if (isDark) {
        emit(DarkState(isDark: isDark));
      } else {
        emit(LightState(isDark: isDark));
      }
    } else {
      emit(DarkState(isDark: isDark));
    }
  }

  void toggle(bool value) async {
    var cachedBrightness = await SharedPreferences.getInstance();
    cachedBrightness.setBool("darkMode", value);
    isDark = value;
    if (isDark) {
      emit(DarkState(isDark: isDark));
    } else {
      emit(LightState(isDark: isDark));
    }
  }

  @override
  Future<Function> close() async {
    return () {
      super.close();
    };
  }
}
