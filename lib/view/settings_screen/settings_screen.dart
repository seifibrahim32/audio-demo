import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/core/extensions/extensions.dart';
import 'package:itargs_task/core/static/styles.dart';
import 'package:itargs_task/generated/l10n.dart';
import 'package:itargs_task/view_model/di/di_utils.dart';
import 'package:itargs_task/view_model/providers/brightness_cubit.dart';
import 'package:itargs_task/view_model/providers/languages_cubit.dart';
import 'package:itargs_task/models/provider_models/states/brightness_states.dart';
import 'package:itargs_task/models/provider_models/states/languages_states.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BrightnessCubit>.value(
          value: sl<BrightnessCubit>(),
        ),
        BlocProvider<LanguagesCubit>.value(
          value: sl<LanguagesCubit>(),
        )
      ],
      child:
          BlocBuilder<BrightnessCubit, BrightnessStates>(builder: (ctx, state) {
        return Scaffold(
          backgroundColor: state.isDark ? const Color(0xFF121012) : Colors.white,
          body: ListView(children: [
            40.hp,
            //Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Directionality(
                  textDirection: S.of(ctx).lang =="en"?
                  TextDirection.ltr
                      :TextDirection.rtl,
                  child: Text(S.of(context).settings,
                      style: state.isDark ? kDarkHeaderStyle : kHeaderStyle)),
            ),
            5.hp,
            Container(height: 1, color: Colors.grey),
            //Dark Mode
            Container(
                color: state.isDark ? const Color(0xFF121012) : Colors.white,
                child: Directionality(
                  textDirection: S.of(ctx).lang =="en"?
                  TextDirection.ltr :TextDirection.rtl,
                  child: ListTile(
                    title: Text(S.of(context).dark_mode,
                        style: state.isDark ? kDarkListStyle : kListStyle),
                    trailing: Switch(
                      activeColor: Colors.purple,
                      activeTrackColor: Colors.purple,
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      splashRadius: 50.0,
                      value: state.isDark,
                      onChanged: (value) {
                        BlocProvider.of<BrightnessCubit>(ctx).toggle(value);
                      },
                    ),
                  ),
                )
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width - 30,
                    color: state.isDark ? Colors.white : Colors.grey),
              ],
            ),
            Directionality(
              textDirection: S.of(ctx).lang =="en"?TextDirection.ltr
                      :TextDirection.rtl,
              child: Container(
                  color: state.isDark ? const Color(0xFF121012) : Colors.white,
                  child: ListTile(
                    title: Text(S.of(context).arabic_language,
                        style: state.isDark ? kDarkListStyle : kListStyle),
                    trailing: BlocBuilder<LanguagesCubit,LanguageChangeState>(
                      builder: (ctx,state) {
                        return Switch(
                          activeColor: Colors.purple,
                          activeTrackColor: Colors.purple,
                          inactiveThumbColor: Colors.blueGrey.shade600,
                          inactiveTrackColor: Colors.grey.shade400,
                          splashRadius: 10.0,
                          value: state.lang == "ar",
                          onChanged: (value) {
                            BlocProvider.of<LanguagesCubit>(ctx)
                                .changeLanguage(value);
                          },
                        );
                      }
                    ),
                  )),
            ),
            Container(height: 1, color: Colors.grey),
          ]),
        );
      }),
    );
  }
}
