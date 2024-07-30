import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../src/preference.dart';
import 'gen/assets.gen.dart';
import 'screen/perkara/page.dart';
import 'screen/perkaraNama/page.dart';
import 'screen/profile/page.dart';
import 'src/api.dart';
import 'src/constant.dart';
import 'src/dialog_info.dart';
import 'src/toast.dart';
import 'src/utils.dart';
import 'package:http/http.dart' as http;

class MainTabBar extends StatefulWidget {
  final id;
  // final token;
  const MainTabBar({
    Key? key,
    required this.id,
    // required this.token
  }) : super(key: key);

  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  SharedPref sharedPref = SharedPref();
  bool isProcess = false;
  int pageIndex = 0;
  String fullName = "";
  String division = "";
  String typeUser = "";
  String path = "";
  String accessToken = "";
  String dateString = "";
  late final Function(int) callback;
  String message = "";
  List<Map<String, dynamic>> listData = [];
  List listDataHistoryMonth = [];
  List listDataHistoryWeek = [];
  List listDataHistoryDay = [];
  String messagess = "";
  List<Widget> pages = <Widget>[]; // Declare pages here
  String? id = '';

  String fullname = "";
  late int userId = 0;

  var offset = 0;
  var limit = 10;

  @override
  void initState() {
    // getData(id);
    initializeData();
    // pageIndex = widget.page;
    super.initState();
  }

  void initializeData() async {
    id = await sharedPref.getPref('id_usr');
    print("idsblm $id");
    var userId = id.toString; // Adjust based on your shared preferences service
    print("idsesudah $userId");

    getData(id);
  }

  getData(id) async {
    pages = [
      // ChatRoomPage(senderId: userId.toString(), data: listDataHistoryDay, image: path),
    ];
    try {
      var accessToken = await sharedPref.getPref("access_token");
      // id = await sharedPref.getPref('id_usr');
      // var userId = id.toString;

      print("accestoke");
      print(accessToken);
      var url = ApiService.detailUser;
      var uri = "$url/$id";
      var bearerToken = 'Bearer $accessToken';
      var response = await http.get(Uri.parse(uri),
          headers: {"Authorization": bearerToken.toString()});
      print(url);
      print(bearerToken);
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          var content = json.decode(response.body);
          print("getdatauser");
          print(content);

          fullname = content['data']['fullname'];
          division = content['data']['getrole']['name'];
          listData.add(content['data']);
          userId = content['data']['id'];
          path = content['data']['image'];
        });
      } else {
        toastShort(context, message);
      }
    } catch (e) {
      toastShort(context, e.toString());
    }

    setState(() {
      isProcess = true;
    });
  }

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clrPrimary,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingLogic(id: widget.id),
                    ),
                  );
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          '${ApiService.folder}/$path',
                          scale: 8,
                        ),
                        fit: BoxFit.fill),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullname,
                    style: SafeGoogleFont(
                      'SF Pro Text',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.2575,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    division,
                    style: SafeGoogleFont(
                      'SF Pro Text',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.2575,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            perencanaan(),
          ],
        ),
      )),
    );
  }

  Widget perencanaan() {
    List<Location> locations = [
      Location(
        address: "Data Pegawai",
        color: Colors.black,
        imagePath: Assets.images.user3.path,
        colorText: Colors.white,
        state: 'Data pegawai By NIP',
      ),
      // Location(
      //   address: "Data Satker",
      //   color: const Color.fromARGB(255, 33, 104, 34),
      //   imagePath: Assets.icons.icKejaksaanLogo.path,
      //   colorText: Colors.white,
      //   state: 'Data perkara By Nama',
      // ),
    ];

    return SizedBox(
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PerkaraPage(),
                  ),
                );
              }
              // else if (index == 1) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const PerkaraNamaPage(),
              //     ),
              //   );
              // }
              else {
                onBasicAlertPressed(context, "500", "Menu belum dibuat");
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: 250.0,
                decoration: BoxDecoration(
                  color: locations[index].color,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(46, 52, 61, 0.42),
                      spreadRadius: 0.5,
                      blurRadius: 8.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      child: const Icon(Icons.search, color: Colors.white, size: 40,),
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //       image: AssetImage(Assets.images.user2.path),
                      //       fit: BoxFit.fill),
                      //   shape: BoxShape.circle,
                      // ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 10),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${locations[index].address} \n",
                                    style: const TextStyle(
                                      color: clrPrimary,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: locations[index].state,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 15.0,
          );
        },
        itemCount: locations.length,
      ),
    );
  }
}

class Location {
  final String address;
  final String state;
  final Color color;
  final Color colorText;
  final String imagePath;

  Location({
    required this.address,
    required this.color,
    required this.colorText,
    required this.imagePath,
    required this.state,
  });
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
