
import 'package:flutter/material.dart';
import 'package:gittrack/api.dart';

class ApiFollow extends StatefulWidget {
  ApiFollow({super.key, required this.type, required this.data});

  String type;
  final data;
  @override
  State<ApiFollow> createState() => _ApiFollowState();
}

class _ApiFollowState extends State<ApiFollow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
      ),
      body: ListView.builder(
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            print(widget.data);
            return GestureDetector(
              onTap: () {
                print('YOU TOUCHED ME ${widget.data[index]['login']}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ApiApp(username: widget.data[index]['login'])),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(widget.data[index]["avatar_url"])),
                ),
                title: Text(widget.data[index]["login"]),
                // trailing: Container(
                //   width: 140,
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Expanded(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment:
                //               CrossAxisAlignment.center,
                //           children: [
                //             Text('Following'),
                //             Text('10'),
                //           ],
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Expanded(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment:
                //               CrossAxisAlignment.center,
                //           children: [
                //             Text('Followers'),
                //             Text('20'),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ),
            );
          }),
    );
  }
}
