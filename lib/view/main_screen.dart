import 'dart:convert';
import 'dart:ui' as ui;
import 'package:user_profile_avatar/user_profile_avatar.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/model/config.dart';
import 'package:my_tutor/view/login_page.dart';
import 'package:bottom_bar/bottom_bar.dart';
import '../model/subjects.dart';
import '../model/tutors.dart';
import '../model/tutorsubject.dart';
import '../model/user.dart';
import '../model/config.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Subjects> subjectList = <Subjects>[];
  List<Tutors> tutorsList = <Tutors>[];
  List<TutorSub> tutorsubList = <TutorSub>[];

  TextEditingController searchSubController = TextEditingController();
  String titlecenter = "Loading...";
  String titlecenter2 = "Loading...";
  final _pageController = PageController();
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int _currentPage = 0;
  String search = "";
  String search2 = "";
  var numofpage, numofpage2, curpage = 1, curpage2 = 1;
  var color;
  var types = [
    'All',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadSubjects(1, search, "All");
      _loadTutors(1, search2, "All");
      _loadsubTutors();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    //Function For Subject Page
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.pink,
              title: Text(
                'Subjects',
                style: TextStyle(
                    fontSize: 40,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(50, 50),
                        const Offset(150, 150),
                        <Color>[
                          Colors.pink,
                          Colors.white,
                        ],
                      )),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _loadSearchSubject();
                  },
                ),
              ],
            ),
            body: subjectList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Center(
                            child: Text(titlecenter,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: types.map((String char) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.pink),
                                  ),
                                  child: Text(char),
                                  onPressed: () {
                                    _loadSubjects(1, "", char);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: types.map((String char) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.pink),
                              ),
                              child: Text(char),
                              onPressed: () {
                                _loadSubjects(1, "", char);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 2),
                            children:
                                List.generate(subjectList.length, (index) {
                              return InkWell(
                                onTap: () => {_loadSubjectDetails(index)},
                                splashColor: Colors.pink,
                                child: Card(
                                    elevation: 8,
                                    shadowColor: Colors.pink,
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 1)),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: CachedNetworkImage(
                                            imageUrl: Config.server +
                                                "/mytutor/assets/courses/" +
                                                subjectList[index]
                                                    .subjectId
                                                    .toString() +
                                                '.jpg',
                                            fit: BoxFit.scaleDown,
                                            height: 170,
                                            width: resWidth,
                                            placeholder: (context, url) =>
                                                const LinearProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          subjectList[index]
                                              .subjectName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Flexible(
                                            flex: 4,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 7,
                                                      child: Column(children: [
                                                        Row(children: [
                                                          const Text(
                                                              "\n Subject Price: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              "\nRM ${double.parse(subjectList[index].subjectPrice.toString()).toStringAsFixed(2)}"),
                                                        ]),
                                                        Row(children: [
                                                          const Text(
                                                              "\n Subject Session: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              "\n${int.parse(subjectList[index].subjectSession.toString())}"),
                                                        ]),
                                                        Row(children: [
                                                          const Text(
                                                              "\n Subject Rating: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              "\n${double.parse(subjectList[index].subjectRating.toString()).toStringAsFixed(2)}"),
                                                        ]),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ],
                                    )),
                              );
                            }))),
                    SizedBox(
                      height: 30,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Colors.pink;
                          } else {
                            color = Colors.black;
                          }
                          return SizedBox(
                            width: 40,
                            child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.pink),
                                ),
                                onPressed: () =>
                                    {_loadSubjects(index + 1, "", "All")},
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: color),
                                )),
                          );
                        },
                      ),
                    ),
                  ]),
          ),
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.blue,
              title: Text(
                'TUTORS',
                style: TextStyle(
                    fontSize: 40,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(50, 50),
                        const Offset(150, 150),
                        <Color>[
                          Colors.blue,
                          Colors.white,
                        ],
                      )),
              ),
            ),
            body: tutorsList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Center(
                            child: Text(titlecenter2,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: types.map((String char) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: ElevatedButton(
                                  child: Text(char),
                                  onPressed: () {
                                    _loadTutors(1, "", char);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(titlecenter2,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: types.map((String char) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: ElevatedButton(
                              child: Text(char),
                              onPressed: () {
                                _loadTutors(1, "", char);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 2),
                            children: List.generate(tutorsList.length, (index) {
                              return InkWell(
                                onTap: () => {_loadTutorsDetail(index)},
                                splashColor: Colors.pink,
                                child: Card(
                                    elevation: 8,
                                    shadowColor: Colors.blue,
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 1)),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: CachedNetworkImage(
                                            imageUrl: Config.server +
                                                "/mytutor/assets/tutors/" +
                                                tutorsList[index]
                                                    .tutorId
                                                    .toString() +
                                                '.jpg',
                                            fit: BoxFit.scaleDown,
                                            height: 170,
                                            width: resWidth,
                                            placeholder: (context, url) =>
                                                const LinearProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          tutorsList[index]
                                              .tutorName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Flexible(
                                            flex: 4,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 7,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(children: [
                                                              const Text(
                                                                  "\n Email: ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ]),
                                                            Text(
                                                              " ${tutorsList[index].tutorEmail}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Row(children: [
                                                              const Text(
                                                                  "\n Phone Number: ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ]),
                                                            Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                " ${tutorsList[index].tutorPhone}"),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ],
                                    )),
                              );
                            }))),
                    SizedBox(
                      height: 30,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage2,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage2 - 1) == index) {
                            color = Colors.blue;
                          } else {
                            color = Colors.black;
                          }
                          return SizedBox(
                            width: 40,
                            child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blue),
                                ),
                                onPressed: () =>
                                    {_loadTutors(index + 1, "", "All")},
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: color),
                                )),
                          );
                        },
                      ),
                    ),
                  ]),
          ),
          Container(color: Colors.red),
          Container(color: Colors.greenAccent.shade700),
          Scaffold(
            backgroundColor: Colors.orange,
            body: Center(
                child: Column(children: [
              Flexible(
                flex: 4,
                child: WidgetCircularAnimator(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[200]),
                    child: UserProfileAvatar(
                      avatarUrl:
                          "${Config.server}/mytutor/assets/user_image/${widget.user.id.toString()}.jpg",
                      onAvatarTap: () {
                        print('Avatar Tapped..');
                      },
                      notificationBubbleTextStyle: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      avatarSplashColor: Colors.purple,
                      radius: 100,
                      isActivityIndicatorSmall: false,
                      avatarBorderData: AvatarBorderData(
                        borderColor: Colors.white,
                        borderWidth: 5.0,
                      ),
                    ),
                  ),
                ),
              ),
            ])),
          ),
        ],
        onPageChanged: (index) {
          // Use a better state management solution
          // setState is used for simplicity
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          const BottomBarItem(
            icon: Icon(Icons.subject_sharp),
            title: Text('Subjects'),
            activeColor: Colors.pink,
          ),
          const BottomBarItem(
            icon: Icon(Icons.people_outline),
            title: Text('Tutors'),
            activeColor: Colors.blue,
          ),
          const BottomBarItem(
            icon: Icon(Icons.subscriptions_rounded),
            title: Text('Subscribe'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Favourite'),
            activeColor: Colors.greenAccent.shade700,
          ),
          const BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  void _loadSearchSubject() {
    searchSubController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Subject Search",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchSubController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Search',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Colors.pink)),
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink),
                    ),
                    onPressed: () {
                      search = searchSubController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search, "All");
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void _loadSubjects(int pageno, String _search, String _type) {
    curpage = pageno;
    numofpage ?? 1;
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Loading...', max: 100);
    http.post(
        Uri.parse("${Config.server}/mytutor/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          'type': _type,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
          subjectList = <Subjects>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subjects.fromJson(v));
          });
          titlecenter = "${subjectList.length} Subjects Available";
        } else {
          titlecenter = "No Subjects Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Subjects Available";
        subjectList.clear();
        setState(() {});
      }
    });
    pd.close();
  }

  void _loadTutors(int pageno, String _search, String _type) {
    curpage2 = pageno;
    numofpage2 ?? 1;
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Loading...', max: 100);
    http.post(Uri.parse("${Config.server}/mytutor/mobile/php/load_tutors.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          'type': _type,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage2 = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorsList = <Tutors>[];
          extractdata['tutors'].forEach((v) {
            tutorsList.add(Tutors.fromJson(v));
          });
          titlecenter2 = "${tutorsList.length} Tutors Available";
        } else {
          titlecenter2 = "No Tutors Available";
          tutorsList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter2 = "No Tutors Available";
        tutorsList.clear();
        setState(() {});
      }
    });
    pd.close();
  }

  void _loadsubTutors() {
    http
        .post(
      Uri.parse("${Config.server}/mytutor/mobile/php/loadsub_tutor.php"),
    )
        .then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      var extractdata = jsondata['data'];
      if (extractdata['tutorsub'] != null) {
        tutorsubList = <TutorSub>[];
        extractdata['tutorsub'].forEach((v) {
          tutorsubList.add(TutorSub.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: Config.server +
                      "/mytutor/assets/courses/" +
                      subjectList[index].subjectId.toString() +
                      '.jpg',
                  fit: BoxFit.scaleDown,
                  height: 170,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subjectList[index].subjectName.toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nSubject Description: "),
                  Text("${subjectList[index].subjectDesc}"),
                  Row(children: [
                    const Text("\nSubject Price: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "\nRM ${double.parse(subjectList[index].subjectPrice.toString()).toStringAsFixed(2)}"),
                  ]),
                  Row(children: [
                    const Text("\nSubject Session: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "\n${int.parse(subjectList[index].subjectSession.toString())}"),
                  ]),
                  Row(children: [
                    const Text("\nSubject Rating: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "\n${double.parse(subjectList[index].subjectRating.toString()).toStringAsFixed(2)}"),
                  ]),
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nTutor By:"),
                  CachedNetworkImage(
                    imageUrl: Config.server +
                        "/mytutor/assets/tutors/" +
                        subjectList[index].tutorId.toString() +
                        '.jpg',
                    fit: BoxFit.scaleDown,
                    height: 170,
                    width: resWidth,
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ]),
              ],
            )),
          );
        });
  }

  _loadTutorsDetail(int index) {
    List<String> subTutor = [];
    List.generate(tutorsubList.length, (i) {
      if (tutorsubList[i].tutorId == tutorsList[index].tutorId) {
        subTutor.add("${tutorsubList[i].subjectName}");
      }
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: Config.server +
                      "/mytutor/assets/tutors/" +
                      tutorsList[index].tutorId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  tutorsList[index].tutorName.toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nTutor Description: "),
                  Text("${tutorsList[index].tutorDesc}"),
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nEmail: "),
                  Text("${tutorsList[index].tutorEmail}"),
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nPhone Number: "),
                  Text("${tutorsList[index].tutorPhone}"),
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nSubject Tutoring: "),
                  Text(subTutor.toString()),
                  Text(
                      style: TextStyle(fontWeight: FontWeight.bold),
                      "\nDate Registeration: "),
                  Text(df.format(DateTime.parse(
                      tutorsList[index].tutorDatereg.toString()))),
                ]),
              ],
            )),
          );
        });
  }
}
