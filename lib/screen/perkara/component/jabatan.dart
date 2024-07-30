import 'dart:convert';
import 'package:data_pegawai/src/loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../src/api.dart';
import '../../../src/constant.dart';
import '../../../src/dialog_info.dart';
import '../../../src/preference.dart';
import '../../../widgets/custom_list_item.dart';

class JabatanPage extends StatefulWidget {
  final idPegawai;
  const JabatanPage({super.key, required this.idPegawai});

  @override
  State<JabatanPage> createState() => _JabatanPageState();
}

class _JabatanPageState extends State<JabatanPage> {
  SharedPref sharedPref = SharedPref();
  bool isProcess = true;
  List listData = [];
  List listDataSatker = [];
  String dropdownName = "";

  final fieldKeyword = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  var offset = 0;
  var limit = 2;
  var status = "";

  @override
  void initState() {
    // getBidangList();

    checkSession();

    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     setState(() {
    //       offset = offset + 10;
    //     });

    //     informasiLayanan(widget.idPegawai);
    //   }
    // });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  void checkSession() async {
    informasiLayanan(widget.idPegawai);
  }

  Future<void> informasiLayanan(id) async {
    try {
      var accessToken = await sharedPref.getPref("access_token");
      var url = ApiService.getPegawaiJabatan;
      var uri = "$url/$id";
      var bearerToken = 'Bearer $accessToken';
      var response = await http.get(Uri.parse(uri),
          headers: {"Authorization": bearerToken.toString()});
      var content = json.decode(response.body);
      print(uri);

      if (content['status'] == 200) {
        setState(() {
          if (listData.isEmpty) {
            print("jabatan");
            listData = content['data'];
            print(listData);
          } else {
            //listData.addAll(content['data'].toList());
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        onBasicAlertPressed(context, 'Error', content['message']);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      onBasicAlertPressed(context, 'Error', e.toString());
    }

    setState(() {
      isProcess = false;
    });
  }

  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isProcess ? listAset() : loaderDialog(context),
    );
  }

  Widget listAset() {
    if (listData.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 11, top: 5),
        child: ListView.separated(
          padding: const EdgeInsets.only(right: 5.0),
          primary: true,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            var row = listData[index];

            return GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      row['satker']['nama_satker'],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row['jabatan']['nama'],
                        ),
                        Text(
                          row['no_sk'].toString(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80, // Adjust the height to your needs
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.blue,
                          thickness: 2,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
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
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 90.0,
              color: Colors.grey.shade400,
            ),
            Text(
              "Riwayat Jabatan Belum Ada!",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
  }
}
