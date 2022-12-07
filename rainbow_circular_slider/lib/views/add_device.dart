import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key}) : super(key: key);

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('add a device')),
      ),
      body: Container(
          // color:Colors.red,
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: ((context, index) {
                return Center(
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
                              "hello world",
                              // textAlign:Alignment.center
                            )
                          ],
                        ),
                      )),
                );
              }))),
    );
  }
}
