import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/view_model/di/di_utils.dart';
import 'package:itargs_task/models/provider_models/states/languages_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesCubit extends Cubit<LanguageChangeState> {
  String language = "en";

  LanguagesCubit(super.initialState) {
    initializeDefaultLanguage();
  }

  void initializeDefaultLanguage() async {
    final prefs = await sl<Future<SharedPreferences>>();
    if (prefs.containsKey("lang")) {
      language = prefs.getString("lang")!;
    }
  }

  void changeLanguage(bool value) async{
    language = value == true ? "ar" : "en";
    final prefs = await sl<Future<SharedPreferences>>();
    prefs.setString("lang",language);
    emit(LanguageChangeState(lang: language));
  }
}
