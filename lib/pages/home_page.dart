import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xoxo/pages/popular_movies_page.dart';
import 'package:xoxo/pages/tv_series_page.dart';
import 'package:xoxo/utils/colors.dart';

import 'chat_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.primary,
              // shadowColor: Colors.red,

              title: Text("Movies Hub"),
              titleTextStyle: GoogleFonts.hennyPenny(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
              bottom: TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                unselectedLabelColor: Colors.black,
                labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                tabs: [
                  Tab(
                      icon: Icon(CupertinoIcons.chat_bubble_2_fill, color: Colors.black,),
                      text: "Chats"

                  ),
                  Tab(
                      icon: FaIcon(FontAwesomeIcons.youtube, color: Colors.black, size: 20,),
                      text: "Movies"
                  ),

                  Tab(
                      icon: FaIcon(FontAwesomeIcons.film, color: Colors.black, size: 20,),
                      text: "Tv Series"

                  ),

                ],
              )
          ),

          body: SafeArea(
            child: TabBarView(
              children: [
                ChatPage(),
                MoviesPage(),
                TvSeriesPage(),

              ],
            
            ),
          )

      ),
    );
  }
}
