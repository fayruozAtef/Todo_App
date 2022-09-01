import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {




  var scaffoldKey= GlobalKey<ScaffoldState>();

  var formKey= GlobalKey<FormState>();




  var titleControler=TextEditingController();
  var timeControler=TextEditingController();
  var dateControler=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context,AppStates state) {
          if(state is AppInsertDataBaseState){
            Navigator.pop(context);
          }

        },
        builder: (BuildContext context, AppStates state)
        {
          AppCubit cubitItem = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                '${cubitItem.titles[cubitItem.currentIndex]}',
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppInitialState,
              builder: (context) => cubitItem.screenes[cubitItem.currentIndex],
              fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubitItem.isButtomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubitItem.insertToDatabase(
                        title: titleControler.text,
                        date: dateControler.text,
                        time: timeControler.text);
                    cubitItem.currentIndex=0;
                  }
                }
                else {
                    scaffoldKey.currentState!
                        .showBottomSheet((context) =>
                        Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //Take title
                                TextFormField(
                                  controller: titleControler,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'You have to type a title';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    label: Text('Task Title'),
                                    prefixIcon: Icon(Icons.title_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                //Take time
                                TextFormField(
                                  controller: timeControler,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'You have to choose time';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    label: Text('Pick Time'),
                                    prefixIcon:
                                    Icon(Icons.watch_later_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      if (value != null) {
                                        timeControler.text =
                                            value.format(context).toString();
                                        print(value.format(context));
                                      }
                                    });
                                  },
                                ),

                                const SizedBox(
                                  height: 10.0,
                                ),
                                //Take Date
                                TextFormField(
                                  controller: dateControler,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'You have to choose date';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    label: Text('Pick Date'),
                                    prefixIcon:
                                    Icon(Icons.calendar_today_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100))
                                        .then((value) {
                                      if (value != null) {
                                        dateControler.text = DateFormat.yMMMd()
                                            .format(value)
                                            .toString();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ))
                        .closed
                        .then((value) {
                      // دى علشان لما يقفل من الرجوع بتاع الموبيل ميبوظش الدنيا
                      cubitItem.changeBottomSheetState(
                          nIcon: Icons.edit, isShow: false);
                      timeControler.text = '';
                      titleControler.text = '';
                      dateControler.text = '';
                    });
                    cubitItem.changeBottomSheetState(
                        nIcon: Icons.add, isShow: true);
                  }
                },
              child: Icon(cubitItem.icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },

      ),
    );
  }
  Future<String> getName() async{
    return '';
  }




}