import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/network/local/notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;
  List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int currentIndex = 0;
  List<Widget> body = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks()
  ];
  List<String> title = ["New tasks ", "Done tasks ", "Archived tasks "];
  List<IconData> iconTitle = [
    Icons.menu,
    Icons.check_box,
    Icons.archive_outlined
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavBarState());
  }

  void createDatabase() {
    openDatabase("todo.db", version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print("table is created");
      }).catchError((error) {
        print("error while creating table : $error");
      });
    }, onOpen: (database) {
      print("database is open");
      getDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  insertToDatabase({required title, required date, required time}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new") ')
          .then((value) {
        print("$value is inserted ");
        emit(AppInsertDatabase());
        getDatabase(database);
      }).catchError((error) {
        print("error while inserting : $error");
      });
      return null;
    });
  }

  updateDatabase({required int id, required String status}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDatabase(database);
      emit(AppGetDatabase());
    });
  }

  deleteFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDatabase(database);
      emit(AppDeleteFromDatabase());
    });
  }

  getDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      emit(AppGetDatabaseLoading());
      tasks = value;

      value.forEach((element) {
        if (element["status"] == "new") {
          newTasks.add(element);
        } else if (element["status"] == "done") {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabase());
    });
  }

  bool isShown = false;
  IconData iconF = Icons.edit;

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isShown = isShow;
    iconF = icon;
    emit(ChangeBottomSheetState());
  }

  bool theme = false;

  void changeTheme() {
    theme = !theme;
    CacheHelper.saveData(key: 'theme', value: theme).then((value) {
      emit(ChangeThemeState());
    });
  }

  void showNotifications() {
    newTasks.forEach((element) {
      var time;
      if ('HH:mm'.length == element['time'].length) {
        time = element['time'];
      } else {
        time = DateFormat('HH:mm')
            .format(DateFormat.jm().parse(element['time']))
            .toString();
      }
      DateTime date = DateTime.parse(element['date'] + " " + time);
      NotificationsView.displayNotification(
              task: element['title'], dateTime: date)
          .then((value) {
        if (date == tz.local) {
          emit(ShowNotificationsState());
        }
      });
    });
  }
}
