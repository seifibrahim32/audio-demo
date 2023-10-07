import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:itargs_task/core/extensions/extensions.dart';
import 'package:itargs_task/core/static/styles.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:itargs_task/generated/l10n.dart';
import 'package:itargs_task/view/home_details/home_details_screen.dart';
import 'package:itargs_task/view/settings_screen/settings_screen.dart';
import 'package:itargs_task/view_model/di/di_utils.dart';
import 'package:itargs_task/view_model/providers/brightness_cubit.dart';
import 'package:itargs_task/view_model/providers/languages_cubit.dart';
import 'package:itargs_task/models/provider_models/states/brightness_states.dart';
import 'package:itargs_task/models/provider_models/states/languages_states.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupLocators().whenComplete(() {
    runApp(const HomeScreen());
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}
class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screensList = const [HomeDetailsScreen(), SettingsScreen()];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

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
      child: BlocBuilder<LanguagesCubit, LanguageChangeState>(
          builder: (context, state) {
        return MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Quran App',
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale(state.lang),
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: BlocBuilder<BrightnessCubit, BrightnessStates>(
            builder: (ctx, state) {
              var isDark = BlocProvider.of<BrightnessCubit>(ctx).isDark;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: isDark ? Colors.black26 : Colors.white,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size(13, 1),
                    child: Container(
                        color: isDark ? Colors.black12 : Colors.white,
                        height: 1.5),
                  ),
                  centerTitle: true,
                  title: Text(
                      currentIndex == 0
                          ? S.of(ctx).this_is_app
                          : S.of(ctx).more,
                      style: isDark ? kDarkCairoStyle : kCairoStyle),
                ),
                body: Stack(
                  children: [
                    // Either HomePage or the Settings screen..
                    currentIndex == 0 ? screensList[0] : screensList[1],
                    // Customized Navigation Bar...
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        elevation: 9,
                        color: isDark ? Colors.black : Colors.white,
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (currentIndex == 0)
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset('assets/Home/Home.png',
                                          scale: 1.2),
                                      Text(
                                        S.of(ctx).home,
                                        style: isDark
                                            ? kDarkBottomNavStyle
                                            : kBottomNavStyle,
                                      )
                                    ])
                              else
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = 0;
                                      });
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                            'assets/Home/Home_no selection.png',
                                            scale: 1.2),
                                        Text(
                                          S.of(ctx).home,
                                          style: isDark
                                              ? kDarkBottomNavStyle
                                              : kBottomNavStyle,
                                        )
                                      ],
                                    )),
                              75.wp,
                              if (currentIndex == 1)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/More/More.png'),
                                    Text(
                                      S.of(ctx).more,
                                      style: isDark
                                          ? kDarkBottomNavStyle
                                          : kBottomNavStyle,
                                    )
                                  ],
                                )
                              else
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = 1;
                                      });
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                            'assets/More/More_not selected.png'),
                                        Text(
                                          S.of(ctx).more,
                                          style: isDark
                                              ? kDarkBottomNavStyle
                                              : kBottomNavStyle,
                                        ),
                                      ],
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
