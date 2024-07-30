import 'dart:convert';
import 'package:data_pegawai/src/loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../src/api.dart';
import '../../../src/constant.dart';
import '../../../src/dialog_info.dart';
import '../../../src/preference.dart';
import '../../../widgets/custom_list_item.dart';

class BiodataPage extends StatefulWidget {
  final nikPegawai;
  const BiodataPage({super.key, required this.nikPegawai});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  SharedPref sharedPref = SharedPref();
  bool isProcess = true;
  List listData = [];
  List listDataBidang = [];
  List listFilterDataBidang = [];
  List arrBidangId = [];
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
    getData(widget.nikPegawai);
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
        print("datanya pegawai");
        listData.add(content['data']);
        print(listData);
        // print("idpegwai");
        // idPegawai = content['data']['id'];
        // print(idPegawai);
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

  // Future<void> _pullRefresh() async {
  //   setState(() {
  //     informasiLayanan(limit, offset, status, widget.idPegawai);
  //   });
  // }

  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // !isProcess ?
            listAset()
        // : loaderDialog(context),
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
            print("objectrow");
            print(row);
            return GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: "NIK",
                      subtitle: row['nik'] ?? "-",
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: 'NRP',
                      subtitle: row['nrp'].toString(),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: 'NIP',
                      subtitle: row['nip'].toString(),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: 'Nama',
                      subtitle: row['nama']?? "-",
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: 'Jenis Kelamin',
                      subtitle: row['jenis_kelamin']?? "-",
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: 'Tanggal Lahir',
                      subtitle: row['tanggal_lahir']?? "-",
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: CustomListItemTwo(
                      title: 'Agama',
                      subtitle: row['agama']?? "-",
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
              "Riwayat Biodata Belum Ada!",
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
