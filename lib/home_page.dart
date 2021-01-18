import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _dateTime = DateTime.now();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              '${_dateTime.hour}:${_dateTime.minute}',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              '${TimeOfDay.fromDateTime(_dateTime).period == DayPeriod.am ? 'AM' : 'PM'}',
              style: Theme.of(context).textTheme.caption,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Transform.rotate(
                angle: -pi / 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF666666).withOpacity(0.14),
                          offset: Offset(0, 0),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: CustomPaint(
                      painter: ClockPainter(dateTime: _dateTime),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  ClockPainter({this.dateTime});
  final DateTime dateTime;

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);

    /// 绘制指针
    /// 计算时针旋转角度后的位置
    /// 小时角度（360/12=30）+ 1小时内分钟转的角度（360/12/60=0.5）
    double hourX = centerX +
        size.width *
            0.2 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourY = centerX +
        size.width *
            0.2 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    /// 绘制时针
    Paint hourPointer = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawLine(center, Offset(hourX, hourY), hourPointer);

    /// 计算分针旋转角度后的位置
    /// 分钟角度 360/60=6
    double minuteX =
        centerX + size.width * 0.3 * cos((dateTime.minute * 6) * pi / 180);
    double minuteY =
        centerX + size.width * 0.3 * sin((dateTime.minute * 6) * pi / 180);

    /// 绘制分针
    Paint minutePointer = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;
    canvas.drawLine(center, Offset(minuteX, minuteY), minutePointer);

    /// 计算秒针旋转角度后的位置
    /// 分钟角度 360/60=6
    double sencondX =
        centerX + size.width * 0.4 * cos((dateTime.second * 6) * pi / 180);
    double sencondY =
        centerX + size.width * 0.4 * sin((dateTime.second * 6) * pi / 180);

    /// 绘制秒针
    Paint sencondPointer = Paint()
      ..color = Colors.grey.withOpacity(0.8)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    canvas.drawLine(center, Offset(sencondX, sencondY), sencondPointer);

    /// 中心点
    Paint dotPaint = Paint()..color = Color(0x44999999);
    canvas.drawCircle(center, 14, dotPaint);
    canvas.drawCircle(center, 13, Paint()..color = Colors.white);

    canvas.drawCircle(center, 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
