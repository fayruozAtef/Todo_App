import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import '../../modules/archive_tasks/archive_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';

import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  bool isButtomSheet=false;

  IconData icon =Icons.edit;

  int currentIndex=0;

  List<Map> newTasks=[];
  List<Map> archiveTasks=[];
  List<Map> doneTasks=[];

  List<Widget> screenes=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  List<String> titles=[
    'Todo Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  Database? database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (datebase, version){
        print('database is created');
        datebase.execute(
          ' CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)',
        )
            .then((value) => print('tableCreated successfully'))
            .catchError((error){
          "error found ${error.toString()}";
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        print('database is opened');
      },
    ).then((value) {
      database=value;
      emit(AppCreateDataBaseState());
    });
  }

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeButtonNavBarState());
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async{
     await database?.transaction((txn) async{
      txn.rawInsert('INSERT INTO tasks(title , date, time, status) VALUES ( "${title}"  , "${date}" ,"${time}" , "new")').
      then((value) {
        print('$value Inserted Sucessfully');
        emit(AppInsertDataBaseState());

        getDataFromDatabase(database);
      });
    }).
    catchError((onError){
      print('Error in insertion ${onError.toString()}');
    });
  }

  void getDataFromDatabase(datebase) {

    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(AppGetDataBaseLoadingState());

    datebase.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element){
        if(element['status']=='new')
          newTasks.add(element);
        else if(element['status']=='done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void changeBottomSheetState({
  required IconData nIcon,
  required bool isShow,}){
    isButtomSheet=isShow;
    icon=nIcon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({required String status , required int id}) async{
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',["$status",id]).
    then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    }) ;
  }

  void deleteData({required int nId}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ? ',[nId]).
    then((value){
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }
}