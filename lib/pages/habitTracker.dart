import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/util/habit.dart';

class habitTracker extends StatefulWidget {
  const habitTracker({Key? key}) : super(key: key);

  @override
  State<habitTracker> createState() => _habitTrackerState();
}

class _habitTrackerState extends State<habitTracker> {
  List habitsList = [
    ["Read", false, 0, 1],
    ["Code", false, 0, 40],
    ["Play", false, 0, 30],
    ["Study", false, 0, 30],
  ];

  void habitStarted(int index) {
    var startTime = DateTime.now();

    var elapsedTime = habitsList[index][2];

    setState(() {
      habitsList[index][1] = !habitsList[index][1];
    });

    if (habitsList[index][1]) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (!habitsList[index][1]) {
            timer.cancel();
          }

          var currentTime = DateTime.now();
          habitsList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Settings for ${habitsList[index][0]}"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[50],
        appBar: AppBar(
          backgroundColor: Colors.cyan[700],
          title: const Text(
            "Focus!",
            style: TextStyle(color: Colors.white),
          ),
          //centerTitle: false,
        ),
        body: ListView.builder(
            itemCount: habitsList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: habitsList[index][0],
                onTap: () {
                  habitStarted(index);
                },
                settingsTap: () {
                  settingsOpened(index);
                },
                timeSpent: habitsList[index][2],
                habitTime: habitsList[index][3],
                habitStarted: habitsList[index][1],
              );
            }));
  }
}
