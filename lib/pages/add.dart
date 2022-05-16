import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mantras_app/main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../notifications/notifications.dart';
import '../providers/primary_data_provider.dart';
import '../utils/colors.dart';
import '../utils/snackbar.dart';
class AddNotifications extends StatefulWidget {
  const AddNotifications({Key? key}) : super(key: key);

  @override
  _AddNotificationsState createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  late double widthScale;
  final databaseReference = FirebaseDatabase.instance.reference();
  late double heightScale;
  String? selectedDate;
  List<String> dropDownList2 = ["Repeat", "Once"];
  String? selectedRepeatType = '';
  String? selectedAffirmation = '';
  int? hour, minute;

  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 390;
    heightScale = MediaQuery.of(context).size.height / 845;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Schedule Notifications'),

      ),
        body: Container(
          margin: EdgeInsets.only(
              left: 14 * widthScale, right: 14 * widthScale, top: 20 * widthScale),
          padding: EdgeInsets.only(top: 16 * heightScale, bottom: 16 * heightScale),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x18000000),
                  offset: Offset(0, 2),
                  blurRadius: 7,
                  spreadRadius: 0)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8 * heightScale, top: 8 * heightScale),
                  child: Text(
                    'Add your Affirmations notification',
                    style: TextStyle(fontSize: 16 * widthScale),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.only(
                    left: 24 * widthScale,
                    right: 18 * widthScale,
                    bottom: 4 * heightScale,
                    top: 8 * heightScale),
                child: Text(
                  'Affirmations',
                  style: TextStyle(fontSize: 14 * widthScale, color: kPurple),
                ),
              ),
              Consumer<ProviderDataProvider>(builder: (context, provider, child) {
                return Container(
                  height: 64 * heightScale,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 12 * widthScale, right: 12 * widthScale),
                  margin: EdgeInsets.only(
                      left: 18 * widthScale,
                      right: 18 * widthScale,
                      top: 8 * heightScale,
                      bottom: 8 * heightScale),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    border: Border.all(color: Colors.grey, width: 0.25),
                  ),
                  child: Center(
                    child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: widthScale * 24,
                        ),
                        //underline: SizedBox(),
                        decoration: const InputDecoration(border: InputBorder.none),
                        hint: Text(
                          'Select Affirmation (From Favorites)',
                          style: TextStyle(
                              color: const Color(0xff9e9e9e),
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: widthScale * 15.5),
                        ),
                        items: provider.favouriteList.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.5 * widthScale)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAffirmation = value;
                          });
                        }),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.only(
                    left: 24 * widthScale,
                    right: 18 * widthScale,
                    bottom: 4 * heightScale,
                    top: 8 * heightScale),
                child: Text(
                  'Time',
                  style: TextStyle(fontSize: 14 * widthScale, color: kPurple),
                ),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showTime12hPicker(context, showTitleActions: true,
                      onChanged: (date) {
                        setState(() {
                          selectedDate = DateFormat('hh:mm a').format(date);
                          hour = date.hour;
                          minute = date.minute;
                        });
                      }, onConfirm: (date) {
                        setState(() {
                          selectedDate = DateFormat('hh:mm a').format(date);
                          hour = date.hour;
                          minute = date.minute;
                        });
                      }, currentTime: DateTime.now());
                },
                child: Container(
                  height: 64 * heightScale,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 12 * widthScale, right: 12 * widthScale),
                  margin: EdgeInsets.only(
                      left: 18 * widthScale,
                      right: 18 * widthScale,
                      top: 8 * heightScale,
                      bottom: 8 * heightScale),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    border: Border.all(color: Colors.grey, width: 0.25),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      selectedDate ?? 'Select Time',
                      style: selectedDate == null
                          ? TextStyle(
                          color: const Color(0xff9e9e9e),
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.5 * widthScale)
                          : TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.5 * widthScale),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 24 * widthScale,
                    right: 18 * widthScale,
                    bottom: 4 * heightScale,
                    top: 8 * heightScale),
                child: Text(
                  'Repeat Type',
                  style: TextStyle(fontSize: 14 * widthScale, color: kPurple),
                ),
              ),
              Container(
                height: 64 * heightScale,
                width: double.infinity,
                padding: EdgeInsets.only(left: 12 * widthScale, right: 12 * widthScale),
                margin: EdgeInsets.only(
                    left: 18 * widthScale,
                    right: 18 * widthScale,
                    top: 8 * heightScale,
                    bottom: 8 * heightScale),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  border: Border.all(color: Colors.grey, width: 0.25),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    //value: selectedAffirmation,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: widthScale * 24,
                      ),
                      //underline: SizedBox(),
                      decoration: const InputDecoration(border: InputBorder.none),
                      hint: Text(
                        'Select Repeat Type',
                        style: TextStyle(
                            color: const Color(0xff9e9e9e),
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            fontSize: widthScale * 15.5),
                      ),
                      items: dropDownList2.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.5 * widthScale)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRepeatType = value;
                        });
                      }),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 18 * widthScale, top: 8 * heightScale),
                  child: SizedBox(
                    width: 120 * widthScale,
                    height: 48 * heightScale,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedAffirmation == '') {
                          SnackBarMessage.show(
                              context: context, message: "Please select a Affirmation");
                        } else if (hour == null || minute == null) {
                          SnackBarMessage.show(
                              context: context, message: "Please select a time");
                        } else if (selectedRepeatType == '') {
                          SnackBarMessage.show(
                              context: context, message: "Please select a repeat type");
                        } else {
                          LocalNotifications.showScheduledNotification(
                              id: int.parse('$hour$minute'),
                              title: 'Affirmation for the Day',
                              body: '$selectedAffirmation',
                              payload: 'payload 1',
                              hour: hour!,
                              minute: minute!,
                              type: selectedRepeatType!);
                          SnackBarMessage.show(
                              context: context, message: "Notification setup success");
                          setState(() {
                            selectedDate = null;
                            selectedAffirmation = '';
                            selectedRepeatType = '';
                          });
                          var key = databaseReference.push().key;
                          databaseReference.child('notifications').child(key.toString()).set({
                            'date': DateTime.now().toString(),
                            'time': hour.toString() + ':' + minute.toString(),
                            'device' : DEVICE_ID ,
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: kPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0 * widthScale),
                        ),
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 15 * widthScale,
                            fontFamily: "Poppins",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
