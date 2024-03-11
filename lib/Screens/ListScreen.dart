import 'package:flutter/material.dart';
import 'package:interval_sound/Design/ThemeData.dart';
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

  void _showDeletePopup(BuildContext context, TimerData timerData) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final centerPosition =
        overlay.localToGlobal(overlay.size.center(Offset.zero));

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        centerPosition.dx - 100, // Width
        centerPosition.dy - 100, // Height
        centerPosition.dx + 100,
        centerPosition.dy + 100,
      ),
      items: [
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Remove Timer'),
          ),
          onTap: () {
            _deleteTimer(timerData);
          },
        ),
      ],
    );
  }

  void _deleteTimer(TimerData timerData) {
    setState(() {
      _savedTimers.remove(timerData);
      _saveTimers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Timer'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _savedTimers.length,
                itemBuilder: (context, index) {
                  final timerData = _savedTimers[index];
                  return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 15, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              mainTheme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          title: timerData.name == ''
                              ? const Text('- - - - -')
                              : Text(timerData.name),
                          subtitle: Text(
                              '${timerData.minutes}m ${timerData.seconds}s'),
                          onTap: () async {
                            TimerData updatedTimerData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(
                                  timerData: timerData,
                                ),
                              ),
                            );
                            setState(() {
                              int timerIndex = _savedTimers.indexOf(timerData);
                              _savedTimers[timerIndex] = updatedTimerData;
                              _saveTimers();
                            });
                          },
                          onLongPress: () {
                            _showDeletePopup(context, timerData);
                          },
                        ),
                      ));
                },
              ),
            ),

            // Add Timer
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      TimerData newTimerData =
                          TimerData(name: '', minutes: 0, seconds: 1);
                      TimerData? updatedTimerData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            timerData: newTimerData,
                            onSave: (timer) {
                              setState(() {
                                _savedTimers.add(timer);
                                _saveTimers();
                              });
                            },
                          ),
                        ),
                      );
                      if (updatedTimerData != null) {
                        setState(() {
                          _savedTimers.add(updatedTimerData);
                          _saveTimers();
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('New Timer'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
