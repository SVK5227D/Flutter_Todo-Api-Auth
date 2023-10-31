// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:lottie/lottie.dart';
// import 'package:todo2/Model/type.dart'; // Assuming TaskValue is defined in 'task.dart'
// import 'package:http/http.dart' as http;

// class ListTask extends StatefulWidget {
//   const ListTask({Key? key}) : super(key: key);

//   @override
//   _ListTaskState createState() => _ListTaskState();
// }

// class _ListTaskState extends State<ListTask> {
//   final todoTask = TextEditingController();
//   var taskUpdate = TextEditingController();
//   List<TaskValue> _userList = [];
//   List<TaskValue> _searchList = [];
//   bool isLoading = false;
//   final url =
//       Uri.https('todo-3737d-default-rtdb.firebaseio.com', 'user-list.json');

//   User? currentUser = FirebaseAuth.instance.currentUser;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   // final _userService = UserService();

//   @override
//   void initState() {
//     super.initState();
//     readValueTable();
//   }

//   addTask() async {
//     await http.post(
//       url,
//       headers: {
//         'Content-type': 'application/json',
//         "uid": "dbba384f-8d05-41fe-aae5-804bbfda7b90",
//       },
//       body: json.encode(
//         {
//           'email': currentUser!.email,
//           'taskStatus': 0,
//           'task': todoTask.text,
//         },
//       ),
//     );
//     todoTask.clear();
//     // print("Add task function called");
//     // var taskInput = TaskValue();
//     // taskInput.status = 0;
//     // taskInput.task = todoTask.text;
//     // // await _userService.saveTask(taskInput);
//     // todoTask.text = '';
//     readValueTable();
//   }

//   // readValueTable() async {
//   //   _searchList = [];
//   //   _userList = [];
//   //   print(currentUser!.email);
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   print('read function active');
//   //   // var value = await _userService.readAllTask();
//   //   _userList = <TaskValue>[];
//   //   var response = await http.get(url);
//   //   print(response.statusCode);
//   //   print(response.body);
//   //   if (response.body == 'null') {
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     return;
//   //   }
//   //   final Map<String, dynamic> dataValue = jsonDecode(response.body);
//   //   for (final item in dataValue.entries) {
//   //     List<TaskValue> dumyList = [];
//   //     dumyList.add(
//   //       TaskValue(
//   //         key: item.key,
//   //         status: item.value['taskStatus'],
//   //         task: item.value['task'],
//   //         email: item.value['email'],
//   //       ),
//   //     );
//   //     dumyList.forEach((element) {
//   //       if (element.email == currentUser!.email && element.status == 0) {
//   //         _userList.add(element);
//   //       } else {}
//   //     });
//   //   }
//   //   // print(value);
//   //   // value.forEach((userValue) {
//   //   //   setState(() {
//   //   //     // Converting list into map formate
//   //   //     var userValuelist = TaskValue();
//   //   //     userValuelist.status = userValue['status'];
//   //   //     userValuelist.taskId = userValue['taskId'];
//   //   //     userValuelist.task = userValue['task'];
//   //   //     if(userValue['status']==1){
//   //   //       _userListComp.add(userValuelist);
//   //   //     }
//   //   //     else{
//   //   //       _userList.add(userValuelist);
//   //   //     }

//   //   //   });
//   //   // });
//   //   print(_userList.length);
//   //   _searchList = _userList;
//   //   if (mounted) {
//   //     setState(() {
//   //       print("Setstate called");
//   //       isLoading = false;
//   //     });
//   //   }
//   // }

//   readValueTable() async {
//     _searchList = [];
//     _userList = [];
//     // print(currentUser!.email);
//     setState(() {
//       isLoading = true;
//     });
//     print('read function active');

//     var response = await http.get(url);
//     print(response.statusCode);
//     print(response.body);

//     if (response.body == 'null') {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     final Map<String, dynamic> dataValue = jsonDecode(response.body);
//     _userList = dataValue.entries
//         .map((item) => TaskValue(
//               key: item.key,
//               status: item.value['taskStatus'],
//               task: item.value['task'],
//               email: item.value['email'],
//             ))
//         .where((element) =>
//             element.email == currentUser!.email && element.status == 0)
//         .toList();

//     print(_userList.length);
//     _searchList = _userList;

//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   _deleteValue(taskId) async {
//     print(taskId);
//     final url = Uri.https(
//         'todo-3737d-default-rtdb.firebaseio.com', 'user-list/$taskId.json');
//     await http.delete(url);
//     readValueTable();
//     if (_userList.isEmpty) {
//       emptyListPop();
//     }
//     Fluttertoast.showToast(
//       msg: 'Task removed',
//       gravity: ToastGravity.CENTER,
//       fontSize: 25,
//       backgroundColor: Colors.red,
//     );
//   }

//   checkbox(value, index, String? email, String? task) async {
//     print(value);
//     setState(() {
//       final url = Uri.https(
//           'todo-3737d-default-rtdb.firebaseio.com', 'user-list/${index}.json');
//       if (value == 0) {
//         http.put(
//           url,
//           body: json.encode(
//             {
//               'taskStatus': 1,
//               'task': task,
//               'email': email,
//             },
//           ),
//         );
//       } else {
//         _userList[index].status = 0;
//       }
//     });
//     await readValueTable();
//   }

//   _filter(String valueFind) {
//     List<TaskValue> searchDynamic = [];
//     if (valueFind.isEmpty) {
//       print('if condition called');
//       searchDynamic = _userList;
//     } else {
//       searchDynamic = _userList
//           .where((element) =>
//               element.task!.toLowerCase().contains(valueFind.toLowerCase()))
//           .toList();
//     }
//     setState(() {
//       _searchList = searchDynamic;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("check print");
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.yellowAccent,
//       body: isLoading
//           ? Center(
//               child: Lottie.asset('assets/gif/todo_loading.json'),
//             )
//           : _userList.isNotEmpty
//               ? SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     children: [
//                       searchBox(),
//                       Container(
//                         height: 550,
//                         child: ListWheelScrollView(

//                           itemExtent: 100,
//                           children: _searchList.map((item) {
//                           return buildTaskCard(item);
//                         }).toList(),
//                           //_searchList.map((item) {
//                           //   return Card(
//                           //     color: Colors.green[400],
//                           //     elevation: 20,
//                           //     margin: const EdgeInsets.only(
//                           //         top: 15, left: 15, right: 15),
//                           //     child: ListTile(
//                           //       title: Row(
//                           //         children: [
//                           //           Checkbox(
//                           //             value: item.status == 0 ? false : true,
//                           //             onChanged: (value) => checkbox(item.status,
//                           //                 item.key, item.email, item.task),
//                           //           ),
//                           //           Flexible(
//                           //             child: Text(
//                           //               item.task!,
//                           //               style: const TextStyle(
//                           //                 fontSize: 20,
//                           //                 fontWeight: FontWeight.w400,
//                           //               ),
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //       trailing: Row(
//                           //         mainAxisSize: MainAxisSize.min,
//                           //         mainAxisAlignment: MainAxisAlignment.center,
//                           //         crossAxisAlignment: CrossAxisAlignment.center,
//                           //         children: [
//                           //           IconButton(
//                           //             onPressed: () async {
//                           //               await updateTask(item.task, item.key,
//                           //                   item.status, item.email);
//                           //               await readValueTable();
//                           //             },
//                           //             icon: const Icon(
//                           //               Icons.edit_document,
//                           //               color: Color.fromRGBO(95, 94, 94, 0.988),
//                           //             ),
//                           //           ),
//                           //           IconButton(
//                           //             onPressed: () async {
//                           //               await deletePopUp(item.key);
//                           //             },
//                           //             icon: const Icon(
//                           //               Icons.delete,
//                           //               color: Colors.redAccent,
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   );
//                           // }).toSet().toList(),
//                         ),
//                       )

//                       // ListView.builder(
//                       //   scrollDirection: Axis.vertical,
//                       //   shrinkWrap: true,
//                       //   itemCount: _searchList.length,
//                       //   itemBuilder: (context, index) {
//                       //     return Card(
//                       //       color: Colors.green[400],
//                       //       elevation: 20,
//                       //       margin: const EdgeInsets.only(
//                       //           top: 15, left: 15, right: 15),
//                       //       child: ListTile(
//                       //         title: Row(
//                       //           children: [
//                       //             Checkbox(
//                       //               value: _searchList[index].status == 0
//                       //                   ? false
//                       //                   : true,
//                       //               onChanged: (value) => checkbox(
//                       //                   value,
//                       //                   _searchList[index].key,
//                       //                   _searchList[index].email,
//                       //                   _searchList[index].task),
//                       //             ),
//                       //             Flexible(
//                       //               child: Text(
//                       //                 _searchList[index].task!,
//                       //                 style: const TextStyle(
//                       //                     fontSize: 20,
//                       //                     fontWeight: FontWeight.w400),
//                       //               ),
//                       //             ),
//                       //           ],
//                       //         ),
//                       //         trailing: Row(
//                       //           mainAxisSize: MainAxisSize.min,
//                       //           mainAxisAlignment: MainAxisAlignment.center,
//                       //           crossAxisAlignment: CrossAxisAlignment.center,
//                       //           children: [
//                       //             IconButton(
//                       //               onPressed: () async {
//                       //                 await updateTask(
//                       //                     _searchList[index].task,
//                       //                     _searchList[index].key,
//                       //                     _searchList[index].status,
//                       //                     _searchList[index].email);
//                       //                 readValueTable();
//                       //               },
//                       //               icon: const Icon(Icons.edit_document,
//                       //                   color:
//                       //                       Color.fromRGBO(95, 94, 94, 0.988)),
//                       //             ),
//                       //             IconButton(
//                       //               onPressed: () async {
//                       //                 await deletePopUp(_userList[index].key);
//                       //               },
//                       //               icon: const Icon(Icons.delete,
//                       //                   color: Colors.redAccent),
//                       //             ),
//                       //           ],
//                       //         ),
//                       //       ),
//                       //     );
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 )
//               : emptyListPop(),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Theme.of(context).colorScheme.secondary,
//         onPressed: () {
//           addNewTask();
//         },
//         child: const Icon(Icons.add_task),
//       ),
//     );
//   }

//   double _calculateItemExtent(int itemCount) {
//   // Define a minimum item extent to ensure items have a reasonable size
//   double minimumItemExtent = 50.0; // You can adjust this value as needed

//   // Calculate the item extent based on itemCount
//   double itemExtent = itemCount * minimumItemExtent;

//   // Return the calculated item extent
//   return itemExtent;
// }



//   Future<void> addNewTask() async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add new task'),
//         actions: [
//           Column(
//             children: [
//               SizedBox(
//                 width: 600,
//                 child: Card(
//                   shape: BeveledRectangleBorder(
//                     borderRadius: BorderRadius.circular(14.6),
//                   ),
//                   elevation: 15,
//                   child: TextFormField(
//                     controller: todoTask,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(25))),
//                       prefixIcon: Icon(
//                         Icons.text_fields,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       await addTask();
//                       FocusManager.instance.primaryFocus?.unfocus();
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Add'),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       todoTask.text = '';
//                     },
//                     child: const Text('Cancel'),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   updateTask(task, String? key, int status, String? email) async {
//     taskUpdate.text = task;
//     String updatedTask = taskUpdate.text;
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Update task'),
//         actions: [
//           Column(
//             children: [
//               SizedBox(
//                 width: 600,
//                 child: Card(
//                   shape: BeveledRectangleBorder(
//                     borderRadius: BorderRadius.circular(14.6),
//                   ),
//                   elevation: 15,
//                   child: TextFormField(
//                     controller: taskUpdate,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(25))),
//                       prefixIcon: Icon(
//                         Icons.text_fields,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     // style: ButtonStyle(backgroundColor: Color(Colors.green)),
//                     onPressed: () async {
//                       final url = Uri.https(
//                           'todo-3737d-default-rtdb.firebaseio.com',
//                           'user-list/${key}.json');
//                       await http.put(
//                         url,
//                         body: json.encode(
//                           {
//                             'taskStatus': status,
//                             'task': taskUpdate.text,
//                             'email': email,
//                           },
//                         ),
//                       );
//                       Navigator.pop(context);
//                       await readValueTable();
//                       await readValueTable();
//                       setState(() {
                        
//                       });
//                     },
//                     child: const Text('Update'),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       todoTask.text = '';
//                     },
//                     child: const Text('Cancel'),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget searchBox() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20, left: 45, right: 45),
//       child: Card(
//         elevation: 25,
//         child: TextField(
//           onChanged: (value) => _filter(value),
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             prefixIcon: Icon(
//               Icons.search,
//               color: Colors.grey,
//               size: 20,
//             ),
//             prefixIconConstraints: BoxConstraints(
//               maxHeight: 20,
//               minWidth: 25,
//             ),
//             hintText: 'Search task',
//             hintStyle: TextStyle(color: Colors.grey),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> deletePopUp(id) async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Are you sure you want to delete the task?'),
//         actions: [
//           ElevatedButton(
//             onPressed: () async {
//               await _deleteValue(id);
//               Navigator.pop(context);
//             },
//             child: const Text('Ok'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           )
//         ],
//       ),
//     );
//   }

//   Widget emptyListPop() {
//     return Center(
//       child: Container(
//         width: 250,
//         height: 150,
//         color: Colors.redAccent,
//         child: const Center(
//             child: Text(
//           'There is no task',
//           style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
//         )),
//       ),
//     );
//   }
  
//   Widget buildTaskCard(TaskValue item) {
//     return Card(
//       color: Colors.green[400],
//       elevation: 20,
//       margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
//       child: ListTile(
//         title: Row(
//           children: [
//             Checkbox(
//               value: item.status == 0 ? false : true,
//               onChanged: (value) => checkbox(item.status, item.key, item.email, item.task),
//             ),
//             Flexible(
//               child: Text(
//                 item.task!,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             IconButton(
//               onPressed: () async {
//                 await updateTask(item.task, item.key, item.status, item.email);
//                 await readValueTable();
//               },
//               icon: const Icon(
//                 Icons.edit_document,
//                 color: Color.fromRGBO(95, 94, 94, 0.988),
//               ),
//             ),
//             IconButton(
//               onPressed: () async {
//                 await deletePopUp(item.key);
//               },
//               icon: const Icon(
//                 Icons.delete,
//                 color: Colors.redAccent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//   }
// }
