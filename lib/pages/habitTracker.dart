import 'dart:async';
import 'package:flutter/foundation.dart';
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

  final _textController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minsController = TextEditingController();

  final _settingText = TextEditingController();
  final _settingHours = TextEditingController();
  final _settingMins = TextEditingController();

  void habitStarted(int index) {
    var startTime = DateTime.now();

    var elapsedTime = habitsList[index][2];

    setState(() {
      habitsList[index][1] = !habitsList[index][1];
    });

    if (habitsList[index][1]) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void deleteHabit(int index) {
    setState(() {
      habitsList.remove(habitsList[index]);
    });

    Navigator.of(context).pop();
  }

  List formatHoursMins(int mins) {
    var hoursAndMins = [];

    var hours = mins ~/ 60;
    hoursAndMins.add(hours);
    hoursAndMins.add(mins - hours * 60);

    return hoursAndMins;
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Settings for ${habitsList[index][0]}"),
            content: Column(
              children: [
                TextField(
                  controller: _settingText,
                  decoration: InputDecoration(
                    hintText: habitsList[index][0],
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                TextField(
                  controller: _settingHours,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText:
                        "${formatHoursMins(habitsList[index][3])[0]} Hours",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _settingMins,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText:
                        "${formatHoursMins(habitsList[index][3])[1]} Minutes",
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //button "delete"
                    MaterialButton(
                      color: Colors.cyan[700],
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        deleteHabit(index);
                      },
                    ),

                    //button "submit"
                    MaterialButton(
                      onPressed: () {
                        if (_settingText.text == '') {
                          _settingText.text = habitsList[index][0];
                        }

                        if (int.tryParse(_settingHours.text) == null) {
                          _settingHours.text =
                              (formatHoursMins(habitsList[index][3])[0]).toString();
                        }

                        if (int.tryParse(_settingMins.text) == null) {
                          _settingMins.text =
                              (formatHoursMins(habitsList[index][3])[1]).toString();
                        }

                        var time = int.parse(_settingHours.text) * 60 +
                            int.parse(_settingMins.text);

                        setState(() {
                          habitsList[index][0] = _settingText.text;
                          habitsList[index][3] = time;
                        });

                        _settingText.clear();
                        _settingHours.clear();
                        _settingMins.clear();

                        Navigator.of(context).pop();
                      },
                      color: Colors.cyan[700],
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Change",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void addHabit() {
    // setState(() {
    //   habitsList.add(["Read", false, 0, 1]);
    // });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add your habit"),
            content: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "Habit name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                TextField(
                  controller: _hoursController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Hours",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: _minsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Minutes",
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                MaterialButton(
                  onPressed: () {
                    if (int.tryParse(_hoursController.text) == null) {
                      _hoursController.text = '0';
                    }

                    if (int.tryParse(_minsController.text) == null) {
                      _minsController.text = '0';
                    }

                    var time = int.parse(_hoursController.text) * 60 +
                        int.parse(_minsController.text);

                    setState(() {
                      habitsList.add([_textController.text, false, 0, time]);
                    });

                    _textController.clear();
                    _hoursController.clear();
                    _minsController.clear();

                    Navigator.of(context).pop();
                  },
                  color: Colors.cyan[700],
                  padding: const EdgeInsets.all(15),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // TimePickerDialog(
                //   initialTime: TimeOfDay(hour: 0, minute: 0),
                // ),
              ],
            ),
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
              habitStarted: habitsList[index][1],
              timeSpent: habitsList[index][2],
              habitTime: habitsList[index][3],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addHabit();
        },
        backgroundColor: Colors.cyan[700],
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
