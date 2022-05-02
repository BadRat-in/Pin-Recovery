import 'package:atm_pin_recovery/reset_pin.dart';
import 'package:atm_pin_recovery/w_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:atm_pin_recovery/files.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/w_window': (context) => W_Window(),
        '/reset_pin': (context) => Reset_Pin(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController pin_controller = TextEditingController();
  String entered_pin;
  bool is_press = false, is_wrong = false;
  bool is_processing = false;
  int ic_counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pin_controller.addListener(() {
      getpin();
    });
  }

  getpin() {
    entered_pin = pin_controller.text;
  }

  void check_pin() async {
    if (pin_controller.text.length == 4) {
      setState(() {
        is_processing = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      var Url = Uri.parse("https://atmdb.000webhostapp.com/get_pin.php");
      // var Url = Uri.parse("http://192.168.43.4/Ex_5/get_pin.php");
      var data = {
        "pin": pin_controller.text,
      };

      var result = await http.post(Url, body: data);
      result.headers['Access-Control-Allow-Origin: *'];
      String result_s = result.body;
      List result_l = result_s.split(" ");
      await Savefile.saveNamefile(result_l[1]);
      if (result_l[0] == 'true') {
        Navigator.pushReplacementNamed(context, '/w_window');
      } else {
        ic_counter = ic_counter + 1;
        if (ic_counter < 3) {
          _showMyDialog(context, 'Incorrect Pin..!', AlertType.warning);
        }
        setState(() {
          pin_controller.clear();
          is_processing = false;
        });
        if (ic_counter > 2) {
          Alert(
                  context: context,
                  buttons: [
                    DialogButton(
                        child: Text(
                          'Yes',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/reset_pin');
                        }),
                    DialogButton(
                        child: Text(
                          'No',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  title: 'Do you want to Reset your Pin.',
                  type: AlertType.info)
              .show();
        }
      }
    } else {
      _showMyDialog(context, 'Invalid Pin', AlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Assets/atm-background.png"),
                      fit: BoxFit.cover)),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Center(
                  child: Text(
                    "Enter Your Pin.",
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          gapPadding: 0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          gapPadding: 0),
                    ),
                    controller: pin_controller,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    maxLength: 4,
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
                              borderRadius: BorderRadius.circular(25)),
                          height: 50,
                          width: 270,
                          child: FlatButton(
                              onPressed: () => check_pin(),
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
                                borderRadius: BorderRadius.circular(25)),
                            height: 50,
                            width: 270,
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    pin_controller.clear();
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
              ]))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
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
