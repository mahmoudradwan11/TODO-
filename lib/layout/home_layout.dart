import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived.dart';
import 'package:todo/modules/done.dart';
import 'package:todo/modules/new.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import '../shared/components/constants.dart';
class HomeScreen extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context)=>TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit,TodoCubitStates>(
        listener:(BuildContext context,TodoCubitStates state){
          if(state is InsertDatabaseState)
            {
                Navigator.pop(context);
            }
        },
        builder:(context,state){
          var cubit = TodoCubit.get(context);
          return Scaffold(
            key:scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title:cubit.titles[cubit.screenIndex],
              backgroundColor: Colors.pink,
            ),
            body:cubit.screens[cubit.screenIndex],
            floatingActionButton: FloatingActionButton(
              child:Icon(
                cubit.fabIcon,
              ),
              onPressed:(){
                if(cubit.bottomSheetShow) {
                  if (formKey.currentState!.validate())
                  {
                    cubit.insertDatabase(
                        title:titleController.text,
                        date:dateController.text,
                        time: timeController.text,
                    );

                  }
                } else
                {
                  scaffoldKey.currentState!.showBottomSheet((context)=>
                      Container(
                        padding:const EdgeInsets.all(20.0),
                        color: Colors.grey[300],
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller:titleController,
                                keyboardType:TextInputType.text,
                                validator:(value){
                                  if(value.isEmpty)
                                  {
                                    return ' title is Required';
                                  }
                                  return null;
                                },
                                label:'Task Title',
                                prefixIcon: Icons.title,
                                hiddenPassword: false,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              defaultFormField(
                                  controller:timeController,
                                  keyboardType:TextInputType.datetime,
                                  validator:(value){
                                    if(value.isEmpty)
                                    {
                                      return ' time is Required';
                                    }
                                    return null;
                                  },
                                  label:'Task Time',
                                  prefixIcon: Icons.timelapse,
                                  hiddenPassword: false,
                                  onTap:(){
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    ).then((value){
                                      timeController.text = value!.format(context);
                                      print(timeController.text);
                                    });
                                  }
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              defaultFormField(
                                  controller:dateController,
                                  keyboardType:TextInputType.datetime,
                                  validator:(value){
                                    if(value.isEmpty)
                                    {
                                       return ' date is Required';
                                    }
                                    return null;
                                  },
                                  label:'Task Date',
                                  prefixIcon: Icons.date_range,
                                  hiddenPassword: false,
                                  onTap:(){
                                    showDatePicker(
                                        context: context,
                                        initialDate:DateTime.now(),
                                        firstDate:DateTime.now(),
                                        lastDate: DateTime.parse('2022-10-01')
                                    ).then((value){
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    });
                                  }
                              ),
                            ],
                          ),
                        ),
                      )
                  ).closed.then((value){
                    cubit.changeFBAIcon(isShow:false, icon: Icons.edit);
                  });
                  cubit.changeFBAIcon(isShow: true, icon:Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:cubit.screenIndex,
              onTap:(index){
                cubit.changeIndex(index);
              },
              elevation: 0.0,
              items:const[
                BottomNavigationBarItem(
                    icon:Icon(
                        Icons.task
                    ),
                    label:'Tasks'
                ),
                BottomNavigationBarItem(
                    icon:Icon(
                        Icons.done
                    ),
                    label:'Done'
                ),
                BottomNavigationBarItem(
                    icon:Icon(
                        Icons.archive
                    ),
                    label:'Archive'
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}



