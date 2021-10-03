import 'package:central_borssa/presentation/Auction/Price_Chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_pusher/pusher.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CentralBorssa extends StatefulWidget {
  CentralBorssaPage createState() => CentralBorssaPage();
}

class CentralBorssaPage extends State<CentralBorssa> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late List<City> cities2 = [];
  late List<CurrencyPrice> currencyprice = [];
  late bool isloading = true;
  late BorssaBloc bloc;
  late Channel _ourChannel;
  late String? test;
  late String startpoint;
  late String endpoint;

  @override
  void initState() {
    bloc = BlocProvider.of<BorssaBloc>(context);
    var now = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = newFormat.format(now);
    startpoint = '$updatedDt 10:00:00.00';
    endpoint = DateTime.now().toString();
    bloc.add(AllCity());
    print(startpoint);
    print(endpoint);
    currencyprice.clear();

    pusherTerster();
    super.initState();
  }

  Future<void> pusherTerster() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      test = _pref.get('roles').toString();
      // print(test);
      await Pusher.init(
          'borsa_app',
          PusherOptions(
              cluster: 'mt1',
              host: 'www.ferasalhallak.online',
              encrypted: false,
              port: 6001));
    } catch (e) {
      print(e);
    }
    Pusher.connect(onConnectionStateChange: (val) {
      print(val!.currentState);
    }, onError: (error) {
      print(error!.message);
    });

    //Subscribe
    _ourChannel = await Pusher.subscribe('PriceChannel');

    //Bind
    _ourChannel.bind('Change', (onEvent) {
      print(onEvent!.data);
      bloc.add(AllCity());
    });
  }

  Widget dataTable() {
    return DataTable(

        // dataRowHeight: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff505D6E),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        sortColumnIndex: 0,
        sortAscending: true,
        columnSpacing: 70,
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => Color(0xff7d8a99),
        ),
        columns: [
          DataColumn(
            label: Text(
              'العرض',
              style: TextStyle(
                fontSize: 18,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
              label: Text(
            'الطلب',
            style: TextStyle(
              fontSize: 18,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.bold,
            ),
          )),
          DataColumn(
              label: Text(
            'المدينة',
            style: TextStyle(
              fontSize: 18,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
        rows: [
          for (int i = 0; i < currencyprice.length; i++)
            DataRow(cells: [
              DataCell(
                  Row(
                    children: [
                      currencyprice[i].buyStatus == "down"
                          ? Icon(
                              Icons.arrow_circle_up,
                              color: Colors.green[700],
                            )
                          : Icon(
                              Icons.arrow_circle_down,
                              color: Colors.red[700],
                            ),
                      Text(
                        currencyprice[i].buy.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ), onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceChart(
                        cityid: currencyprice[i].city.id,
                        fromdate: startpoint,
                        todate: endpoint),
                  ),
                );
              }
                  //     showEditIcon:
                  //         test!.toLowerCase() == "admin"
                  //             ? true
                  //             : false, onTap: () {
                  //   var route = new MaterialPageRoute(
                  //       builder: (BuildContext contex) =>
                  //           new BlocProvider(
                  //             create: (context) => CurrencyBloc(
                  //                 CurrencyInitial(),
                  //                 CurrencyRepository()),
                  //             child: UpdatePrice(
                  //               id: currencyprice[i].id,
                  //               buy: currencyprice[i].buy,
                  //               sell: currencyprice[i].sell,
                  //             ),
                  //           ));

                  //   BlocProvider(
                  //       create: (context) => CurrencyBloc(
                  //           CurrencyInitial(),
                  //           CurrencyRepository()));
                  //   Navigator.of(context).push(route);
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(
                  //   //       builder: (context) => UpdatePrice()),
                  //   // );
                  // }
                  ),
              DataCell(
                Row(
                  children: [
                    currencyprice[i].sellStatus == "down"
                        ? Icon(
                            Icons.arrow_circle_up,
                            color: Colors.green[700],
                          )
                        : Icon(
                            Icons.arrow_circle_down,
                            color: Colors.red[700],
                          ),
                    Text(
                      currencyprice[i].sell.toStringAsFixed(2),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(
                currencyprice[i].city.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                ),
              ))
            ]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BorssaBloc, BorssaState>(
        listener: (context, state) {
          if (state is BorssaReloadingState) {
            print(state);
          } else if (state is GetAllCityState) {
            print(state);
            currencyprice = state.cities;
            setState(() {
              isloading = false;
            });
          } else if (state is BorssaErrorLoading) {
            print(state);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('خطأ في التحميل'),
                action: SnackBarAction(
                  label: 'تنبيه',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                isloading
                    ? Container(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(
                        width: double.infinity,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: dataTable()),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}