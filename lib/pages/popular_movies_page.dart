import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xoxo/pages/popular_movies_details_page.dart';
import 'package:xoxo/pages/settings.dart';

import '../cubit/popular_movies_cubit.dart';
import '../utils/colors.dart';
import 'movie_search_page.dart';


class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {

  bool showFab = true;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _loadPopularMovies();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(

      backgroundColor: Color.fromRGBO(19, 19, 19, 1),
      floatingActionButton: showFab ? FloatingActionButton.extended(

        extendedTextStyle: GoogleFonts.poppins(),

        onPressed: (){
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MovieSearchPage()));
        },

        icon: Icon(Icons.search, color: Colors.black,),
        label: Text("BROWSE MOVIES", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500)),
        backgroundColor: AppColors.primary,

      ) : null,
      body: SafeArea(
        child: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if(state is MoviesLoadingInProgress){
              return Center(child: CupertinoActivityIndicator(),);
            } else if(state is MoviesLoadingSucceeded){
              var data = state.popularMoviesResults;
              var popularMovies = data.results;
              return NotificationListener<UserScrollNotification>(
                onNotification: (notification){
                  setState(() {
                    if(notification.direction == ScrollDirection.forward){
                      showFab = true;
                    } else if(notification.direction == ScrollDirection.reverse){
                      showFab = false;
                    }
                  });
                  return true;
                },
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: popularMovies.length,
                    itemBuilder: (context, index){
        
                      return Stack(
                        children: [
                          Positioned(
                            child: Container(
                                width: double.infinity,
                                // color: Colors.black,
                                height: screenHeight*0.2,
                                margin: EdgeInsets.only(left: 20.0, right: 20, top: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: "$imageBaseUrl/${popularMovies[index].backdropPath}",
                                    placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  ),
                                )
                            ),
                            bottom: 0,
                            right: 0,
                            left: 0,
                            top: 0,
                          ),
        
                          InkWell(
                            onTap:(){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: popularMovies[index]))
                              );
                            },
        
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                              width:  double.infinity,
                              height: screenHeight*0.2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.bottomCenter,
                                      end: FractionalOffset.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.3),
                                        Colors.white.withOpacity(0.0),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
        
                          ),
        
                          InkWell(
                            onTap:(){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: popularMovies[index]))
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                              width: double.infinity,
                              height: screenHeight*0.2,
                              alignment: Alignment.bottomLeft,
                              // color: Colors.amberAccent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(popularMovies[index].title,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),

                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              );
        
            }
            return Center(child: CupertinoActivityIndicator(color: Colors.white,));
          },
        ),
      ),
    );
  }

  void _loadPopularMovies() {
    BlocProvider.of<MoviesCubit>(context).loadPopularMovies();
  }
}
