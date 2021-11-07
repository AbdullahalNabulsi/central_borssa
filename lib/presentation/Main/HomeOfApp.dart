import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/presentation/Admin/Profile.dart';
import 'package:central_borssa/presentation/Share/Welcome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/Central_Borssa.dart';

import '..//Home/MainChat.dart';
import '../Home/All_post.dart';
import '../Home/Company_Profile.dart';

class HomeOfApp extends StatefulWidget {
  home_page createState() => home_page();
}

// ignore: camel_case_types
class home_page extends State<HomeOfApp>
    with AutomaticKeepAliveClientMixin<HomeOfApp> {
  int selectedPage = 0;
  late LoginBloc _loginBloc;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  int companyuser = 0;
  late int userActive = 0;
  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await FirebaseMessaging.instance.getToken();
    _loginBloc.add(FireBaseTokenEvent(fcmToken: token));
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    print(userPhone);
    userLocation = "Empty";
    userPermissions = prefs.getStringList('permissions')!.toList();
    var y = userPermissions.contains('Update_Auction_Price_Permission');
    print('user permission$y');
    print(userLocation);
    companyuser = int.parse(prefs.get('companyid').toString());
    print(companyuser);
    userType = prefs.get('roles').toString();
    setState(() {});
  }

  fireBase() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      print("message open");
      if (event.notification!.body != null) {
        if (userPermissions.contains('Chat_Permission')) {
          if (event.data['type'] == "currency_price_change") {
            choosePage(1);
          } else if (event.data['type'] == "renew_subscription") {
            print(event.data['type']);
          } else if (event.data['type'] == "new_chat") {
            print(event.data['type']);
          } else if (event.data['type'] == "new_followed_post") {
            print(event.data['type']);
            var value = event.data['id'];
            print(value['data']);
          }
        } else if (userPermissions.contains('Trader_Permission')) {
          choosePage(0);
        } else if (userPermissions
            .contains('Update_Auction_Price_Permission')) {
          if (event.data['type'] == "currency_price_change") {
            choosePage(0);
          }
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
  //test

  callBody(int value) {
    if (userPermissions.contains('Chat_Permission')) {
      switch (value) {
        case 0:
          return AllPost();
        case 1:
          return CentralBorssa();
        case 2:
          return MainChat();
        case 3:
          return CompanyProfile();
          // ignore: dead_code
          break;
        default:
      }
    } else if (userPermissions.contains('Trader_Permission')) {
      switch (value) {
        case 0:
          return CentralBorssa();
        case 1:
          return CompanyProfile();
          // ignore: dead_code
          break;
        default:
      }
    } else if (userPermissions.contains('Update_Auction_Price_Permission')) {
      switch (value) {
        case 0:
          return CentralBorssa();
        case 1:
          return Profile();
          // ignore: dead_code
          break;
        default:
      }
    }
  }

  late Future navbarbottom;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    fireBase();
    navbarbottom = sharedValue();
    super.initState();
  }

  void choosePage(int index) {
    if (selectedPage != index) {
      setState(() {
        selectedPage = index;
      });
    }
  }

  logout() async {
    print('from');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return FutureBuilder(
        future: navbarbottom,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Welcome();
            case ConnectionState.none:
              return Welcome();
            case ConnectionState.active:
              return Welcome();
            case ConnectionState.done:
              return Scaffold(
                  key: _scaffoldKey,
                  body: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is FcmTokenLoading) {
                        print(state);
                      } else if (state is FcmTokenLoaded) {
                        print(state);
                      } else if (state is FcmTokenError) {
                        print(state);
                      }
                    },
                    child: callBody(selectedPage),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Color(navbar.hashCode),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white.withOpacity(.60),
                    selectedFontSize: 14,
                    unselectedFontSize: 14,
                    currentIndex: selectedPage,
                    onTap: choosePage,
                    items: [
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'الرئيسية',
                          icon: Icon(Icons.home),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'البورصة',
                          icon: Icon(Icons.attach_money),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'المحادثة',
                          icon: Icon(Icons.chat_outlined),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                    ],
                  ));

              // ignore: dead_code
              break;
            default:
              return Scaffold(
                  key: _scaffoldKey,
                  body: callBody(selectedPage),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Color(navbar.hashCode),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white.withOpacity(.60),
                    selectedFontSize: 14,
                    unselectedFontSize: 14,
                    currentIndex: selectedPage,
                    onTap: choosePage,
                    items: [
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'الأساسية',
                          icon: Icon(Icons.home),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'مزاد العملات',
                          icon: Icon(Icons.attach_money),
                        ),
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'المحادثة',
                          icon: Icon(Icons.chat_outlined),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                      if (userPermissions
                          .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                    ],
                  ));
          }
        });
  }
}
