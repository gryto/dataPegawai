import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../home.dart';
import '../src/api.dart';
import '../src/constant.dart';
import '../src/preference.dart';
import '../login/login.dart';
import '../src/utils.dart';

class LauncherCopyPage extends StatefulWidget {
  final String token;
  const LauncherCopyPage({Key? key, required this.token}) : super(key: key);

  @override
  State<LauncherCopyPage> createState() => _LauncherCopyPageState();
}

class _LauncherCopyPageState extends State<LauncherCopyPage> {
  final storage = FlutterSecureStorage();
  SharedPref sharedPref = SharedPref();
  String url = ApiService.detailUser;
  String message = "";
  bool isLogged = false;
  bool bacaToken = false;
  String readToken = "";
  String? token = '';
  String? id = '';

  @override
  void initState() {
    requestPermissions();

    super.initState();
  }

  startLaunching() async {
    var duration = const Duration(seconds: 2);
    // requestPermissions();
    return Timer(duration, checkSession);
  }

  // void checkSession() async {
  //   try {
  //     var userId = await sharedPref.getPref("id_usr");
  //     print("userid: $userId");
  //     await getDetailUser(userId);

  //     if (isLogged == true) {
  //       goToApp(userId);
  //     } else {
  //       if (token != null && id != null) {
  //         goToApp(userId);
  //       } else {
  //         goToLogin();
  //       }
  //     }
  //   } catch (e) {
  //     goToLogin();
  //   }
  // }
  void checkSession() async {
    try {
      // await _loadTokenFromStorage();
      var userId = await sharedPref.getPref('id_usr');

      print("userid: $userId");
      await getDetailUser(userId);
      // print("userid: $id");
      // await getDetailUser(id);

      if (isLogged == true) {
        goToApp(userId);
      } else {
        if (token != null && userId != null) {
          goToApp(userId);
        } else {
          goToLogin();
        }
      }
    } catch (e) {
      goToLogin();
    }
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted) {
        print('Storage permission granted');
      } else {
        print('Storage permission denied');
      }
    }

    var manageStatus = await Permission.manageExternalStorage.status;
    if (!manageStatus.isGranted) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        print('Manage External Storage permission granted');
      } else {
        print('Manage External Storage permission denied');
      }
    }
    // readFile();
    await _loadTokenFromStorage();
  }

  // void readFile() async {
  //   try {
  //     final directory = await _getDownloadDirectoryPath();
  //     final file = File('$directory/shared_token.txt');
  //     final fileId = File('$directory/shared_id.txt');
  //     if (await file.exists() && await fileId.exists()) {
  //       String contents = await file.readAsString();
  //       String contentsId = await fileId.readAsString();
  //       setState(() {
  //         readToken = contents.toString();
  //         print("tokerndrifile $readToken");
  //       });
  //       await sharedPref.setPref('access_token', contents);
  //       print("sgaredpref");
  //       print(sharedPref.setPref('id_usr', contentsId));
  //       _loadToken();
  //     } else {
  //       print('File does not exist');
  //       goToLogin();
  //     }
  //   } catch (e) {
  //     print('Error reading file: $e');
  //   }
  // }

  Future<void> _loadTokenFromStorage() async {
    token = await storage.read(key: "token");
    id = await storage.read(key: "id");

    print("Read token: $token");
    print("Read ID: $id");

    setState(() {
      if (token != null && id != null) {
        startLaunching();
      } else {
        goToLogin();
      }
    });
  }

  Future<void> _loadToken() async {
    token = await sharedPref.getPref('access_token');
    id = await sharedPref.getPref('id_usr');
    print("readtoken $token");
    print("readid $id");

    setState(() {
      if (token != null) {
        bacaToken == true;
        readToken = token ?? "No token found";
      }
      startLaunching();
    });
  }

  Future<String> _getDownloadDirectoryPath() async {
    Directory? directory;
    try {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Error getting download directory: $err");
      throw Exception("Unable to get the downloads directory");
    }
    return directory!.path;
  }

  getDetailUser(userId) async {
    try {
      var response = await http.post(Uri.parse(url),
          headers: {'Accept': 'application/json'}, body: {"user_id": userId});
      var content = json.decode(response.body);

      if (content['status'] == 200) {
        setState(() {
          isLogged = true;
        });
      } else {
        setState(() {
          isLogged = false;
        });
      }
    } catch (e) {
      isLogged = false;
    }
  }

  void goToApp(userId) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainTabBar(id: userId)),
        (Route<dynamic> route) => false);
  }

  void goToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return LoginPage(
        tkn: widget.token,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrPrimary,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Center(
            child: Text(
              "Data Pegawai",
              style: SafeGoogleFont(
                'SF Pro Text',
                fontSize: 100,
                fontWeight: FontWeight.w700,
                height: 1.2575,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  permissionServiceCall() async {
    await permissionServices().then(
      (value) {
        if (value[Permission.storage]!.isGranted) {}
      },
    );
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isPermanentlyDenied) {
      await openAppSettings().then(
        (value) async {
          if (value) {
            if (await Permission.storage.status.isPermanentlyDenied == true &&
                await Permission.storage.status.isGranted == false) {
              openAppSettings();
              // permissionServiceCall(); /* opens app settings until permission is granted */
            }
          }
        },
      );
    } else {
      if (statuses[Permission.storage]!.isDenied) {
        permissionServiceCall();
      }
    }

    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
  }
}
