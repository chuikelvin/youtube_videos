import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/views/home_screen.dart';
import 'package:rainbow_circular_slider/views/onboard.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future printIps() async {
  var my_address = "";
  var address = "";
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

      RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210)
      .then((RawDatagramSocket socket) {
    // print('Sending from ${socket.address.address}:${socket.port}');
    // var ip_data = printIps();
    socket.broadcastEnabled = true;
    int port = 4210;
    // socket.send('Hello from UDP land!\n'.codeUnits,
    //     InternetAddress('192.168.0.255'), port);

        socket.listen((RawSocketEvent e){
      Datagram? d = socket.receive();
      if (d == null) return;
      if (d.address.address != my_address){

      String message = new String.fromCharCodes(d.data);
      print('Datagram from ${d.address.address}:${d.port}: ${message.trim()}');

      socket.send(message.codeUnits, d.address, d.port);
      }
    });
  });

  // return [my_address, address];
}
int? isviewed;

void main() async {
  // printIps();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      // home:const OnBoard(),
      home: isviewed != 0? const OnBoard(): const HomeScreen(),
    );
  }
}
