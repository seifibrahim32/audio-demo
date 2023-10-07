
import 'package:flutter/material.dart';
import 'package:itargs_task/core/static/styles.dart';

showAlertDialog(String text,BuildContext context) async{

  AlertDialog alert = AlertDialog(
    contentTextStyle: kError,
    content: SizedBox(
      height:240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.error,color: Colors.red,size:100),
          Text(text,textAlign: TextAlign.center),
          MaterialButton(
            elevation: 2,
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('HIDE',
              style: kButtonError,),
          )
        ],
      ),
    ),
  );

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}