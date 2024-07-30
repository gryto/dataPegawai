
import 'package:flutter/material.dart';

import '../src/constant.dart';

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: clrPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            width: 142,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: clrSecondary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            width: 201,
            child: 
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              
          ),
        ],
      ),
    );
  }
}

// class _ArticleDescription extends StatelessWidget {
//   const _ArticleDescription({
//     required this.title,
//     required this.subtitle,
//     required this.ipAddress,
//     required this.pasal,
//     required this.pidana,
//     required this.perkara,
//     required this.putusan,
//   });

//   final String title;
//   final String subtitle;
//   final String ipAddress;
//   final String pasal;
//   final String pidana;
//   final String perkara;
//   final String putusan;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 title,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Padding(
//                   padding: EdgeInsets.only(
//                 bottom: 2.0,
//               )),
//               Text(
//                 subtitle,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: false,
//                 style: const TextStyle(
//                   fontSize: 14.0,
//                   color: Colors.black87,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 ipAddress,
//                 // '$publishDate - $readDuration',
//                 style: const TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 pasal,
//                 // '$publishDate - $readDuration',
//                 style: const TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 pidana,
//                 // '$publishDate - $readDuration',
//                 style: const TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 perkara,
//                 // '$publishDate - $readDuration',
//                 style: const TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 putusan,
//                 // '$publishDate - $readDuration',
//                 style: const TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ArticleTitle extends StatelessWidget {
//   const _ArticleTitle({
//     required this.title,
//     required this.subtitle,
//     required this.ipAddress,
//     required this.pasal,
//     required this.pidana,
//     required this.perkara,
//     required this.putusan,
//   });

//   final String title;
//   final String subtitle;
//   final String ipAddress;
//   final String pasal;
//   final String pidana;
//   final String perkara;
//   final String putusan;

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 "Nama",
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.only(
//                 bottom: 2.0,
//               )),
//               Text(
//                 "No Identitas",
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: false,
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: Colors.black87,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 "Jenis Indentitas",
//                 // '$publishDate - $readDuration',
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 "Pasal",
//                 // '$publishDate - $readDuration',
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 "Pidana",
//                 // '$publishDate - $readDuration',
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 "Perkara",
//                 // '$publishDate - $readDuration',
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 "Putusan",
//                 // '$publishDate - $readDuration',
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
