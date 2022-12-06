import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_circular_slider/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController _pageController = PageController();

  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
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
              PageView(
                controller: _pageController,
                onPageChanged: ((value) => {
                      setState(
                        () {
                          onLastPage = (value == 2);
                        },
                      )
                    }),
                children: <Widget>[
                  Container(
                    color: Colors.pink,
                    child: Container(
                      child: ListView.builder(
                          itemCount: 12,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 12,
                              height: 130,
                              color: Colors.amber,
                              margin: EdgeInsets.all(10),
                            );
                          }),
                    ),
                  ),
                  Container(
                    color: Colors.cyan,
                  ),
                  Container(
                      color: Colors.deepPurple,
                      child: Stack(children: [
                        Container(
                            height: (MediaQuery.of(context).size.height),
                            width: (MediaQuery.of(context).size.width),
                            child: Center(
                                child: Image.asset(
                              'assets/images/reducer.PNG',
                              height: (MediaQuery.of(context).size.height),
                              width: (MediaQuery.of(context).size.width),
                              scale: 0.4,
                            ))),
                        Center(
                          child: GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('onBoard', 0);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomeScreen();
                                }));
                              },
                              child: Stack(children: [
                                Container(
                                    width: 200,
                                    height: 100,
                                    color: Colors.yellow,
                                    child: Center(
                                      child: Text("done"),
                                    ))
                              ])),
                        )
                      ])),
                ],
              ),
              Container(
                alignment: Alignment(0, 0.92),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(2,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            child: Center(child: Text('skip')),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(16)),
                          )),
                      // Spacer(),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor: Color.fromARGB(255, 255, 255, 255),
                          dotWidth: 6,
                          dotHeight: 6,
                          dotColor: Color.fromARGB(79, 80, 72, 72),
                        ),
                      ),
                      // Spacer(),
                      onLastPage
                          ? GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('onBoard', 0);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomeScreen();
                                }));
                              },
                              child: Container(
                                width: 80,
                                height: 40,
                                child: Center(child: Text('Done')),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16)),
                              ))
                          : GestureDetector(
                              onTap: () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              },
                              child: Container(
                                width: 80,
                                height: 40,
                                child: Center(child: Text('next')),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                    ]),
              ),
            ],
          )),
    );
  }
}
