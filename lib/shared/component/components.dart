import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget rowOfData({
  required Map tasks,
  context
}) =>Dismissible(
  key: Key(tasks['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      textBaseline: TextBaseline.alphabetic,
      children: [
        const CircleAvatar(
          radius: 30.0,
          child: Icon(Icons.menu, size: 25.0,),
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${tasks['title']}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0,),
              Row(
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      '${tasks['date']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    '${tasks['time']}',
                    style:const  TextStyle(color: Colors.blue,fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 5.0,),
        IconButton(
          icon: const Icon(Icons.check_box_outlined),
          color: Colors.green,
          onPressed: (){
            AppCubit.get(context).updateData(status: 'done', id: tasks['id']);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.archive_outlined,
            color: Colors.blue,
          ),
          color: Colors.black26,
          onPressed: (){
            AppCubit.get(context).updateData(status: 'archive', id: tasks['id'],
            );
          },
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(nId: tasks['id']);
  },
);

Widget tasksBuilder({required List<Map> task})=>ConditionalBuilder(
  condition:task.length>0,
  builder: (BuildContext context) {
    return ListView.separated(
      itemBuilder: (context , index)=>rowOfData(
        tasks: task[index],
        context: context,
      ),
      separatorBuilder:(context, index)=> Container(
        color: Colors.grey[300],
        height: 3.0,
      ),
      itemCount: task.length,

    );
  },
  fallback: (BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu,
            color: Colors.grey,
            size: 80.0,
          ),
          Text(
            'No tasks yet, Please add some tasks.',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,

          ),
        ],
      ),
    );
  },

);