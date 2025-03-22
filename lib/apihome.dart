import 'package:flutter/material.dart';
import 'package:gittrack/api.dart';
import 'package:simple_icons/simple_icons.dart';

class ApiHome extends StatelessWidget {
  ApiHome({super.key});
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Enter Your',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  Icon(SimpleIcons.github),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Username!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        print(controller.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApiApp(
                                    username: controller.text,
                                  )),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter some correct data'),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          color: Colors.blueGrey,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text('Check Details!!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
                          )),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
