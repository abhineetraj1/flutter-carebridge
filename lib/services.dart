import 'package:carebridge/database.dart';
import 'package:carebridge/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

generateOtp() {
  var random = Random();
  int otp = random.nextInt(9000) + 1000;
  return otp.toString();
}

Future determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  if (permission == LocationPermission.deniedForever) return false;
  var pos =  await Geolocator.getCurrentPosition();
  return pos;
}

class DropDownAccType extends StatefulWidget {
  const DropDownAccType({super.key});

  @override
  State<DropDownAccType> createState() => _DropDownAccTypeState();
}

class _DropDownAccTypeState extends State<DropDownAccType> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("User type", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: DropdownButton(items: [
              DropdownMenuItem(value: "User", child: Text("User")),
              DropdownMenuItem(value: "Caretaker", child: Text("Caretaker")),
            ], onChanged: (value) {
              setState(() {
                type = value?? "User";
              });
            }, value: type,),
          ),
        )
      ],
    );
  }
}

verifyOtp(context, otp) async {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () async {
      var t = await verify_otp(otp);
      if (t != false) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
      } else {
        showAlertDialog(context, "OTP", "Invalid OTP");
      }
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Verify OTP"),
    content: Text("Enter your OTP"),
    actions: [
      okButton,
    ],
  );
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

service_login(context, email, password) async{
  if (await login(email, password)) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
  } else {
    showAlertDialog(context, "Login", "Invalid email or password");
  }
}

service_signup(context, name, email, phone, type, password) async{
  if (await signup(name, email, phone, type, password)) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Home();
    }));
  } else {
    showAlertDialog(context, "Signup", "Email already exists");
  }
}

service_booking(context) async{
  if (data["type"] == "User") {
    await EnableCaretakerSearch();
    if (await LookForBookings("User")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Success();}));
    } else {
      if (BookStatus) {
        Future.delayed(Duration(seconds: 2), () async{service_booking(context);});
      } else {
        cancelBooking();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
      }
    }
  } else {
    if (await bookPatient()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Success();}));
    } else {
      if (BookStatus) {
        Future.delayed(Duration(seconds: 2), () async{service_booking(context);});
      } else {
        cancelBooking();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
      }
    }
  }
}

service_prior_booking(context) async{
  if (data["type"] == "User") {
    if (await LookForBookings("User")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Success();}));
    }
  } else {
    if (await LookForBookings("Caretaker")) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Success();}));
    }
  }
}

service_cancel_booking(context) async{
  await cancelBooking();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
}

showAlertDialog(BuildContext context, String title, String message) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

service_otp_verification(BuildContext context) async {
  var a = TextEditingController();
  Widget okButton = TextButton(
    child: Text("verify"),
    onPressed: () {
      verify(context, a.text);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Verify OTP"),
    content: TextField(
      controller: a,
      decoration: InputDecoration(
        hintText: "Enter OTP",
      ),
    ),
    actions: [
      okButton,
    ],
  );
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

context_check_if_not_cancelled(BuildContext context) async {
  if (!await check_if_not_cancelled()) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
    BookStatus = false;
  } else {
    if (BookStatus) {
      Future.delayed(Duration(seconds: 2), () async{context_check_if_not_cancelled(context);});
    }
  }
}

verify(context, otp) async {
  if (await verify_otp(otp)) {
    BookStatus = false;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Home();}));
    showAlertDialog(context, "OTP", "OTP verified successfully");
  } else {
    showAlertDialog(context, "OTP", "Invalid OTP");
  }
}