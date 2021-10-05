import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit.get(context).showNotifications();
        return AppCubit.get(context).newTasks.isNotEmpty
            ? taskView(t: AppCubit.get(context).newTasks.asMap())
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.list_alt_outlined,
                      size: 200,
                      color: Colors.grey,
                    ),
                    Text("No tasks yet , please add some tasks",
                        style: GoogleFonts.aladin(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: CacheHelper.getData(key: 'theme')
                                ? Colors.white
                                : Colors.black))
                  ],
                ),
              );
      },
      listener: (context, state) {},
    );
  }
}
