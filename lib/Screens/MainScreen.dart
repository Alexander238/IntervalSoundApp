import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../Design/ThemeData.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controllerSeconds = TextEditingController();
  final TextEditingController _controllerMinutes = TextEditingController();
  int _selectedTimeSeconds = 1;
  int _selectedTimeMinutes = 0;
  int _interval = 1;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  TextStyle bodyTextStyle = mainTheme.textTheme.bodyMedium!;

  @override
  void initState() {
    super.initState();
    _controllerSeconds.addListener(
        () => _handleTextFieldChanged(_controllerSeconds, isMinutes: false));
    _controllerMinutes.addListener(
        () => _handleTextFieldChanged(_controllerMinutes, isMinutes: true));
    _handleTextFieldChanged(_controllerSeconds, isMinutes: false);
    _handleTextFieldChanged(_controllerMinutes, isMinutes: true);

    _controllerSeconds.text = _selectedTimeSeconds.toString();
    _controllerMinutes.text = _selectedTimeMinutes.toString();
  }

  void _handleTextFieldChanged(TextEditingController controller,
      {required bool isMinutes}) {
    String value = controller.text;
    int parsedValue = int.tryParse(value) ?? 0;
    print(parsedValue);
    setState(() {
      if (isMinutes) {
        _selectedTimeMinutes = parsedValue;
      } else {
        // add this, so interval can never be 0 seconds.
        int parsedValue = int.tryParse(value) ?? 1;
        _selectedTimeSeconds = parsedValue;
      }
    });

    _interval = _selectedTimeSeconds + (_selectedTimeMinutes * 60);

    // only restart the timer on change if the timer was already running!
    if (_timer?.isActive != null && _timer!.isActive) {
      _stopTimer();
      _startTimer();
    }
    debugPrint("_interval is: $_interval");
  }

  @override
  void dispose() {
    _controllerSeconds.dispose();
    _controllerMinutes.dispose();
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(Duration(seconds: _interval), (_) {
      _playSound();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _playSound() {
    Source audioSource = AssetSource("click.wav");

    _audioPlayer.play(audioSource).then((result) {
      debugPrint("Audio played sucessfully");
      print("Audio played successfully");
    }).catchError((error) {
      print("Error playing audio: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interval Timer'),
        centerTitle: true,
        //actions: const [Icon(Icons.settings)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 250,
              child: Text("Select Time"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                style: bodyTextStyle,
                controller: _controllerMinutes,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: bodyTextStyle,
                  border: const OutlineInputBorder(),
                  labelText: 'Minutes',
                ),
                onChanged: (value) {
                  setState(() {
                    _handleTextFieldChanged(_controllerMinutes,
                        isMinutes: true);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                style: bodyTextStyle,
                controller: _controllerSeconds,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: bodyTextStyle,
                  border: const OutlineInputBorder(),
                  labelText: 'Seconds',
                ),
                onChanged: (value) {
                  setState(() {
                    _handleTextFieldChanged(_controllerSeconds,
                        isMinutes: false);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timerControlButton(_timer, "Start", _startTimer),
                const SizedBox(
                  width: 40,
                ),
                timerControlButton(_timer, "Stop", _stopTimer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget timerControlButton(
  Timer? timer,
  String text,
  Function func,
) {
  return ElevatedButton(
      onPressed: () {
        func();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          text,
          style: mainTheme.textTheme.bodyMedium!
              .copyWith(color: mainTheme.colorScheme.primary),
        ),
      ));
}
