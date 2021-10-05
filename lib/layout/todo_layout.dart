import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                      onPressed: () {
                        cubit.changeTheme();
                      },
                      icon: const Icon(Icons.brightness_4))
                ],
                title: Row(
                  children: [
                    Text(cubit.title[cubit.currentIndex]),
                    Icon(cubit.iconTitle[cubit.currentIndex]),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isShown) {
                    if (formKey.currentState!.validate()) {
                      cubit
                          .insertToDatabase(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text)
                          .then((value) {
                        Navigator.pop(context);
                        cubit.changeBottomSheet(
                            isShow: false, icon: Icons.edit);
                        BotToast.showSimpleNotification(
                            title: "New task is added successfully",
                            backgroundColor: Colors.deepOrange,
                            titleStyle: GoogleFonts.aladin(
                                color: Colors.white, fontSize: 25),
                            duration: Duration(seconds: 2),
                            align: Alignment.bottomCenter);
                      });
                    }
                  } else {
                    cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                  }

                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: CacheHelper.getData(key: 'theme')
                                ? Colors.black
                                : Colors.grey[200],
                            padding: const EdgeInsets.all(10),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultForm(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      label: "Task title",
                                      prefix: Icons.title,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return "Title must not be empty";
                                        } else {
                                          return null;
                                        }
                                      }),
                                  const SizedBox(height: 10),
                                  defaultForm(
                                      controller: dateController,
                                      type: TextInputType.datetime,
                                      label: "Date",
                                      prefix: Icons.date_range,
                                      readOnly: true,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return "Date must not be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.utc(2030))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(value!);
                                        });
                                      }),
                                  const SizedBox(height: 10),
                                  defaultForm(
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      label: "Time",
                                      prefix: Icons.timelapse,
                                      readOnly: true,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return "Time must not be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context);
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                },
                child: Icon(cubit.iconF),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_box), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "Archive")
                ],
              ),
              body: state is! AppGetDatabaseLoading
                  ? cubit.body[cubit.currentIndex]
                  : const Center(child: CircularProgressIndicator()));
        },
        listener: (BuildContext context, AppStates state) {});
  }
}
