import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class Reset_Pin extends StatefulWidget {
  @override
  _Reset_PinState createState() => _Reset_PinState();
}

class _Reset_PinState extends State<Reset_Pin> {
  bool is_conform = false;
  bool is_press = false;
  String is_mode = "";
  bool is_mode_selected = false;
  bool is_processing = false;
  TextEditingController get_value = TextEditingController();
  TextEditingController get_otp = TextEditingController();
  bool is_otp = false;
  String string_otp;
  int otp;
  List result_l = [];

  void check_otp() {
    if (get_otp.text.length == 6) {
      setState(() {
        is_processing = true;
      });
      Future.delayed(const Duration(seconds: 2));
      string_otp = otp.toString();
      if (string_otp == get_otp.text) {
        is_conform = true;
      } else {
        _showMyDialog(context, 'OTP does not match.', AlertType.error);
        setState(() {
          get_value.clear();
        });
      }
    } else {
      _showMyDialog(context, 'Invalid OTP.', AlertType.error);
    }
  }

  send_otp() async {
    if (get_value.text.length == 10) {
      var Url = Uri.parse("https://atmdb.000webhostapp.com/get_number.php");
      // var Url = Uri.parse("http://192.168.43.4/Ex_5/get_number.php");
      var data1 = {
        "number": get_value.text,
      };
      var result1 = await http.post(Url, body: data1);
      String result_s = result1.body;
      result_l = result_s.split(" ");
      print(result_l);
      if (result_l[0] == 'true') {
        result1.headers['Access-Control-Allow-Origin: *'];
        Random random = new Random();
        otp = random.nextInt(900000) + 100000;
        String msg =
            "This is your OTP for Pin reset \"$otp\". Please don't share this with others.";
        String numbers = get_value.text + ",8109832799";
        var result = await http.get(Uri.parse(
            'https://www.fast2sms.com/dev/bulkV2?authorization=rdtbQZsGikMl7pe3WRUoIT4mBFh8guD6zHCXAwfn2O095YEKcVsykcpSRIJfDAzgjln9bKv68xHmZXPF&route=v3&sender_id=TXTIND&message_text=$msg&language=english&flash=1&numbers=${numbers}'));
        Map<String, dynamic> map = jsonDecode(result.body);
        print(map);
        if (map['return']) {
          setState(() {
            is_processing = false;
            is_otp = true;
            _showMyDialog(context, 'OTP Successfully Sent.', AlertType.success);
          });
        } else {
          _showMyDialog(
              context, 'Can Not Send OTP At This Time.', AlertType.warning);
        }
      } else {
        _showMyDialog(context, 'Number Does Not Match.', AlertType.warning);
        get_value.clear();
        is_processing = false;
      }
    } else {
      _showMyDialog(context, 'Invalide Number', AlertType.warning);
      setState(() {
        is_processing = false;
      });
    }
  }

  security_q() async {
    if (get_value.text.length > 0) {
      await Future.delayed(const Duration(seconds: 1));
      var Url = Uri.parse("https://atmdb.000webhostapp.com/security_q.php");
      // var Url = Uri.parse("http://192.168.43.4/Ex_5/security_q.php");
      var data = {
        "s_q": get_value.text.toUpperCase(),
      };
      var result = await http.post(Url, body: data);
      result.headers['Access-Control-Allow-Origin: *'];
      String result_s = result.body;
      result_l = result_s.split(" ");
      if (result_l[0] == 'true') {
        setState(() {
          is_processing = false;
          is_conform = true;
        });
        _showMyDialog(context, "Verified", AlertType.success);
      } else {
        get_value.clear();
        _showMyDialog(context, 'Wrong Security Answer', AlertType.warning);
        setState(() {
          is_processing = false;
        });
      }
    } else {
      setState(() {
        is_processing = false;
      });
      get_value.clear();
      _showMyDialog(
          context, "Security Answer can't be empty..!", AlertType.error);
    }
  }

  void check_security() {
    setState(() {
      is_processing = true;
    });
    if (is_mode == "otp") {
      send_otp();
    } else {
      security_q();
    }
  }

  @override
  Widget build(BuildContext context) {
    return is_conform
        ? SafeArea(
            child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.cyan[100],
              shadowColor: Colors.grey[700],
              title: Text("Pin Recovery",
                  style: GoogleFonts.abel(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  )),
            ),
            body: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Assets/atm-background.png"),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  Text(
                    (result_l.length > 1)
                        ? "Your Pin is '${result_l[1]} ${result_l[2]}'. Please don't forget this."
                        : "Your Pin is '${result_l[1]}'. Please don't forget this.",
                    style: GoogleFonts.abel(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[700]),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  border: Border.all(width: 3.0),
                                  borderRadius: BorderRadius.circular(25)),
                              height: 50,
                              width: 270,
                              child: FlatButton(
                                  onPressed: () => {
                                        Navigator.pushReplacementNamed(
                                            context, '/home')
                                      },
                                  child: Text(
                                    "HOME",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  )))
                        ]))
                  ]),
                  SizedBox(
                    height: 250,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
          ))
        : (is_otp
            ? SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.cyan[100],
                      shadowColor: Colors.grey[700],
                      title: Text("Pin Recovery",
                          style: GoogleFonts.abel(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          )),
                    ),
                    body: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("Assets/atm-background.png"),
                                fit: BoxFit.cover)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                "Enter Otp.",
                                style: GoogleFonts.abel(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey[700]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(600, 0, 600, 0),
                              child: TextField(
                                style: GoogleFonts.abel(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900],
                                ),
                                cursorColor: Colors.green,
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                obscureText: true,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      gapPadding: 0),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      gapPadding: 0),
                                ),
                                controller: get_otp,
                                textAlign: TextAlign.center,
                                maxLength: 6,
                              ),
                            ),
                            (is_processing)
                                ? SizedBox(
                                    height: 44,
                                  )
                                : SizedBox(
                                    height: 60,
                                  ),
                            (is_processing)
                                ? Center(
                                    child: CollectionSlideTransition(
                                      children: <Widget>[
                                        Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                        Icon(
                                          Icons.apps,
                                          color: Colors.green[700],
                                          size: 36,
                                        ),
                                        Icon(
                                          Icons.attach_money_sharp,
                                          color: Colors.deepPurple[700],
                                          size: 36,
                                        ),
                                        Icon(Icons.help),
                                        Icon(
                                          Icons.accessibility,
                                          color: Colors.blueGrey[400],
                                          size: 36,
                                        ),
                                        Icon(
                                          Icons.account_balance,
                                          color: Colors.pink[700],
                                          size: 36,
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            (is_processing)
                                ? SizedBox(
                                    height: 40,
                                  )
                                : SizedBox(
                                    height: 60,
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          border: Border.all(width: 3.0),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      height: 50,
                                      width: 270,
                                      child: FlatButton(
                                          onPressed: () => check_otp(),
                                          child: Text(
                                            "Proceed",
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            border: Border.all(width: 3.0),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        height: 50,
                                        width: 270,
                                        child: FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                get_otp.clear();
                                                is_processing = false;
                                              });
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.aBeeZee(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            )))
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 190,
                            ),
                          ],
                        ))),
                // This trailing comma makes auto-formatting nicer for build methods.
              )
            : SafeArea(
                child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.cyan[100],
                  shadowColor: Colors.grey[700],
                  title: Text("Pin Recovery",
                      style: GoogleFonts.abel(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      )),
                ),
                body: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("Assets/atm-background.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      is_mode_selected
                          ? (is_mode == "security question"
                              ? Text(
                                  'Fill the Answer of Security Question.',
                                  style: GoogleFonts.abel(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey[700]),
                                )
                              : Text(
                                  'Enter Your Registered Mobile Number.',
                                  style: GoogleFonts.abel(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey[700]),
                                ))
                          : Text(
                              'Select Pin Recovery Mode.',
                              style: GoogleFonts.abel(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700]),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      is_mode_selected
                          ? Container(
                              padding: EdgeInsets.fromLTRB(600, 0, 600, 0),
                              child: TextField(
                                style: GoogleFonts.abel(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900],
                                ),
                                cursorColor: Colors.green,
                                keyboardType: TextInputType.text,
                                autofocus: true,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      gapPadding: 0),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      gapPadding: 0),
                                ),
                                controller: get_value,
                                textAlign: TextAlign.center,
                                obscureText: (is_mode != 'otp') ? true : false,
                                maxLength: (is_mode == 'otp') ? 10 : 50,
                              ),
                            )
                          : SizedBox(
                              height: 85,
                            ),
                      (is_processing)
                          ? SizedBox(
                              height: 44,
                            )
                          : SizedBox(
                              height: 60,
                            ),
                      (is_processing)
                          ? Center(
                              child: CollectionSlideTransition(
                                children: <Widget>[
                                  Icon(
                                    Icons.money,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  Icon(
                                    Icons.apps,
                                    color: Colors.green[700],
                                    size: 36,
                                  ),
                                  Icon(
                                    Icons.attach_money_sharp,
                                    color: Colors.deepPurple[700],
                                    size: 36,
                                  ),
                                  Icon(Icons.help),
                                  Icon(
                                    Icons.accessibility,
                                    color: Colors.blueGrey[400],
                                    size: 36,
                                  ),
                                  Icon(
                                    Icons.account_balance,
                                    color: Colors.pink[700],
                                    size: 36,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                      (is_processing)
                          ? SizedBox(
                              height: 40,
                            )
                          : SizedBox(
                              height: 60,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                          ),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      border: Border.all(width: 3.0),
                                      borderRadius: BorderRadius.circular(25)),
                                  height: 50,
                                  width: 270,
                                  child: FlatButton(
                                      onPressed: is_mode_selected
                                          ? () => check_security()
                                          : () {
                                              setState(() {
                                                is_mode_selected = true;
                                                is_mode = "security question";
                                              });
                                            },
                                      child: Text(
                                        is_mode_selected
                                            ? "Proceed"
                                            : "Security Question",
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: is_press
                                              ? Colors.green
                                              : Colors.blue,
                                        ),
                                      ))),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    border: Border.all(width: 3.0),
                                    borderRadius: BorderRadius.circular(25)),
                                height: 50,
                                width: 270,
                                child: FlatButton(
                                    onPressed: is_mode_selected
                                        ? () {
                                            setState(() {
                                              get_value.clear();
                                              is_processing = false;
                                            });
                                          }
                                        : () {
                                            setState(() {
                                              is_mode = "otp";
                                              is_mode_selected = true;
                                            });
                                          },
                                    child: Text(
                                      is_mode_selected ? "Cencel" : "OTP",
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: is_press
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 190,
                      ),
                    ],
                  ),
                ),
              )));
  }

  _showMyDialog(context, String title, AlertType type) async {
    return await Alert(context: context, type: type, title: title, buttons: [
      DialogButton(
          child: Text(
            'Ok',
            style: GoogleFonts.aBeeZee(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          })
    ]).show();
  }
}
