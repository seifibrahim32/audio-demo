import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/core/extensions/extensions.dart';
import 'package:itargs_task/core/static/styles.dart';
import 'package:itargs_task/generated/l10n.dart';
import 'package:itargs_task/models/provider_models/states/audio_states.dart';
import 'package:itargs_task/models/provider_models/states/favorites_states.dart';
import 'package:itargs_task/view/home_details/icon_widget.dart';
import 'package:itargs_task/view/home_details/internet/progress_bar_view.dart';
import 'package:itargs_task/view/snackbars/dialogs.dart';
import 'package:itargs_task/view_model/di/di_utils.dart';
import 'package:itargs_task/view_model/providers/audio_cubit.dart';
import 'package:itargs_task/view_model/providers/brightness_cubit.dart';
import 'package:itargs_task/models/provider_models/states/'
    'brightness_states.dart';
import 'package:itargs_task/view_model/providers/favorites_cubit.dart';

class HomeDetailsScreen extends StatefulWidget {
  const HomeDetailsScreen({super.key});

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  Widget get separatorWidget => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 30.0,
              color: Colors.grey),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioPlayerCubit>.value(
          value: sl<AudioPlayerCubit>(),
        ),
        BlocProvider<FavoritesCubit>.value(
          value: sl<FavoritesCubit>(),
        )
      ],
      child:
          BlocBuilder<BrightnessCubit, BrightnessStates>(builder: (ctx, state) {
        var isDark = BlocProvider.of<BrightnessCubit>(ctx).isDark;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF121012) : Colors.white,
          body: BlocBuilder<AudioPlayerCubit, AudioStates>(
              builder: (context, internetState) {
            return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ProgressBarHome(internetState),
                  40.hp,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Directionality(
                        textDirection: S.of(ctx).lang == "en"
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        child: Text(S.of(context).top_likes,
                            style: isDark ? kDarkHeaderStyle : kHeaderStyle)),
                  ),
                  5.hp,
                  // Top Likes List
                  Container(
                    color: isDark ? Colors.white : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 0.7),
                    child: Container(
                      color: isDark ? const Color(0xFF121212) : Colors.white,
                      child: BlocBuilder<FavoritesCubit, FavoritesStates>(
                          builder: (context, state) {
                        var bloc = BlocProvider.of<FavoritesCubit>(context);
                        var likes = bloc.likesModel;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Directionality(
                              textDirection: S.of(ctx).lang == "en"
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              child: Container(
                                  color: isDark
                                      ? const Color(0xFF121212)
                                      : Colors.white,
                                  child: ListTile(
                                      title: Text(likes[index].name,
                                          style: isDark
                                              ? kDarkListStyle
                                              : kListStyle),
                                      trailing: InkWell(
                                        onTap: () {
                                          bloc.changeLike(
                                              index, likes[index].isLiked!);
                                        },
                                        child: Icon(
                                          likes[index].isLiked!
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.redAccent,
                                        ),
                                      ))),
                            );
                          },
                          itemCount: likes.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return separatorWidget;
                          },
                        );
                      }),
                    ),
                  ),
                  40.hp,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Directionality(
                        textDirection: S.of(ctx).lang == "en"
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        child: Text(S.of(context).listen_audios,
                            style: isDark ? kDarkHeaderStyle : kHeaderStyle)),
                  ),
                  5.hp,
                  // Listen Audios
                  Container(height: 1, color: Colors.grey),
                  Container(
                    color: isDark ? const Color(0xFF121212) : Colors.white,
                    child: Directionality(
                      textDirection: S.of(ctx).lang == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: BlocBuilder<AudioPlayerCubit, AudioStates>(
                          builder: (context, state) {
                        var bloc = BlocProvider.of<AudioPlayerCubit>(context);
                        List<Widget> iconsList = List.generate(
                          bloc.endpoints.length,
                          (index) => IconWidget(index),
                        );
                        return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              minLeadingWidth: 5,
                              leading: GestureDetector(
                                  onTap: () {
                                    if (!state.isConnected) {
                                      showAlertDialog(
                                          S.of(context).error, context);
                                    } else if (state is AudioIsPlayingState ||
                                        bloc.currentPlayingIndex != index) {
                                      bloc.disableAudio(index);
                                      if(bloc.currentPlayingIndex != index){
                                        bloc.startAudio(bloc.endpoints[index]);
                                      }
                                    } else if (state is AudioPausedState) {
                                      bloc.resumeAudio(index);
                                    } else {
                                      bloc.startAudio(bloc.endpoints[index]);
                                    }
                                  },
                                  child: iconsList[index]),
                              title: Text(S.of(context).play_this,
                                  style: isDark ? kDarkListStyle : kListStyle),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return separatorWidget;
                          },
                          itemCount: bloc.endpoints.length,
                        );
                      }),
                    ),
                  ),
                  Container(height: 1, color: Colors.grey),
                ]);
          }),
        );
      }),
    );
  }
}
