import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/views/utils.dart';
import 'dart:io';

double radius = 135;
double strokeWidth = 15;

void printIps() async {
  var address = "";
  for (var interface in await NetworkInterface.list()) {
    // print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      address = addr.address;
    }
  }

  var index = address.lastIndexOf('.');
  address = address.substring(0, index + 1);
  address += "255";
  print(address);

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210)
      .then((RawDatagramSocket socket) {
    // print('Sending from ${socket.address.address}:${socket.port}');
    // printIps();
    socket.broadcastEnabled = true;
    int port = 4210;
    socket.send('Hello from UDP land!\n'.codeUnits,
        InternetAddress('192.168.0.255'), port);
  });
}

class CircularSlider extends StatefulWidget {
  final ValueChanged<double> onAngleChanged;

  const CircularSlider({
    Key? key,
    required this.onAngleChanged,
  }) : super(key: key);

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  Offset _currentDragOffset = Offset.zero;

  double currentAngle = 0;

  double startAngle = toRadian(0);

  double totalAngle = toRadian(360);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size canvasSize = Size(screenSize.width, screenSize.width - 60);
    Offset center = canvasSize.center(Offset.zero);
    Offset knobPos = toPolar(center - Offset(strokeWidth, strokeWidth),
        currentAngle + startAngle, radius);

    return Stack(
      children: [
        CustomPaint(
          size: canvasSize,
          child: Container(),
          painter: SliderPainter(
            startAngle: startAngle,
            currentAngle: currentAngle,
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            width: radius + strokeWidth,
            height: radius + strokeWidth,
            child: GestureDetector(
              onTap: printIps,
            ),
          ),
        ),
        Positioned(
          left: knobPos.dx,
          top: knobPos.dy,
          child: GestureDetector(
            onPanStart: (details) {
              RenderBox getBox = context.findRenderObject() as RenderBox;
              _currentDragOffset = getBox.globalToLocal(details.globalPosition);
            },
            onPanUpdate: (details) {
              var previousOffset = _currentDragOffset;
              _currentDragOffset += details.delta;
              var angle = currentAngle +
                  toAngle(_currentDragOffset, center) -
                  toAngle(previousOffset, center);
              currentAngle = normalizeAngle(angle);
              widget.onAngleChanged(currentAngle);
              setState(() {});
            },
            child: const _Knob(),
          ),
        ),
      ],
    );
  }
}

class SliderPainter extends CustomPainter {
  final double startAngle;
  final double currentAngle;

  SliderPainter({required this.startAngle, required this.currentAngle});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset.zero);

    Rect rect = Rect.fromCircle(center: center, radius: radius);
    var rainbowPaint = Paint()
      ..shader = SweepGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(rect, startAngle, currentAngle, false, rainbowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Knob extends StatelessWidget {
  const _Knob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: const Color(0xff0b1623),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.0)),
    );
  }
}
