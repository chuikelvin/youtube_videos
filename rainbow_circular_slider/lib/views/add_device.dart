import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key}) : super(key: key);

  // final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  // _addDeviceTolist(final BluetoothDevice device) {
  //   if (!widget.devicesList.contains(device)) {
  //     setState((){
  //       widget.devicesList.add(device)
  //     })
  //   }
  // }

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  final bluetoothDevices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('add a device')),
          actions: [
            IconButton(
                onPressed: () {
                  // Start scanning
                  flutterBlue.startScan(timeout: Duration(seconds: 4));

                  var subscription = flutterBlue.scanResults.listen((results) {
                    // do something with scan results
                    for (ScanResult r in results) {
                      if (r.device.name != "" &&
                          !bluetoothDevices.contains(r.device)) {
                        setState(() {
                          bluetoothDevices.add(r.device);
                        });
                      }

                      // )
                      // print('${r.device.name} found! rssi: ${r.rssi}');
                    }
                    print(bluetoothDevices);
                  });

                  flutterBlue.stopScan();
                },
                icon: Icon(CupertinoIcons.add))
          ]),
      body: Container(
          // color:Colors.red,
          child: ListView.builder(
              itemCount: bluetoothDevices.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () async {
                    try {
                      await bluetoothDevices[index].connect();
                    } catch (e) {
                      // if (e.code != 'already_connected') {
                      throw e;
                      // }
                    }
                  },
                  child: Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        // height: 80,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 138, 138, 138),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(12),
                          color: index % 2 == 0
                              ? Color.fromARGB(66, 212, 212, 212)
                              : Color.fromARGB(66, 208, 157, 85),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/espressif.png',
                                // height: (MediaQuery.of(context).size.height),
                                // width: (MediaQuery.of(context).size.width),
                                scale: 0.8,
                              ),
                              Text(
                                ' ${bluetoothDevices[index].name}',
                                // "hello world",
                                // textAlign:Alignment.center
                              )
                            ],
                          ),
                        )),
                  ),
                );
              }))),
    );
  }
}
