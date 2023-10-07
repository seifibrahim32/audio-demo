import 'package:get_it/get_it.dart';
import 'package:itargs_task/models/provider_models/states/audio_states.dart';
import 'package:itargs_task/models/provider_models/states/favorites_states.dart';
import 'package:itargs_task/view_model/providers/audio_cubit.dart';
import 'package:itargs_task/view_model/providers/brightness_cubit.dart';
import 'package:itargs_task/view_model/providers/favorites_cubit.dart';
import 'package:itargs_task/view_model/providers/languages_cubit.dart';
import 'package:itargs_task/models/provider_models/states/brightness_states.dart';
import 'package:itargs_task/models/provider_models/states/languages_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future setupLocators() async {
  sl.registerSingleton<AudioPlayerCubit>(AudioPlayerCubit(
      const InternetCheckingState(isConnected: false)));
  sl.registerSingleton<BrightnessCubit>(
      BrightnessCubit(const LightState(isDark: false)));
  sl.registerSingleton<FavoritesCubit>(
      FavoritesCubit(const FavoritesStates(isLiked: false)));

  sl.registerSingleton<Future<SharedPreferences>>(
      SharedPreferences.getInstance());
  await sl<Future<SharedPreferences>>().then((prefs) {
    String defaultLang = "en";
    if (!prefs.containsKey("lang")) {
      prefs.setString("lang", defaultLang);
    } else {
      defaultLang = prefs.getString("lang")!;
    }
    sl.registerSingleton<LanguagesCubit>(LanguagesCubit(LanguageChangeState(
      lang: defaultLang,
    )));
  });
}
