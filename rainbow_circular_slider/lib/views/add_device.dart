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
      appBar: AppBar(excludeHeaderSemantics: true),
      body: Container(
        // color:Colors.red,
        child: ListView.builder(
          itemCount:3,
          itemBuilder: ((context, index) {
            return Center(
              child: Container(
                width:MediaQuery.of(context).size.width- 40,
                height:80,
                margin:EdgeInsets.symmetric(vertical:10),
                decoration:BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 138, 138, 138), width: 1.0),
                  borderRadius:BorderRadius.circular(12),
                  color:Colors.amber,
                ),
                child:Center(
                  child: Text(
                    "hello world",
                    // textAlign:Alignment.center
                  ),
                )
              ),
            );
          }))
      ),
    );
  }
}