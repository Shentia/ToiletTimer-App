import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'toilet_timer_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ToiletTimerState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toilet Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
          )),
      home: ToiletTimerScreen(),
    );
  }
}

class ToiletTimerScreen extends StatefulWidget {
  const ToiletTimerScreen({super.key});

  @override
  _ToiletTimerScreenState createState() => _ToiletTimerScreenState();
}

class _ToiletTimerScreenState extends State<ToiletTimerScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    // Add other permissions as needed
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToiletTimerState>(
      builder: (context, timerState, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Toilet Timer',
              style: TextStyle(
                  color: Colors.brown.shade800,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/poop.png'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomPaint(
                  painter: ToiletSeatPainter(
                      timerState.secondsRemaining / timerState.timerDuration),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text(
                        '${(timerState.secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(timerState.secondsRemaining % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'HURRY UP',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed:
                          timerState.isRunning ? null : timerState.startTimer,
                      child: Text('Start'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: timerState.resetTimer,
                      child: Text('Reset'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: timerState.stopAlarm,
                      child: Text('Stop Alarm'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FilledButton.tonal(
                  onPressed: () => _launchDonationURL(context),
                  child: Text('Donate me a coffee'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchDonationURL(BuildContext context) async {
    const url = 'https://github.com/sponsors/Shentia';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch donation page')),
      );
    }
  }
}

class ToiletSeatPainter extends CustomPainter {
  final double progress;

  ToiletSeatPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the background circle
    canvas.drawCircle(center, radius, paint..color = Colors.grey);

    // Draw the progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -90.0 * (3.14 / 180.0);
    final sweepAngle = 360.0 * progress * (3.14 / 180.0);

    canvas.drawArc(rect, startAngle, sweepAngle, false,
        paint..color = Colors.brown.shade800);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
