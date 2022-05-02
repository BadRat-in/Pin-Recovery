import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:atm_pin_recovery/files.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class W_Window extends StatefulWidget {
  @override
  _W_WindowState createState() => _W_WindowState();
}

class _W_WindowState extends State<W_Window> {
  bool is_processing = false;
  int pin = 0;
  String namef = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_name();
  }

  get_name() async {
    String name = await Savefile.readNamefile();
    setState(() {
      namef = name;
    });
    await _showMyDialog(context, 'Success.', AlertType.success);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      "Welcome '$namef'",
                      style: GoogleFonts.abel(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                            create_button('PIN CHANGE'),
                            SizedBox(
                              height: 15,
                            ),
                            create_button('MINI STATEMENT'),
                            SizedBox(
                              height: 15,
                            ),
                            create_button('BILL PAYMENTS'),
                            SizedBox(
                              height: 15,
                            ),
                            create_button("SERVICES")
                          ])),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          create_button('CASH WITHDRAWAL'),
                          SizedBox(
                            height: 15,
                          ),
                          create_button('FAST CASH'),
                          SizedBox(
                            height: 15,
                          ),
                          create_button('BALANCE INQUIRY'),
                          SizedBox(
                            height: 15,
                          ),
                          create_button('FUND TRANSFER')
                        ],
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget create_button(String name) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.orange,
          border: Border.all(width: 3.0),
          borderRadius: BorderRadius.circular(25)),
      height: 50,
      width: 300,
      child: FlatButton(
          onPressed: () {},
          child: Text(
            name,
            style: GoogleFonts.aBeeZee(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )),
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
