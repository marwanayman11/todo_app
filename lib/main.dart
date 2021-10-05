import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/layout/todo_layout.dart';
import 'package:todo_app/modules/onboarding/onboarding.dart';
import 'package:todo_app/shared/network/local/bloc_observer.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/network/local/notifications.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await NotificationsView.initState();
  bool onBoarding = false;
  Widget onStart = OnBoardingScreen();
  if (CacheHelper.getData(key: 'theme') == null) {
    CacheHelper.saveData(key: 'theme', value: false);
    CacheHelper.getData(key: 'theme');
  } else {
    CacheHelper.getData(key: 'theme');
  }
  if (CacheHelper.getData(key: 'onBoarding') == null) {
    CacheHelper.saveData(key: 'onBoarding', value: false);
    onBoarding = CacheHelper.getData(key: 'onBoarding');
  } else {
    onBoarding = CacheHelper.getData(key: 'onBoarding');
    if (onBoarding == false) {
      onStart = OnBoardingScreen();
    } else {
      onStart = HomeLayout();
    }
  }

  runApp(MyApp(onStart));
}

class MyApp extends StatelessWidget {
  final Widget onStart;

  const MyApp(this.onStart, {Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    color: Colors.white,
                    titleTextStyle: GoogleFonts.aladin(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  primarySwatch: Colors.blue,
                  floatingActionButtonTheme:
                      const FloatingActionButtonThemeData(
                    backgroundColor: Colors.blue,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      selectedLabelStyle: GoogleFonts.aladin(),
                      unselectedLabelStyle: GoogleFonts.aladin(),
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.grey)),
              darkTheme: ThemeData(
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    color: Colors.black,
                    titleTextStyle: GoogleFonts.aladin(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                  ),
                  scaffoldBackgroundColor: Colors.black,
                  primarySwatch: Colors.blue,
                  floatingActionButtonTheme:
                      const FloatingActionButtonThemeData(
                    backgroundColor: Colors.blue,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      selectedLabelStyle: GoogleFonts.aladin(),
                      unselectedLabelStyle: GoogleFonts.aladin(),
                      backgroundColor: Colors.black,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.grey)),
              debugShowCheckedModeBanner: false,
              themeMode: CacheHelper.getData(key: 'theme')
                  ? ThemeMode.dark
                  : ThemeMode.light,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: onStart,
            );
          }),
    );
  }
}
