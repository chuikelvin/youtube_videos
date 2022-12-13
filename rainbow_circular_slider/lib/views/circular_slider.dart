import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/views/utils.dart';
import 'dart:io';

double radius = 135;
double strokeWidth = 15;

// void printIps() async {
//   var my_address = "";
//   var address = "";
//   for (var interface in await NetworkInterface.list()) {
//     // print('== Interface: ${interface.name} ==');
//     for (var addr in interface.addresses) {
//       my_address = addr.address;
//     }
//   }
//   print(my_address);

//   var index = my_address.lastIndexOf('.');
//   address = my_address.substring(0, index + 1);
//   address += "255";
//   print(address);

//   RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210)
//       .then((RawDatagramSocket socket) {
//     // print('Sending from ${socket.address.address}:${socket.port}');
//     // printIps();
//     socket.broadcastEnabled = true;
//     int port = 4210;
//     for (int i = 0; i <3;i++){
//     socket.send('marco'.codeUnits,
//         InternetAddress(address), port);
//         }
//   });
// }

class CircularSlider extends StatefulWidget {
  final ValueChanged<double> onAngleChanged;

  final double canvheight;

  const CircularSlider({
    Key? key,
    required this.onAngleChanged,
    required this.canvheight,
  }) : super(key: key);

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  Offset _currentDragOffset = Offset.zero;

  double currentAngle = 0;

  double startAngle = toRadian(90 + 45);

  double totalAngle = toRadian(360);

  var my_address = "";
  var address = "";

  var mainSocket = RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210);

  @override
  void initState() {
    startudp();
    super.initState();
  }

  void startudp() async {
    for (var interface in await NetworkInterface.list()) {
      // print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        my_address = addr.address;
      }
    }
    print(my_address);

    var index = my_address.lastIndexOf('.');
    address = my_address.substring(0, index + 1);
    address += "255";
    print(address);

    // RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210)
    mainSocket.then((RawDatagramSocket socket) {
      socket.broadcastEnabled = true;
      int port = 4210;
      try {
        // for (int i = 0; i <3;i++){
        socket.send('marco'.codeUnits, InternetAddress(address), port);
        // }

      } catch (e) {
        startudp();
      }
      // print('Sending from ${socket.address.address}:${socket.port}');
      // printIps();

      socket.listen((RawSocketEvent e) {
        Datagram? d = socket.receive();
        if (d == null) return;
        if (d.address.address != my_address) {
          String message = new String.fromCharCodes(d.data);
          print(
              'Datagram from ${d.address.address}:${d.port}: ${message.trim()}');

          socket.send(message.codeUnits, d.address, d.port);
        }
      });
    });
  }

  void printIps() async {
    mainSocket.then((RawDatagramSocket socket) {
      socket.broadcastEnabled = true;
      int port = 4210;
      for (int i = 0; i < 3; i++) {
        socket.send('marco'.codeUnits, InternetAddress(address), port);
      }
      print("will work");
    });
    // var my_address = "";
    // var address = "";
    // for (var interface in await NetworkInterface.list()) {
    //   // print('== Interface: ${interface.name} ==');
    //   for (var addr in interface.addresses) {
    //     my_address = addr.address;
    //   }
    // }
    // print(my_address);

    // var index = my_address.lastIndexOf('.');
    // address = my_address.substring(0, index + 1);
    // address += "255";
    // print(address);

    // RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210)
    //     .then((RawDatagramSocket socket) {
    //   // print('Sending from ${socket.address.address}:${socket.port}');
    //   // printIps();
    //   socket.broadcastEnabled = true;
    //   int port = 4210;
    //   for (int i = 0; i <3;i++){
    //   socket.send('marco'.codeUnits,
    //       InternetAddress(address), port);
    //       }
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size canvasSize = Size(screenSize.width, widget.canvheight);
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
        // Positioned(
        //     left: 180 - 40,
        //     top: 170 - 40,
        //     child: Container(
        //       width: 80,
        //       height: 80,
        //       child: Text(
        //         '$knobPos',
        //         style: TextStyle(
        //           fontSize: 20.0,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       decoration: BoxDecoration(
        //           color: Color.fromARGB(255, 64, 144, 90),
        //           shape: BoxShape.circle,
        //           border: Border.all(color: Colors.white, width: 3.0)),
        //     )),
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
      // 2,
      // toRadian(270),
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(rect, startAngle, toRadian(270), false, rainbowPaint);
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
    double detector_size = 80;
    return Stack(children: [
      Transform.translate(
        offset: Offset(-25, -25),
        child: Container(
          height: detector_size,
          width: detector_size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
        ),
      ),
      Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: const Color(0xff0b1623),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3.0)),
      )
    ]);

    // height: 60,
    // width: 60,
  }
}
