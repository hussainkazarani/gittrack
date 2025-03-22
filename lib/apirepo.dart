import 'package:flutter/material.dart';

class ApiRepo extends StatefulWidget {
  ApiRepo({super.key, required this.username, required this.data});
  String username;
  final data;
  @override
  State<ApiRepo> createState() => _ApiRepoState();
}

class _ApiRepoState extends State<ApiRepo> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.brown, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.data[index]['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  // Text(data['owner']['login']),
                ],
              ),
            ),
          );
        });
  }
}
