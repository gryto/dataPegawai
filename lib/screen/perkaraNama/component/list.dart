import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../src/api.dart';
import '../../../src/preference.dart';
import '../../../widgets/custom_list_item.dart';
import 'package:badges/badges.dart' as badges;

// ignore: must_be_immutable
class ListPerkaraNama extends StatefulWidget {
  String namaTersangka;
  ListPerkaraNama({super.key, required this.namaTersangka});

  @override
  State<ListPerkaraNama> createState() => _ListPerkaraNamaState();
}

class _ListPerkaraNamaState extends State<ListPerkaraNama> {
  SharedPref sharedPref = SharedPref();
  String message = "";
  bool isProcess = true;
  List listData = [];

  final ctrlTanggal = TextEditingController();

  @override
  void initState() {
    setState(() {});
    getData(widget.namaTersangka);
    print("namaTersangka");
    print(widget.namaTersangka);

    super.initState();
  }

  getData(namaTersangka) async {
    try {
      final params = {
        'nama': namaTersangka,
      };
      var accessToken = await sharedPref.getPref("access_token");
      var url = Uri.parse(ApiService.getAllPegawai);
      var uri = url;
      final newURI = uri.replace(queryParameters: params);
      var bearerToken = 'Bearer $accessToken';
      var response = await http.get(
        newURI,
        headers: {
          "Authorization": bearerToken.toString(),
        },
      );
      /////////////////////
      // var accessToken = await sharedPref.getPref("access_token");
      // var url = ApiService.getPerkara;
      // var uri = url;
      // var bearerToken = 'Bearer $accessToken';
      // var response = await http.get(Uri.parse(uri),
      //     headers: {"Authorization": bearerToken.toString()},param: params);
      // var content = json.decode(response.body);

      if (response.statusCode == 200) {
        var content = json.decode(response.body);
        print("datanya");
        listData.add(content['data']);
        print(listData);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Data Perkara",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body:  bidangTabBar(),
    );
  }

  Widget bidangTabBar() {
    if (listData.isNotEmpty) {
      return Column(
        children: [
          badges.Badge(
            badgeStyle: badges.BadgeStyle(
              shape: badges.BadgeShape.square,
              borderRadius: BorderRadius.circular(5),
              badgeColor: Colors.black12,
            ),
            position: badges.BadgePosition.custom(start: 10, top: 10),
            badgeContent: Padding(
              padding: const EdgeInsets.all(5),
              child: Text("Berikut detail dari Nama tersangka ${widget.namaTersangka}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 5, left: 5.0, right: 5.0),
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                var row = listData[index];
                print("lisdtdataperkara");
                print(row);

                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: "No. Identitas",
                          subtitle: row[0]['no_identitas'].toString(),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: 'Jenis Identitas',
                          subtitle: row[0]['jenis_identitas'].toString(),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: 'Nama Lengkap',
                          subtitle: row[0]['nama_lengkap'].toString(),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: 'Pasal',
                          subtitle: row[0]['pasal'].toString(),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: 'Pidana',
                          subtitle: row[0]['pidana'].toString(),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: 'Perkara',
                          subtitle: row[0]['perkara'].toString(),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: CustomListItemTwo(
                          title: 'Putusan',
                          subtitle: row[0]['putusan'].toString(),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, index) => const SizedBox(
                height: 5,
              ),
              itemCount: listData.isEmpty ? 0 : listData.length,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_clock,
                  size: 90.0,
                  color: Colors.grey.shade400,
                ),
                Text(
                  "Ooops, Nama Tersangka Yang Kamu Cari Tidak Ada Data, Silahkan Input Ulang Nama Tersangka Yang Ingin Dicari!",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      );
    }
  }
}
