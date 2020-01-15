// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var randomGenerator = new Random();
  List<double> _randomAngle = [0.0, 0.0, 0.0, 0.0];
  List<double> _randomSize = [216.0, 216.0, 216.0, 216.0];
  var colorCount = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      colorCount = colorCount == 5 ? 0 : colorCount + 1;
      for (var i = 0; i < 4; i++) {
        _randomAngle[i] = (randomGenerator.nextInt(25) - 12.5) / 360;
      }
      for (var i = 0; i < 4; i++) {
        _randomSize[i] = randomGenerator.nextInt(35) - 0.0;
      }
      _timer = Timer(
        Duration(seconds: 5) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  Color detectColor() {
    if (colorCount == 0) {
      return Colors.purple;
    } else if (colorCount == 1) {
      return Colors.indigo;
    } else if (colorCount == 2) {
      return Colors.blue;
    } else if (colorCount == 3) {
      return Colors.green;
    } else if (colorCount == 4) {
      return Colors.orange;
    } else if (colorCount == 5) {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              color: detectColor(),
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(_randomAngle[0]),
                            child: Text(
                              hour[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize - _randomSize[0],
                                  fontFamily: 'PTSans'),
                            ),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(_randomAngle[1]),
                            child: Text(
                              hour[1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize - _randomSize[1],
                                  fontFamily: 'PTSans'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Sunday",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'PTSans'),
                    ),
                    Text(
                      "12 Jan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontFamily: 'PTSans'),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(_randomAngle[2]),
                            child: Text(
                              minute[0],
                              style: TextStyle(
                                  color: detectColor(),
                                  fontSize: fontSize - _randomSize[2],
                                  fontFamily: 'PTSans'),
                            ),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(_randomAngle[3]),
                            child: Text(
                              minute[1],
                              style: TextStyle(
                                  color: detectColor(),
                                  fontSize: fontSize - _randomSize[3],
                                  fontFamily: 'PTSans'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "2020",
                      style: TextStyle(
                          color: detectColor(),
                          fontSize: 30.0,
                          fontFamily: 'PTSans'),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
