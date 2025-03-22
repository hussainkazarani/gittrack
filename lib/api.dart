import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gittrack/apifollow.dart';
import 'package:gittrack/apiservices.dart';
import 'package:http/http.dart' as http;

class ApiApp extends StatefulWidget {
  String username;
  ApiApp({super.key, required this.username});

  @override
  State<ApiApp> createState() => _ApiAppState();
}

class _ApiAppState extends State<ApiApp> {
  Map<String, dynamic> user = {};
  bool isLoading = true;
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _loadAllApis();

    print(_future);
  }

  Future<List<dynamic>> _loadAllApis() async {
    final username = widget.username;
    await Api(username);
    final future1 = ApiServices().ApiFetchService(
        follow_url: 'https://api.github.com/users/$username/following');
    final future2 = ApiServices().ApiFetchService(
        follow_url: 'https://api.github.com/users/$username/followers');
    final future3 = ApiServices().ApiFetchService(
        follow_url: 'https://api.github.com/users/$username/repos');

    return await Future.wait([future1, future2, future3]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       setState(() {
        //         Api(widget.username);
        //       });
        //     },
        //     child: Text('Data'),
        //   ),
        // ],
        // ),
        body: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error : ${snapshot.error}',
                    style: const TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                );
              } else if (snapshot.hasData) {
                final List<dynamic> apiResults = snapshot.data!;
                final List<dynamic> following = apiResults[0];
                final List<dynamic> followers = apiResults[1];
                final List<dynamic> repos = apiResults[2];
                _precacheFollowingAndFollowersImages(following, followers);

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(user["login"] ?? 'N/A'),
                        background: Image.network(
                          user["avatar_url"] ??
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ApiFollow(
                                                    type: 'Following',
                                                    data: following,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.redAccent,
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user["following"]?.toString() ??
                                                  'N/A',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 20),
                                            ),
                                            const Text(
                                              'Following',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ApiFollow(
                                              type: 'Followers',
                                              data: followers,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.deepOrangeAccent,
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user["followers"]?.toString() ??
                                                  'N/A',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 20),
                                            ),
                                            const Text(
                                              'Followers',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Repositories',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              user["public_repos"]?.toString() ?? 'N/A',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < repos.length) {
                            final repo = repos[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepPurpleAccent,
                                ),
                                child: ListTile(
                                  onTap: () {},
                                  title: Text(repo['name']),
                                  subtitle: Text(
                                      repo['description'] ?? 'No description'),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            }),
      ),
    );
  }

  Future<void> Api(String username) async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = "https://api.github.com/users/$username";
      print(url);
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body);

      print('\n\nAPI RESPONSE MAIN : $json');

      if (json['message'] == 'Not Found') {
        _showErrorSnackBar();
        setState(() {
          isLoading = false;
          user = {};
        });
      } else {
        _showSuccessSnackBar();
        setState(() {
          user = json;
        });
        // Check if the avatar URL exists
        if (user['avatar_url'] != null) {
          // Pre-cache the avatar image
          await precacheImage(NetworkImage(user['avatar_url']), context);
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    setState(() {
      isLoading = false;
      user = {};
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Wrong Username',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.red[900],
      duration: const Duration(seconds: 3),
    ));
  }

  void _showSuccessSnackBar() {
    setState(() {
      isLoading = false;
      user = {};
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Success!',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.green[900],
      duration: const Duration(seconds: 3),
    ));
  }

  Future<void> _cacheUserImages(List<dynamic> users) async {
    for (var user in users) {
      final String? avatarUrl = user['avatar_url'];
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        await precacheImage(NetworkImage(avatarUrl), context);
      }
    }
  }

  Future<void> _precacheFollowingAndFollowersImages(
    List<dynamic> following,
    List<dynamic> followers,
  ) async {
    await _cacheUserImages(following);
    await _cacheUserImages(followers);
  }
}
