//import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived.dart';
import 'package:todo/modules/done.dart';
import 'package:todo/modules/new.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/states.dart';

class TodoCubit extends Cubit<TodoCubitStates> {
  TodoCubit() : super(TodoInitState());
  static TodoCubit get(context) => BlocProvider.of(context);
  Database? database;
  var fabIcon = Icons.edit;
  bool bottomSheetShow = false;
  int screenIndex = 0;
  List<Widget> screens = const [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<Widget> titles = const [
    Text('New Tasks'),
    Text('Done Tasks'),
    Text('Archived Tasks'),
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(index) {
    screenIndex = index;
    emit(ChangeIndexState());
  }

  void createDatabase() {
    openDatabase('Todo.db', version: 1, onCreate: (database, version) {
      print('DataBase Created');
      database
          .execute(
              'create table Tasks(id INTEGER PRIMARY KEY,title TEXT , date TEXT , time TEXT , status TEXT)')
          .then((value) {
        print('Table Created');
      }).catchError((error) {
        print('Error occur : $error');
      });
    }, onOpen: (database) {
      getData(database);
      print('Database opened');
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    }).catchError((error) {
      emit(ErrorCreateDatabaseState());
    });
  }

  Future<void> insertDatabase(
      {required String title,
      required String date,
      required String time}) async {
    database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
          print('$value Inserted Successfully');
          emit(InsertDatabaseState());
          getData(database);
      }).catchError((error) {
        print('Error occur : $error');
        emit(ErrorInsertDatabaseState());
      });
    });
  }

  void getData(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks  =[];
    database!.rawQuery('select * from Tasks').then((value) {
      value.forEach((element) {
        if(element['status']=='new')
          {
              newTasks.add(element);
          }
        else if(element['status']=='done')
          {
             doneTasks.add(element);
          }
        else{
          archivedTasks.add(element);
        }
      });
      emit(GetDatabaseState());
    }).catchError((error) {
      print('Error occur no data');
      emit(ErrorGetDatabaseState());
    });
  }

  void changeFBAIcon({required bool isShow, required IconData icon}) {
    bottomSheetShow = isShow;
    fabIcon = icon;
    emit(ChangeIconState());
  }

  void updateData({required String status, required int id}) async {
    database!.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getData(database);
      emit(UpdateStatusState());
    });
  }

  void deleteData({required int id})async
  {
      await database!.rawDelete(
          'DELETE FROM Tasks WHERE id= ?', [id])
          .then((value){
            getData(database);
            emit(DeleteDataState());
      });
  }
}
