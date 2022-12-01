import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/views/home_screen.dart';
import 'dart:io';

Future printIps() async {
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
}

void main() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210)
      .then((RawDatagramSocket socket) {
    // print('Sending from ${socket.address.address}:${socket.port}');
    printIps();
    socket.broadcastEnabled = true;
    int port = 4210;
    socket.send('Hello from UDP land!\n'.codeUnits,
        InternetAddress('192.168.0.255'), port);

        socket.listen((RawSocketEvent e){
      Datagram? d = socket.receive();
      if (d == null) return;

      String message = new String.fromCharCodes(d.data);
      print('Datagram from ${d.address.address}:${d.port}: ${message.trim()}');

      socket.send(message.codeUnits, d.address, d.port);
    });
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
