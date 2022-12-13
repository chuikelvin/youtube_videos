import 'dart:async';
import 'dart:math' as math;
// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/card.dart';
import 'package:rainbow_circular_slider/constants.dart';
import 'package:rainbow_circular_slider/views/circular_slider.dart';

import 'add_device.dart';
import 'onboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int volume = 0;
  bool liked = false;
  StreamSubscription? connection;
  bool isoffline = false;
  String connectionmode = "";
  // late Connectivity internet_result;
  @override
  void initState() {
    // checkConnectivity();
    ConnectivityResult _connectionStatus = ConnectivityResult.none;
    // var status = await Connectivity().checkConnectivity();

    // print(status.toString());

    // if (status = ConnectivityResult.bluetooth) {

    // }

    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      print("change");
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
          connectionmode = "none";
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
          connectionmode = "mobile";
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
          connectionmode = "wifi";
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
          connectionmode = "ethernet";
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
          connectionmode = "bluetooth";
        });
      }
    });
    super.initState();
  }

  // void checkConnectivity() async {
  //   internet_result = (await Connectivity().checkConnectivity()) as Connectivity;
  //   // print(internet_result.toString());
  // }
  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit the App?'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: isoffline
                  ? [bgRed, bgDark, bgDark]
                  : [bgLight, bgDark, bgDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            // ignore: prefer_const_constructors
            drawer: Drawer(
              backgroundColor: Color.fromARGB(132, 0, 0, 0),
              width: 200,
              // ignore: prefer_const_constructors
              child: SafeArea(
                  child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("This is a drawer"),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const OnBoard();
                        }));
                      },
                      child: Container(
                        child: Text('Review onboarding'),
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      )),
                ],
              )),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'H o m e p o d'.toUpperCase(),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    'M i n i'.toUpperCase(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    '$connectionmode'.toUpperCase(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    // liked = !liked;
                    // setState(() {});
                    if (await Permission.bluetooth.request().isGranted) {
                      // Either the permission was already granted before or the user just granted it.
                      print("Location Permission is granted");
                    } else {
                      print("Location Permission is denied.");
                    }

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddDevice();
                    }));
                  },
                  color: liked ? Colors.red : Colors.white,
                  icon: Icon(
                    liked ? CupertinoIcons.add : CupertinoIcons.add,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 340.0,
                  width: MediaQuery.of(context).size.width,
                  child: Transform.rotate(
                    // angle: math.pi / 2,
                    angle: 0,
                    child: CircularSlider(
                      canvheight: 340.0,
                      onAngleChanged: (angle) {
                        volume = ((angle / (math.pi * 2)) * 100).toInt();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                _VolumeRow(volume: volume),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 195.0,
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: cards.length,
                          itemBuilder: (BuildContext context, int index) {
                            CardModel card = cards[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: _Card(cardModel: card),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //           GestureDetector(
          // child:Container(
          //   height:MediaQuery.of(context).size.height,
          //   color:Colors.red,
          //   width:12,
          // )
          // )
        ],
      ),
    );
  }
}

class _VolumeRow extends StatelessWidget {
  final int volume;

  const _VolumeRow({Key? key, required this.volume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(CupertinoIcons.speaker_2, size: 30.0),
          const Text(
            'V O L U M E',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '$volume',
            style: const TextStyle(
              fontSize: 60.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '%',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatefulWidget {
  final CardModel cardModel;

  const _Card({Key? key, required this.cardModel}) : super(key: key);

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  var width = 0.0;
  var widthdata = 0.0;
  @override
  Widget build(BuildContext context) {
    Color color = widget.cardModel.active ? Colors.white : Colors.white24;
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
            color: bgDark,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: widget.cardModel.active
                ? [
                    const BoxShadow(
                      color: Color.fromARGB(255, 72, 72, 72),
                      offset: Offset(2.0, 2.0),
                    ),
                  ]
                : [],
          ),
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.cardModel.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10.0),
                Icon(
                  widget.cardModel.icon,
                  size: 40.0,
                  color: color,
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.cardModel.active ? 'A C T I V E' : 'I N A C T I V E',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
            GestureDetector(
                onDoubleTap: () {
                  if (width <= 0) {
                    setState(() {
                      width = 150;
                    });
                  } else {
                    setState(() {
                      width = 0;
                    });
                  }
                },
                onHorizontalDragUpdate: ((details) {
                  setState(() {
                    widthdata = width += details.delta.dx;
                    if (widthdata >= 0 && widthdata < 150) {
                      width = widthdata;
                    } else if (widthdata < 0) {
                      widthdata = width = 0;
                    } else {
                      widthdata = width = 150;
                    }
                  });
                  print(width);
                }),
                child: Container(
                  color: Color.fromARGB(0, 33, 149, 243),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      // height: 0.2*150,
                      width: width,
                      // alignment: Alignment.bottomLeft,
                      color: Color.fromARGB(77, 175, 145, 76),
                    ),
                  ),
                ))
          ]),
        ),
      ],
    );
  }
}
