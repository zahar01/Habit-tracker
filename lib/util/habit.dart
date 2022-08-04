import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTap;
  final int timeSpent;
  final int habitTime;
  final bool habitStarted;

  const HabitTile(
      {Key? key,
      required this.habitName,
      required this.onTap,
      required this.settingsTap,
      required this.timeSpent,
      required this.habitTime,
      required this.habitStarted})
      : super(key: key);

  String formatToMinSec(int seconds) {
    String secs = (seconds % 60).toString();
    String mins = (seconds / 60).toStringAsFixed(5);

    if (secs.length == 1) {
      secs = '0$secs';
    }

    if (mins[1] == ".") {
      mins = mins.substring(0, 1);
    }

    return "$mins:$secs";
  }

  double percentCalc() {
    return timeSpent / (habitTime*60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          CircularPercentIndicator(
                            radius: 30,
                            percent: percentCalc() < 1 ? percentCalc() : 1,
                            progressColor: percentCalc() > 0.6 
                            ? Colors.indigo 
                            : ((percentCalc() > 0.3)&(percentCalc() <= 0.6) 
                            ? Colors.purple
                            : Colors.pink[300]),
                          ),
                          Center(
                            child: Icon(
                                habitStarted ? Icons.pause : Icons.play_arrow),
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${formatToMinSec(timeSpent)} / $habitTime = ${(percentCalc()*100).toStringAsFixed(0)}%",
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
                onTap: settingsTap, child: const Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}
