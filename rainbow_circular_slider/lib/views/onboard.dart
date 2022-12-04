import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor:Colors.white,
            //       appBar: AppBar(
            //   elevation: 0.0,
            //   backgroundColor: Color.fromARGB(255, 255, 0, 0),
            //   centerTitle: false,
            //   title: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(
            //         'H o m e p o d'.toUpperCase(),
            //       ),
            //       const SizedBox(width: 10.0),
            //       Text(
            //         'M i n i'.toUpperCase(),
            //         style: const TextStyle(fontSize: 14.0),
            //       ),
            //     ],
            //   ),
            // ),
        body: Stack(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height),
                width: (MediaQuery.of(context).size.width),
              child:Center(child: Image.asset(
                'assets/images/reducer.PNG',
                height: (MediaQuery.of(context).size.height),
                width: (MediaQuery.of(context).size.width),
                scale: 0.4,
                ))
            ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                       SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setInt('onBoard', 0);
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                    return const HomeScreen();
                  }
                  )
                  );
                  },
                  child: 
                    Stack(
                      children: [
                        Container(
                          width:200,
                          height:100,
                          color:Colors.yellow,
                          child:Center(
                            child: Text(
                              "done"
                            ),
                          )
      
                        )
                      ]
                    )
                  
                ),
              )
          ]
        )
      ),
    );
  }
}