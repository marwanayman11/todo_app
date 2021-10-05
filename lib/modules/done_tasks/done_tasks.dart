import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return AppCubit.get(context).doneTasks.isNotEmpty
            ? taskView(t: AppCubit.get(context).doneTasks.asMap())
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_box,
                      size: 200,
                      color: Colors.green,
                    ),
                    Text("No done tasks yet",
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
