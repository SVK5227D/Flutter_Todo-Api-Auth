import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo2/Designs/drawer.dart';
import 'package:todo2/Pages/completeTask.dart';
import 'package:todo2/Pages/listTask.dart';
// import 'package:todo2/Pages/listTask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskbarItems = const [
    Icon(
      Icons.checklist,
      size: 32,
    ),
    Icon(
      Icons.task_outlined,size: 32,
    ),
    
  ];

  int taskbarValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: MyDrawer(),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.yellowAccent,
          color: Theme.of(context).colorScheme.secondary,
          animationDuration: const Duration(milliseconds: 300),
          items: taskbarItems,
          onTap: (selctedIndex) {
            setState(() {
              taskbarValue = selctedIndex;
            });
          },
        ),
        body: getSelectedWidget(index: taskbarValue));
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (taskbarValue) {
      case 0:
        widget = const ListTask();
        break;
      case 1:
        widget = const TaskCompleted();
        break;
      default:
        widget = const ListTask();
        break;
    }
    return widget;
  }
}
