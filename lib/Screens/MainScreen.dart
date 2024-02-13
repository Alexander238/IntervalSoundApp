import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../Design/ThemeData.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../Widgets/Arrangements.dart';

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
  double _elapsedSeconds = 0;
  double _progressValue = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  TextStyle bodyTextStyle = mainTheme.textTheme.bodyMedium ?? const TextStyle();

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
    if (_timer != null && _timer!.isActive) {
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

    const totalSteps = 100; // Total number of steps for the progress update
    final tickDuration =
        _interval * 1000 / totalSteps; // Duration of each tick in milliseconds

    _timer =
        Timer.periodic(Duration(milliseconds: tickDuration.toInt()), (timer) {
      setState(() {
        _elapsedSeconds += _interval / totalSteps;
        if (_elapsedSeconds >= _interval) {
          _playSound();
          _elapsedSeconds = 0;
        }
        _progressValue = (_elapsedSeconds / _interval) * _interval;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _progressValue = 0;
    });
  }

  void _playSound() {
    Source audioSource = AssetSource("click.wav");

    _audioPlayer.play(audioSource).then((result) {}).catchError((error) {
      print("Error playing audio: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Interval Timer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // circle that represents timer
              heightDivider(context),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: _interval.toDouble(),
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        axisLineStyle: const AxisLineStyle(
                            thickness: 0.1,
                            cornerStyle: CornerStyle.bothCurve,
                            color: Color.fromARGB(66, 233, 167, 245),
                            thicknessUnit: GaugeSizeUnit.factor),
                        pointers: <GaugePointer>[
                          RangePointer(
                              value: _progressValue,
                              width: 0.1,
                              sizeUnit: GaugeSizeUnit.factor,
                              cornerStyle: CornerStyle.startCurve,
                              gradient: const SweepGradient(colors: <Color>[
                                Color.fromARGB(255, 116, 0, 139),
                                Color.fromARGB(255, 229, 139, 241)
                              ], stops: <double>[
                                0.25,
                                0.75
                              ])),
                          MarkerPointer(
                              value: _progressValue,
                              markerWidth:
                                  MediaQuery.of(context).size.width * 0.065,
                              markerHeight:
                                  MediaQuery.of(context).size.width * 0.065,
                              markerType: MarkerType.circle,
                              color: Color.fromARGB(255, 215, 112, 255))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              heightDivider(context),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Text("Select Time"),
              ),
              heightDivider(context, MediaQuery.of(context).size.height * 0.02),

              // Minutes input field
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
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
              heightDivider(context, MediaQuery.of(context).size.height * 0.03),
              // Seconds input field
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
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
              heightDivider(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  timerControlButton(_timer, "Start", _startTimer),
                  const SizedBox(width: 40),
                  timerControlButton(_timer, "Stop", _stopTimer),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

Widget timerControlButton(Timer? timer, String text, Function func) {
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
