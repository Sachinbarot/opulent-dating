import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';

class Bestmatchs extends StatefulWidget {
  final User currentUser;
  final List<User> matches;
  final List<User> newmatches;
  const Bestmatchs(
    this.currentUser,
    this.matches,
    this.newmatches,
  );

  @override
  State<Bestmatchs> createState() => _BestmatchsState();
}

class _BestmatchsState extends State<Bestmatchs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/shape.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/best.png',
                  height: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Best Match',
                  style: TextStyle(
                    fontFamily: AppStrings.fontname,
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Explore A Curated Selection Of Highly Compatible Matches. Like Those Who Catch Your Eye, And Embark On A Journey Of Connection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.only(top: 300),
              height: MediaQuery.of(context).size.height * 0.5,
              child: widget.matches.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/amico.png',
                          height: 135,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No Match Found',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: AppStrings.fontname,
                              color: black,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 42,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: btncolor),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(builder: (context) {
                                    return const Tabbar(
                                      null,
                                      null,
                                    );
                                  }),
                                );
                              },
                              child: Text(
                                'start swiping ',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: AppStrings.fontname,
                                    color: black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.matches.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                              widget.matches[index].imageUrl!.map((imageURL) {
                            return Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        imageURL,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: Text(
                                    '${widget.matches[index].name}(${widget.matches[index].age.toString()})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
            ),
          ),
        ]),
      ),
    );
  }
}
