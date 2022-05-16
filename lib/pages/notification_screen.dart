import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mantras_app/main.dart';
import 'package:flutter_mantras_app/notifications/notifications.dart';
import 'package:flutter_mantras_app/pages/add.dart';
import 'package:flutter_mantras_app/providers/primary_data_provider.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:flutter_mantras_app/utils/snackbar.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late double widthScale;
  late double heightScale;

  bool activity = true;
  bool friends = false;
  var controller = PageController(initialPage: 0);

  // for scheduled notifications
  bool isExpand = false;
  List<String> dropDownList2 = ["Repeat", "Once"];


  // for random notifications
  List<String> selectedList = [];
  final repeatList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int selectedValue = 1;

  @override
  void initState() {
    super.initState();
    LocalNotifications.init(initScheduled: true);
  }

  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 390;
    heightScale = MediaQuery.of(context).size.height / 845;
    return Scaffold(
      body: Column(
        children: [
          /// top bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28 * widthScale),
                  bottomRight: Radius.circular(28 * widthScale)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x18000000), offset: Offset(0, 4), blurRadius: 18, spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: Column(children: [
              /// top title bar
              Padding(
                padding: EdgeInsets.only(
                  top: 65 * heightScale,
                ),
                child: Text('Notification', style: TextStyle(fontSize: 18 * widthScale)),
              ),

              ///divider
              Padding(
                padding: EdgeInsets.only(top: 16.0 * heightScale, bottom: 16 * heightScale),
                child: const Divider(),
              ),

              /// tab bar
              Padding(
                padding: EdgeInsets.only(bottom: 40 * heightScale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    activity == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Random Notification",
                                style: TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0 * widthScale),
                              ),
                              Container(
                                width: 145 * widthScale,
                                height: 4 * widthScale,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3.5)),
                                  color: kPurple,
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              onAddButtonTapped(0);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Random Notification',
                                  style: TextStyle(
                                      color: const Color(0xff969696),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0 * widthScale),
                                ),
                                SizedBox(
                                  width: 145 * widthScale,
                                  height: 4 * widthScale,
                                ),
                              ],
                            ),
                          ),
                    friends == false
                        ? GestureDetector(
                            onTap: () {
                              onAddButtonTapped(1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Schedule Notification',
                                  style: TextStyle(
                                      color: const Color(0xff969696),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0 * widthScale),
                                ),
                                SizedBox(
                                  width: 150 * widthScale,
                                  height: 4 * widthScale,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Schedule Notification',
                                style: TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0 * widthScale),
                              ),
                              Container(
                                width: 150 * widthScale,
                                height: 4 * widthScale,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3.5)),
                                  color: kPurple,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ]),
          ),

          /// body section
          Expanded(
            child: PageView(
                onPageChanged: _onPageViewChange,
                allowImplicitScrolling: false,
                scrollDirection: Axis.horizontal,
                controller: controller,
                children: [
                  /// random notification body
                  randomBody(),

                  /// scheduled notification body
                  scheduleBody()
                ]),
          ),
        ],
      ),
    );
  }

  /// random notification body
  Widget randomBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0 * heightScale, left: 20 * widthScale),
              child: Text(
                'Select the Affirmations you want',
                style: TextStyle(
                  fontSize: 16 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 14 * widthScale, right: 14 * widthScale, top: 16.0 * heightScale),
            height: 250 * heightScale,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x18000000), offset: Offset(0, 2), blurRadius: 7, spreadRadius: 0)
              ],
            ),
            child: Consumer<ProviderDataProvider>(builder: (context, provider, child) {
              return ListView.builder(
                padding: EdgeInsets.only(
                    left: 4 * widthScale,
                    right: 4 * widthScale,
                    top: 8 * heightScale,
                    bottom: 8 * heightScale),
                shrinkWrap: true,
                itemCount: provider.affList.length,
                itemBuilder: (context, index1) {
                  return Theme(
                    data: ThemeData().copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        provider.affList[index1].title.toString(),
                        style: TextStyle(
                          fontSize: 16 * widthScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: <Widget>[
                        Column(
                          children: provider.affList[index1].subcategories!
                              .map((e) => ListTile(
                            onTap: () {
                              setState(() {
                                if (selectedList.contains(e)) {
                                  selectedList.removeWhere((element) => element == e);
                                } else {
                                  selectedList.add(e);
                                }
                              });
                            },
                            title: Text(
                              e,
                              style: TextStyle(fontSize: 15.5 * widthScale),
                            ),
                            trailing: Icon(
                              selectedList.contains(e)
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked,
                              color: selectedList.contains(e) ? kPurple : Colors.grey,
                              size: 24 * widthScale,
                            ),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0 * heightScale, left: 20 * widthScale),
              child: Text(
                'How often do you want affirmation',
                style: TextStyle(
                  fontSize: 16 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 14 * widthScale, right: 14 * widthScale, top: 16.0 * heightScale),
            padding: EdgeInsets.only(left: 32 * widthScale, right: 40 * widthScale),
            height: 100 * heightScale,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x18000000), offset: Offset(0, 2), blurRadius: 7, spreadRadius: 0)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily',
                  style: TextStyle(fontSize: 15.5 * widthScale),
                ),
                SizedBox(
                  width: 120 * widthScale,
                  height: 100 * heightScale,
                  child: CupertinoPicker(
                      useMagnifier: false,
                      //scrollController: fTypeController,
                      backgroundColor: Colors.transparent,
                      selectionOverlay: Container(
                        decoration: BoxDecoration(
                          color: kPurple.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(Radius.circular(22)),
                        ),
                      ),
                      itemExtent: 40 * heightScale,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedValue = repeatList[index];
                        });
                      },
                      children: repeatList
                          .map(
                            (e) => Center(
                              child: Text(
                                "$e",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16 * widthScale, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                          .toList()),
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Container(
            width: 300,
            height: 50,
            child: ElevatedButton(

              onPressed: () async {
                Random random = new Random();

                for(int index=0;index<selectedList.length;index++){

                  for(int a=0;a<selectedValue;a++){
                    int hour = random.nextInt(23) + 0;
                    int minute = random.nextInt(59) + 0;
                    LocalNotifications.showScheduledNotification(
                        id: int.parse('$hour$minute'),
                        title: 'Affirmation for the Day',
                        body: selectedList[index],
                        payload: 'payload 1',
                        hour: hour!,
                        minute: minute!,
                        type: 'Once');
                  }
                }
                SnackBarMessage.show(
                    context: context, message: "Random Notification setup success");
              },
              style: ElevatedButton.styleFrom(
                primary: kPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0 * widthScale),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(
                    fontSize: 15 * widthScale,
                    fontFamily: "Poppins",
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 40,),

        ],
      ),
    );
  }

  /// scheduled notifications body
  Widget scheduleBody() {
    final usersQuery = FirebaseDatabase.instance.ref('notifications').orderByChild('device').equalTo(DEVICE_ID);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotifications()),
          );
        },
        backgroundColor: kPurple,
        child: Icon(Icons.add),
      ),
      body: FirebaseDatabaseListView(
        query: usersQuery,
        itemBuilder: (context, snapshot) {
        var map = jsonEncode(snapshot.value);
        var data = jsonDecode(map);
          return Container(

            margin: EdgeInsets.only(left: 15,right: 15,top: 05,bottom: 05),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kPurple.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10)
              )
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_active,color: kPurple,size: 35,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shedulue Notification #' + snapshot.key.toString().substring(13,snapshot.key.toString().length),style: TextStyle(
                      fontSize: 18
                    ),),
                    SizedBox(height: 05,),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,size: 15,),
                        Text(data['date'].toString().substring(0,10) ,style: TextStyle(
                            fontSize: 15
                        ),)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.watch_later,size: 15,),
                        Text(data['time'].toString(),style: TextStyle(
                            fontSize: 15
                        ),)
                      ],
                    )
                  ],
                ),
              ],
            )
          );
        },
      ),
    );
  }

  onAddButtonTapped(int index) {
    controller.jumpToPage(index);
  }

  _onPageViewChange(int page) {
    if (page == 0) {
      setState(() {
        activity = true;
        friends = false;
      });
    } else {
      setState(() {
        friends = true;
        activity = false;
      });
    }
  }
}
