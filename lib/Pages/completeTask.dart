import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo2/Model/type.dart';
import 'package:http/http.dart' as http;

class TaskCompleted extends StatefulWidget {
  const TaskCompleted({super.key});

  @override
  State<TaskCompleted> createState() => _TaskCompletedState();
}

class _TaskCompletedState extends State<TaskCompleted> {
  List<TaskValue> _userList = [];
  List<TaskValue> _userListComp = [];
  bool isLoading = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final url =
      Uri.https('todo-3737d-default-rtdb.firebaseio.com', 'user-list.json');

  // final _userService = UserService();
  readValueTable() async {
    
    print(currentUser!.email);
    setState(() {
      isLoading = true;
    });
    print('read function active');
    // var value = await _userService.readAllTask();
    _userList = <TaskValue>[];
    var response = await http.get(url);
    print(response.statusCode);
    print(response.body);
    if (response.body == 'null') {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> dataValue = jsonDecode(response.body);
    for (final item in dataValue.entries) {
      List<TaskValue> dumyList = [];
      dumyList.add(
        TaskValue(
          key: item.key,
          status: item.value['taskStatus'],
          task: item.value['task'],
          email: item.value['email'],
        ),
      );
      dumyList.forEach((element) {
        if (element.email == currentUser!.email && element.status == 1) {
          _userList.add(element);
        } else {}
      });
    }
    // print(value);
    // value.forEach((userValue) {
    //   setState(() {
    //     // Converting list into map formate
    //     var userValuelist = TaskValue();
    //     userValuelist.status = userValue['status'];
    //     userValuelist.taskId = userValue['taskId'];
    //     userValuelist.task = userValue['task'];
    //     if(userValue['status']==1){
    //       _userListComp.add(userValuelist);
    //     }
    //     else{
    //       _userList.add(userValuelist);
    //     }

    //   });
    // });
    print(_userList.length);
    setState(() {
      print("Setstate called");
      _userListComp = _userList;
      isLoading = false;
    });
   
    print('read function active');
    // var value = await _userService.readAllTask();
    _userList = <TaskValue>[];
    // print(value);
    // value.forEach((userValue) {
    //   setState(() {
    //     // Converting list into map formate
    //     var userValuelist = TaskValue();
    //     userValuelist.status = userValue['status'];
    //     userValuelist.taskId = userValue['taskId'];
    //     userValuelist.task = userValue['task'];
    //     if(userValue['status']==1){
    //       _userListComp.add(userValuelist);
    //     }
    //     else{
    //       _userList.add(userValuelist);
    //     }
         
    //   });
    // });
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    readValueTable();
  }
  checkbox(value, index, String? task,String? email) async{
    print(value);
    setState(() {
      final url = Uri.https(
          'todo-3737d-default-rtdb.firebaseio.com', 'user-list/${index}.json');
      if (value == 1) {
        http.put(
          url,
          body: json.encode(
            {
              'taskStatus': 1,
              'task': task,
              'email': email,
            },
          ),
        );
      } else {
        http.put(
          url,
          body: json.encode(
            {
              'taskStatus': 0,
              'task': task,
              'email': email,
            },
          ),
        );
      }
    });
    await readValueTable();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body:isLoading
              ? Center(
                  child: Lottie.asset('assets/gif/todo_loading.json'),
                ): _userListComp.isNotEmpty
          ?  
              SingleChildScrollView(
                child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                    itemCount: _userListComp.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 20,
                        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: ListTile(
                          title: Row(
                            children: [
                              Checkbox(
                                value: _userListComp[index].status == 0 ? false : true,
                                onChanged: (value) =>checkbox(value,_userListComp[index].key!,_userListComp[index].task,_userListComp[index].email) ,
                              ),
                              Flexible(child: Text(
                                _userListComp[index].task!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),),
                              
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ):
          
          emptyListPop(),
    );
  }
  }
  Widget emptyListPop() {
    return Center(
      child: Container(
        width: 350,
        height: 150,
        color: Colors.redAccent,
        child: const Center(
            child: Text(
          'There is no completed task',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
  