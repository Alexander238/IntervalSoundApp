import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interval_sound/Screens/MainScreen.dart';
import '../Structures/TimerData.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<TimerData> _savedTimers = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTimers();
  }

  Future<void> _loadSavedTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedTimersString = prefs.getStringList('saved_timers');
    if (savedTimersString != null) {
      setState(() {
        _savedTimers = savedTimersString.map((timerString) {
          List<String> parts = timerString.split(',');
          return TimerData(
            name: parts[0],
            minutes: int.parse(parts[1]),
            seconds: int.parse(parts[2]),
          );
        }).toList();
      });
    }
  }

  Future<void> _saveTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedTimersString = _savedTimers.map((timerData) {
      return "${timerData.name},${timerData.minutes},${timerData.seconds}";
    }).toList();
    await prefs.setStringList('saved_timers', savedTimersString);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timer List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _savedTimers.length,
                itemBuilder: (context, index) {
                  final timerData = _savedTimers[index];
                  return ListTile(
                    title: Text(timerData.name),
                    subtitle:
                        Text('${timerData.minutes}m ${timerData.seconds}s'),
                    onTap: () async {
                      TimerData updatedTimerData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            timerData: timerData,
                          ),
                        ),
                      );
                      if (updatedTimerData != null) {
                        setState(() {
                          //print("NEUE TIEMR: " + timerData.seconds.toString());

                          int timerIndex = _savedTimers.indexOf(timerData);
                          _savedTimers[timerIndex] = updatedTimerData;
                          _saveTimers();
                        });
                      }
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(
                          timerData:
                              TimerData(name: '', minutes: 0, seconds: 0),
                          onSave: (TimerData timer) {
                            setState(() {
                              _savedTimers.add(timer);
                              _saveTimers();
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('Add Timer'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
