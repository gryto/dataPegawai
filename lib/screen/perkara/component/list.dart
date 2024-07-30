import 'dart:convert';
import 'package:data_pegawai/screen/perkara/component/biodata.dart';
import 'package:data_pegawai/screen/perkara/component/pendidikan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../src/api.dart';
import '../../../src/constant.dart';
import '../../../src/loader.dart';
import '../../../src/preference.dart';
import '../../../src/utils.dart';
import '../../../widgets/custom_list_item.dart';
import 'package:badges/badges.dart' as badges;

import 'jabatan.dart';
import 'keluarga.dart';

// ignore: must_be_immutable
class ListPerkara extends StatefulWidget {
  String nik;
  ListPerkara({super.key, required this.nik});

  @override
  State<ListPerkara> createState() => _ListPerkaraState();
}

class _ListPerkaraState extends State<ListPerkara>
    with SingleTickerProviderStateMixin {
  SharedPref sharedPref = SharedPref();
  String message = "";
  bool isProcess = true;
  List listData = [];
  int idPegawai = 0;

  late TabController controller;
  int selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();

  final ctrlTanggal = TextEditingController();

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    setState(() {});
    getData(widget.nik);
    print("NIK");
    print(widget.nik);

    super.initState();
  }

  getData(nik) async {
    try {
      final params = {
        'nip': nik,
      };
      var accessToken = await sharedPref.getPref("access_token");
      var url = ApiService.getAllPegawai;
      var uri = url;
      var bearerToken = 'Bearer $accessToken';
      var response = await http.post(Uri.parse(uri),
          headers: {"Authorization": bearerToken.toString()}, body: params);
      var content = json.decode(response.body);

      if (response.statusCode == 200) {
        var content = json.decode(response.body);
        print("datanya");
        listData.add(content['data']);
        print(listData);
        print("idpegwai");
        idPegawai = content['data']['id'];
        print(idPegawai);

      } else {
        // ignore: use_build_context_synchronously
        // onBasicAlertPressed(context, 'Error', content['message']);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      // onBasicAlertPressed(context, 'Error', e.toString());
      // toastShort(context, e.toString());
    }

    setState(() {
      isProcess = true;
    });
  }

    @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: const [],
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Data Pegawai",
          style: SafeGoogleFont(
            'SF Pro Text',
            fontSize: 22,
            fontWeight: FontWeight.w500,
            height: 1.2575,
            letterSpacing: 1,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: settingPage(),
      ),
    );
  }

  Widget settingPage() {
    double h = MediaQuery.of(context).size.height - 20;
    double w = MediaQuery.of(context).size.width;
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    if (listData.isNotEmpty) {
      return Column(
        children: [
          Container(
            height: (mediaQueryHeight / 6) + 100,
            decoration: const BoxDecoration(color: clrPrimary),
            child: GestureDetector(
              onTap: () {
                // Navigate to InfoUser page
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Row(
                        children: [],
                      ),
                      SizedBox(
                        height: mediaQueryHeight / 7,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  listData[0]['photo'] != null ? 
                                  // ignore: prefer_interpolation_to_compose_strings
                                  '${ApiService.folder}/'+ listData[0]['photo']:
                                  ApiService.imgDefault,
                                  scale: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        listData[0]['nip'].toString(),
                        style: SafeGoogleFont(
                          'SF Pro Text',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.2575,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        listData[0]['nama'].toString(),
                        style: SafeGoogleFont(
                          'SF Pro Text',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.2575,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bidangTabBar(),
          const SizedBox(height: 50),
          const SizedBox(height: 25),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: w,
          height: h / 14.7,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: clrPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              // logoutDialog(context);
            },
            child: const Text(
              "Logout",
              style: TextStyle(fontSize: 19, color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  Widget bidangTabBar() {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          labelColor: clrPrimary,
          indicatorColor: clrSecondary,
          unselectedLabelColor: clrBackground,
          tabs: const <Tab>[
            Tab(text: 'Biodata'),
            Tab(text: 'Jabatan'),
            Tab(text: 'Pendidikan'),
            Tab(text: 'Keluarga'),
            
          ],
          controller: controller,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
              controller.animateTo(index);
            });
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2, // Adjust as needed
          child: TabBarView(
            controller: controller,
            children: [
              BiodataPage(nikPegawai: widget.nik),
              JabatanPage(idPegawai: idPegawai.toString()),
              EducationPage(idPegawai: idPegawai.toString()),
              FamilyPage(idPegawai: idPegawai.toString()),
              
            ],
          ),
        ),
      ],
    );
  }
}


