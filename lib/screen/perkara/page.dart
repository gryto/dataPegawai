import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../src/api.dart';
import '../../src/constant.dart';
import '../../src/preference.dart';
import '../../src/utils.dart';
import '../../widgets/custon_button_primary.dart';
import 'package:http/http.dart' as http;

import 'component/list.dart';

class PerkaraPage extends StatefulWidget {
  const PerkaraPage({super.key});

  @override
  State<PerkaraPage> createState() => _PerkaraPageState();
}

class _PerkaraPageState extends State<PerkaraPage> {
  SharedPref sharedPref = SharedPref();
  final _formKey = GlobalKey<FormState>();
  String message = "";
  bool isProcess = true;
  List listData = [];

  final ctrlTanggal = TextEditingController();
  final List<FocusNode> _focusNodes = [
    FocusNode(),
  ];

  @override
  void initState() {
    setState(() {});
    getData();

    super.initState();
  }

  getData() async {
    try {
      var accessToken = await sharedPref.getPref("access_token");
      var url = ApiService.getAllPegawai;
      var uri = url;
      var bearerToken = 'Bearer $accessToken';
      var response = await http.get(Uri.parse(uri),
          headers: {"Authorization": bearerToken.toString()});
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

    final txtTanggal = Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              focusNode: _focusNodes[0],
              controller: ctrlTanggal,
              // key: _formKey,
              decoration: InputDecoration(
                hoverColor: clrPrimary,
                hintText: 'Masukkan NIK ',
                label: Row(
                  children: [
                    Text(
                      "Masukkan NIK",
                      style: TextStyle(
                          color: _focusNodes[0].hasFocus
                              ? clrPrimary
                              : Colors.grey),
                    ),
                    const Text(
                      " *",
                      style: TextStyle(color: Colors.red),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(3.0),
                    ),
                  ],
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.wallet,
                  color: _focusNodes[0].hasFocus ? clrPrimary : Colors.grey,
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih NIK Terlebih Dahulu!';
                }
                return null;
              },
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2024),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: clrPrimary,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: clrPrimary,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);

                  setState(
                    () {
                      ctrlTanggal.text = formattedDate;
                      print(ctrlTanggal.text.toString());
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clrPrimary,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Data Pegawai ',
            style: SafeGoogleFont(
              'SF Pro Text',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.2575,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: clrBackground,
                        blurRadius: 1.0,
                        spreadRadius: 0.5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Masukka Data NIK yang terkait dengan perkara",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        txtTanggal,
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: CustomButtonPrimary(
                            text: "Cek Data",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ListPerkara(
                                      nik: ctrlTanggal.text.toString(),
                                    
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
