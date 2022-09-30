import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
class DoneTasks extends StatefulWidget {
  const DoneTasks({Key? key}) : super(key: key);
  @override
  State<DoneTasks> createState() => _DoneTasksState();
}
class _DoneTasksState extends State<DoneTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoCubitStates>(
      listener:(context,state){},
      builder:(context,state) {
        var cubit = TodoCubit.get(context);
        var tasks = cubit.doneTasks;
        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              'Done Tasks',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
              ),
            ),
          );
        }
        else {
          return ListView.separated(
              itemBuilder: (context, index) => builtTaskItem(tasks[index],context),
              separatorBuilder: (context, index) =>
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.grey,
                    width: double.infinity,
                    height: 1,
                  ),
              itemCount: tasks.length
          );
        }
      },
    );
  }
}