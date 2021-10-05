import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:bot_toast/bot_toast.dart';

Widget defaultForm(
        {context,
        required TextEditingController controller,
        required TextInputType type,
        required String label,
        required IconData prefix,
        IconData? suffix,
        bool isPassword = false,
        bool visible = false,
        Function? suffixPressed,
        required Function validate,
        Function? onSubmit,
        Function? onChange,
        Function? onTap,
        bool readOnly = false}) =>
    Card(
      elevation: 0,
      color: CacheHelper.getData(key: 'isDark') == true
          ? Colors.grey[900]
          : Colors.white,
      clipBehavior: Clip.none,
      child: Container(
        color:
            CacheHelper.getData(key: 'theme') ? Colors.grey[900] : Colors.white,
        child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            onFieldSubmitted: (value) => onSubmit!(value),
            onChanged: (value) => onChange!(value),
            validator: (value) => validate(value),
            onTap: () => onTap!(),
            keyboardType: type,
            obscureText: isPassword,
            style: GoogleFonts.aladin(
                color: CacheHelper.getData(key: 'theme')
                    ? Colors.white
                    : Colors.black),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
              prefixIcon: Icon(
                prefix,
                color: Colors.grey,
              ),
              suffixIcon: suffix != null
                  ? IconButton(
                      onPressed: () => suffixPressed!(), icon: Icon(suffix))
                  : null,
              labelStyle: GoogleFonts.aladin(
                  color: CacheHelper.getData(key: 'theme')
                      ? Colors.grey
                      : Colors.black),
            )),
      ),
    );
Widget taskView({required Map t, context}) => Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => Dismissible(
                key: Key(t[index]['id'].toString()),
                onDismissed: (direction) {
                  AppCubit.get(context).deleteFromDatabase(id: t[index]['id']);
                  BotToast.showSimpleNotification(
                      title: "Task is deleted successfully",
                      backgroundColor: Colors.red,
                      titleStyle: GoogleFonts.aladin(color: Colors.white,fontSize: 25),
                      duration: Duration(seconds: 2),
                      align: Alignment.bottomCenter);
                },
                child: Card(
                  elevation: 10,
                  color: CacheHelper.getData(key: 'theme')
                      ? Colors.grey[900]
                      : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.task,color: Colors.blue,),
                    title: Text(
                      "${t[index]["title"]}",
                      style: GoogleFonts.aladin(
                          color: CacheHelper.getData(key: 'theme')
                              ? Colors.white
                              : Colors.black,
                          fontSize: 25),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 15,
                            color: CacheHelper.getData(key: 'theme')
                                ? Colors.white
                                : Colors.black),
                        Text(
                          " ${t[index]["date"]}",
                          style: GoogleFonts.aladin(
                              color: Colors.grey, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.alarm,
                            size: 15,
                            color: CacheHelper.getData(key: 'theme')
                                ? Colors.white
                                : Colors.black),
                        Text(
                          " ${t[index]["time"]}",
                          style: GoogleFonts.aladin(
                              color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              AppCubit.get(context).updateDatabase(
                                  id: t[index]['id'], status: "done");
                              BotToast.showSimpleNotification(
                                  title:
                                      "Task is moved to done tasks successfully",
                                  backgroundColor: Colors.green,
                                  titleStyle:
                                      GoogleFonts.aladin(color: Colors.white,fontSize: 25),
                                  duration: Duration(seconds: 2),
                                  align: Alignment.bottomCenter);
                            },
                            icon: const Icon(
                              Icons.check_box,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              AppCubit.get(context).updateDatabase(
                                  id: t[index]['id'], status: "archived");
                              BotToast.showSimpleNotification(
                                  title:
                                      "Task is moved to archived tasks successfully",
                                  backgroundColor: Colors.blue,

                                  titleStyle:
                                      GoogleFonts.aladin(color: Colors.white,fontSize: 25),
                                  duration: Duration(seconds: 2),
                                  align: Alignment.bottomCenter);
                            },
                            icon: const Icon(
                              Icons.archive_outlined,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
          separatorBuilder: (context, index) => const SizedBox(
                width: double.infinity,
                height: 10,
              ),
          itemCount: t.length),
    );

void pushTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushToAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), ((route) => false));
}
