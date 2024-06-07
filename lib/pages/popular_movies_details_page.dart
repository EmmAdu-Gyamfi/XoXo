import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xoxo/pages/people_details_page.dart';
import 'package:xoxo/pages/settings.dart';
import 'package:xoxo/utils/colors.dart';
import '../cubit/movie_credit_cubit.dart';
import '../cubit/movie_details_cubit.dart';
import '../cubit/movie_images_cubit.dart';
import '../cubit/movie_recommendations_cubit.dart';
import '../cubit/movie_trailers_cubit.dart';
import '../cubit/now_playing_movies_cubit.dart';
import '../cubit/similar_movies_cubit.dart';
import '../cubit/top_rated_movies_cubit.dart';
import '../cubit/upcoming_movies_cubit.dart';
import '../data/movie_trailers_results.dart';
import '../data/popular_movies.dart';
import '../utils/my_dimens.dart';

class PopularMoviesDetailsPage extends StatefulWidget {
  final PopularMovies popularMovies;
  const PopularMoviesDetailsPage({Key? key, required this.popularMovies}) : super(key: key);

  @override
  _PopularMoviesDetailsPageState createState() => _PopularMoviesDetailsPageState();
}

class _PopularMoviesDetailsPageState extends State<PopularMoviesDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMovieDetails();
    _loadMovieCredit();
    _loadSimilarMovies();
    _loadNowPlayingMovies();
    _loadNowUpComingMovies();
    _loadTopRatedMovies();
    _loadRecommendedMovies();
    _loadMovieImages();


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
    final _dio = Dio();
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 19, 19, 1),
        body: SafeArea(
          child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
            builder: (context, state){
              if(state is MovieDetailsLoadingSucceeded){
                var releasedDate = DateTime.parse(state.movieDetailsResults.releaseDate);
                String formattedDate = DateFormat('dd MMMM, yyyy').format(releasedDate);
                var genres = state.movieDetailsResults.genres;
                return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight*0.42,
                          width: double.infinity,
                          // color: Colors.white,
                          child: Stack(
                              children: [
                                //movie backdrop
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  left: 0,
                                  bottom: 0,
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: "$imageBaseUrl/${widget.popularMovies
                                          .backdropPath}",
                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                ),
          
                                Container(
                                  // margin: EdgeInsets.all(8.0),
                                  width:  double.infinity,
                                  height: screenHeight*0.42,
          
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
          
                                BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    height: screenHeight*0.42,
                                    width: double.infinity,
                                    // color: Colors.white.withOpacity(0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        )
                                    ),
          
                                  ),
                                ),
                                //
                                //
                                Positioned(
                                  left : MyDimens.standardMargin,
                                  right: MyDimens.standardMargin,
                                  top: MyDimens.standardMargin,
                                  bottom: MyDimens.standardMargin,
          
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Stack(
                                              children:[
                                                // poster
                                                Container(
                                                  margin: EdgeInsets.all(16.0),
                                                  height: screenHeight*0.25,
                                                  width: screenWidth*0.35,
                                                  // color: Colors.amberAccent,
                                                  child: ClipRRect(
                                                    child: CachedNetworkImage(
                                                      imageUrl:  "$imageBaseUrl/${widget.popularMovies
                                                          .posterPath}",
                                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
          
                                                  ),
                                                ),
          
                                                // play icon
                                                Positioned(
                                                  left: 16,
                                                  top: 15,
                                                  child: InkWell(
                                                    onTap:  ()async{
                                                      await youtube(_dio);
                                                    },
                                                    child: Container(
                                                        height: screenHeight*0.25,
                                                        width: screenWidth*0.35,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          // color: Colors.blue,
          
                                                        ),
                                                        child: Icon(Icons.play_circle_outline_rounded,color: Colors.yellow,size: 46,)
                                                    ),
                                                  ),
                                                ),
                                                // BlocBuilder<MovieTrailersCubit, MovieTrailersState>(
                                                //     builder: (context, state){
                                                //       if(state is MovieImagesLoadingSucceeded){
                                                //         return  Positioned(
                                                //           left: 16,
                                                //           top: 15,
                                                //           child: InkWell(
                                                //             onTap: (){
                                                //
                                                //             },
                                                //             child: Container(
                                                //                 height: 250,
                                                //                 width: 150,
                                                //                 decoration: BoxDecoration(
                                                //                   borderRadius: BorderRadius.circular(20),
                                                //                   // color: Colors.blue,
                                                //
                                                //                 ),
                                                //                 child: Icon(Icons.play_circle_outline_rounded,color: Colors.yellow,size: 46,)
                                                //             ),
                                                //           ),
                                                //         );
                                                //       }
                                                //       return Text("");
                                                //     }
                                                // )
                                              ]
                                          ),
          
          
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 50),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // width: 200,
                                                    // height: 100,
                                                    // color: Colors.amberAccent,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(widget.popularMovies.title,
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20
                                                      ),
                                                    ),
                                                  ),
          
                                                  Container(
                                                    // width: 200,
                                                    // height: 30,
                                                    // color: Colors.amberAccent,
                                                    alignment: Alignment.topLeft,
                                                    child: Text("Rating: ${widget.popularMovies
                                                        .voteAverage}",
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 18
                                                      ),
                                                    ),
                                                  ),
          
          
          
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
          
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: genres.map((g) =>  Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: ActionChip(label: Text(g.name), onPressed: (){}, labelStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 14), backgroundColor: Colors.yellow),
                                          )).toList()                 ,
                                        ),
                                      )
                                    ],
          
                                  ),
                                )
                              ]
                          ),
                        ),
          
          
                        //overview
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Overview", style: GoogleFonts.poppins(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            widget.popularMovies.overview,
                            style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ),
          
                        //release date
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Release date: $formattedDate",
                            style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ),
          
          
                        // screenshot
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Movie Screenshots", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,

                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: screenHeight*0.2,
                            // width: 150,
                            child: BlocBuilder<MovieImagesCubit, MovieImagesState>(
                                builder: (context, state){
                                  if(state is MovieImagesLoadingSucceeded){
                                    var movieImages = state.movieImagesResults.backdrops;
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: movieImages.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 330
          
                                        ), itemBuilder: (context, index){
                                      return Container(
                                        // color: Colors.yellow,
                                          child: Stack(
                                              children:[
          
                                                Container(
                                                  margin: EdgeInsets.all(8.0),
                                                  width:  double.infinity,
                                                  height: screenHeight*0.2,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: FractionalOffset.bottomCenter,
                                                          end: FractionalOffset.topCenter,
                                                          colors: [
                                                            Colors.white.withOpacity(0.3),
                                                            Colors.white.withOpacity(0.0),
                                                          ]
                                                      ),
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                ),
                                                Positioned(
          
                                                  child: Container(
                                                      width: double.infinity,
                                                      height: screenHeight*0.2,
                                                      margin: EdgeInsets.all(8.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: CachedNetworkImage(
                                                          imageUrl:  "$imageBaseUrl/${movieImages[index].filePath}",
                                                          placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                          fit: BoxFit.fill,
                                                        ),
          
                                                      )
                                                  ),
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  top: 0,
                                                ),
                                              ]
                                          )
                                      ) ;
                                    }
                                    );
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
                        //top billed cast
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Top Billed Cast", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: screenHeight*0.27,
                            // width: 150,
                            child: BlocBuilder<MovieCreditCubit, MovieCreditState>(
                                builder: (context, state){
                                  if(state is MovieCreditLoadingSucceeded){
                                    var cast = state.movieCreditResults.cast;
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: cast.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 150
          
                                        ), itemBuilder: (context, index){
          
                                      if(cast[index].profilePath != null){
          
                                        return Container(
          
          
                                          decoration: BoxDecoration(
                                            // color: Colors.white26,
                                            // borderRadius: BorderRa dius.circular(20)
                                          ),
                                          child: InkWell(
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  PeopleDetailsPage(castId: cast[index].id))),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
          
                                                  child: CachedNetworkImage(
                                                    imageUrl:  "$imageBaseUrl/${cast[index].profilePath}",
                                                    placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
          
                                                Positioned(
          
                                                  child: Container(
                                                    height: 80,
                                                    width: screenWidth*0.4,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.primary,
          
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                                                    ),
                                                  ),
                                                  bottom: 5,
                                                ),
          
                                                Positioned(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 40,
                                                    width: 150,
                                                    // color: Colors.blue,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 3.0, right: 3, bottom: 3),
                                                      child: Text(cast[index].character,
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.poppins( color: Colors.white, fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  bottom: 9,
                                                ),
          
                                                Positioned(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 40,
                                                    width: 150,
                                                    // color: Colors.yellow,
                                                    child: Text(cast[index].originalName,
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                                                    ),
                                                  ),
                                                  bottom: 43,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      else{
                                        return Container(
          
          
          
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.1),
                                              // color: Colors.white26,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Stack(
                                            children: [
                                              // ClipRRect(
                                              //
                                              //   child: Image.network(
                                              //     "$imageBaseUrl/${cast[index].profilePath}", fit: BoxFit.fill,
                                              //   ),
                                              //   borderRadius: BorderRadius.circular(20),
                                              // ),
          
                                              Center(child: Icon(Icons.image)),
          
                                              Positioned(
          
                                                child: Container(
                                                  height: 80,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primary,
          
                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                                                  ),
                                                ),
                                                bottom: 0,
                                              ),

                                              Positioned(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  width: 150,
                                                  // color: Colors.blue,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 3.0, right: 3, bottom: 3),
                                                    child: Text(cast[index].character,
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.poppins( color: Colors.white, fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                                bottom: 9,
                                              ),

                                              Positioned(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  width: 150,
                                                  // color: Colors.yellow,
                                                  child: Text(cast[index].originalName,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                                                  ),
                                                ),
                                                bottom: 43,
                                              )
                                            ],
                                          ),
                                        );
          
                                      }
                                    });
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
          
                        //similar movies
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Similar", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: screenHeight*0.2,
                            // width: 150,
                            child: BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
                                builder: (context, state){
                                  if(state is SimilarMoviesLoadingSucceeded){
                                    var SimilarMovies = state.similarMoviesResults.results;
                                    var movie = SimilarMovies.map((e) => PopularMovies(adult: e.adult, backdropPath: e.backdropPath, genreIds: e.genreIds, id: e.id, originalLanguage: e.originalLanguage, originalTitle: e.originalTitle, overview: e.overview, popularity: e.popularity, posterPath: e.posterPath, releaseDate: e.releaseDate, title: e.title, video: e.video, voteAverage: e.voteAverage, voteCount: e.voteCount)).toList();
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: SimilarMovies.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 330
          
                                        ), itemBuilder: (context, index){
                                      return Container(
                                        // color: Colors.yellow,
                                        child: Stack(
                                          children: [
                                            Positioned(
          
                                              child: Container(
                                                  width: double.infinity,
                                                  height: screenHeight*0.2,
                                                  margin: EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                      imageUrl:  "$imageBaseUrl/${SimilarMovies[index].backdropPath}",
                                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                              ),
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                            ),
          
                                            InkWell(
                                              child: Container(
                                                margin: EdgeInsets.all(8.0),
                                                width:  double.infinity,
                                                height: screenHeight*0.2,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: FractionalOffset.bottomCenter,
                                                        end: FractionalOffset.topCenter,
                                                        colors: [
                                                          Colors.white.withOpacity(0.3),
                                                          Colors.white.withOpacity(0.0),
                                                        ]
                                                    ),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: movie[index]))
                                                );
                                              },
                                            ),
          
          
                                            Container(
                                              margin: EdgeInsets.all(14.0),
                                              width: double.infinity,
                                              height: screenHeight*0.2,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:8.0, bottom: 6),
                                                child: Text(SimilarMovies[index].title,
                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),

                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    );
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
          
                        //  now_playing
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Now Playing"
                              "", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
          
          
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: screenHeight*0.2,
                            // width: 150,
                            child: BlocBuilder<NowPlayingMoviesCubit, NowPlayingMoviesState>(
                                builder: (context, state){
                                  if(state is NowPlayingMoviesLoadingSucceeded){
                                    var now_playingMovies = state.nowPlayingMoviesResults.results;
                                    var movie = now_playingMovies.map((e) => PopularMovies(adult: e.adult, backdropPath: e.backdropPath, genreIds: e.genreIds, id: e.id, originalLanguage: e.originalLanguage, originalTitle: e.originalTitle, overview: e.overview, popularity: e.popularity, posterPath: e.posterPath, releaseDate: e.releaseDate, title: e.title, video: e.video, voteAverage: e.voteAverage, voteCount: e.voteCount)).toList();
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: now_playingMovies.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 330
          
                                        ), itemBuilder: (context, index){
                                      return Container(
                                        // color: Colors.yellow,
                                        child: Stack(
                                          children: [
                                            Positioned(
          
                                              child: Container(
                                                  width: double.infinity,
                                                  height: screenHeight*0.5,
                                                  margin: EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                      imageUrl:  "$imageBaseUrl/${now_playingMovies[index].backdropPath}",
                                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                              ),
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                            ),
          
                                            InkWell(
                                              child: Container(
                                                margin: EdgeInsets.all(8.0),
                                                width:  double.infinity,
                                                height: screenHeight*0.2,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: FractionalOffset.bottomCenter,
                                                        end: FractionalOffset.topCenter,
                                                        colors: [
                                                          Colors.white.withOpacity(0.3),
                                                          Colors.white.withOpacity(0.0),
                                                        ]
                                                    ),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: movie[index]))
                                                );
                                              },
                                            ),
          
          
                                            Container(
                                              margin: EdgeInsets.all(14.0),
                                              width: double.infinity,
                                              height: 210,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:8.0, bottom: 6),
                                                child: Text(now_playingMovies[index].title,
                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),

                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    );
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
                        //  upcoming movies
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Up Coming", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: screenHeight*0.2,
                            // width: 150,
                            child: BlocBuilder<UpcomingMoviesCubit, UpcomingMoviesState>(
                                builder: (context, state){
                                  if(state is UpcomingMoviesLoadingSucceeded){
                                    var upcomingMovies = state.upComingMoviesResults.results;
                                    var movie = upcomingMovies.map((e) => PopularMovies(adult: e.adult, backdropPath: e.backdropPath, genreIds: e.genreIds, id: e.id, originalLanguage: e.originalLanguage, originalTitle: e.originalTitle, overview: e.overview, popularity: e.popularity, posterPath: e.posterPath, releaseDate: e.releaseDate, title: e.title, video: e.video, voteAverage: e.voteAverage, voteCount: e.voteCount)).toList();
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: upcomingMovies.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 330
          
                                        ), itemBuilder: (context, index){
                                      return Container(
                                        // color: Colors.yellow,
                                        child: Stack(
                                          children: [
                                            Positioned(
          
                                              child: Container(
                                                  width: double.infinity,
                                                  height: screenHeight*0.2,
                                                  margin: EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                      imageUrl:  "$imageBaseUrl/${upcomingMovies[index].backdropPath}",
                                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                              ),
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                            ),
          
                                            InkWell(
                                              child: Container(
                                                margin: EdgeInsets.all(8.0),
                                                width:  double.infinity,
                                                height: screenHeight*0.2,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: FractionalOffset.bottomCenter,
                                                        end: FractionalOffset.topCenter,
                                                        colors: [
                                                          Colors.white.withOpacity(0.3),
                                                          Colors.white.withOpacity(0.0),
                                                        ]
                                                    ),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: movie[index]))
                                                );
                                              },
                                            ),
          
          
                                            Container(
                                              margin: EdgeInsets.all(14.0),
                                              width: double.infinity,
                                              height: 210,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:8.0, bottom: 6),
                                                child: Text(upcomingMovies[index].title,
                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),

                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    );
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
                        //top_rated movies
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Top Rated", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20 ),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: screenHeight*0.2,
                            // width: 150,
                            child: BlocBuilder<TopRatedMoviesCubit, TopRatedMoviesState>(
                                builder: (context, state){
                                  if(state is TopRatedMoviesLoadingSucceeded){
                                    var topRatedMovies = state.topRatedMoviesResults.results;
                                    var movie = topRatedMovies.map((e) => PopularMovies(adult: e.adult, backdropPath: e.backdropPath, genreIds: e.genreIds, id: e.id, originalLanguage: e.originalLanguage, originalTitle: e.originalTitle, overview: e.overview, popularity: e.popularity, posterPath: e.posterPath, releaseDate: e.releaseDate, title: e.title, video: e.video, voteAverage: e.voteAverage, voteCount: e.voteCount)).toList();
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: topRatedMovies.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 330
          
                                        ), itemBuilder: (context, index){
                                      return Container(
                                        // color: Colors.yellow,
                                        child: Stack(
                                          children: [
                                            Positioned(
          
                                              child: Container(
                                                  width: double.infinity,
                                                  height: screenHeight*0.2,
                                                  margin: EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                      imageUrl: "$imageBaseUrl/${topRatedMovies[index].backdropPath}",
                                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                              ),
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                            ),
          
                                            InkWell(
                                              child: Container(
                                                margin: EdgeInsets.all(8.0),
                                                width:  double.infinity,
                                                height: screenHeight*0.2,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: FractionalOffset.bottomCenter,
                                                        end: FractionalOffset.topCenter,
                                                        colors: [
                                                          Colors.white.withOpacity(0.3),
                                                          Colors.white.withOpacity(0.0),
                                                        ]
                                                    ),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: movie[index]))
                                                );
                                              },
                                            ),
          
          
                                            Container(
                                              margin: EdgeInsets.all(14.0),
                                              width: double.infinity,
                                              height: screenHeight*0.2,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:8.0, bottom: 6),
                                                child: Text(topRatedMovies[index].title,
                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),

                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    );
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
                        //recommended movies
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Recommended ", style: GoogleFonts.poppins(color:Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
          
                        Divider(
                          height: 0,
                          endIndent: screenWidth*0.78,
                          indent: 20,
                          thickness: 4,
                          color: Colors.white.withOpacity(0.7),
                        ),
          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: screenHeight*0.2,
                            // width: 150,
                            child: BlocBuilder<MovieRecommendationsCubit, MovieRecommendationsState>(
                                builder: (context, state){
                                  if(state is MovieRecommendationsLoadingSucceeded){
                                    var movieRecommendations = state.movieRecommendationsResults.results;
                                    var movie = movieRecommendations.map((e) => PopularMovies(adult: e.adult, backdropPath: e.backdropPath, genreIds: e.genreIds, id: e.id, originalLanguage: e.originalLanguage, originalTitle: e.originalTitle, overview: e.overview, popularity: e.popularity, posterPath: e.posterPath, releaseDate: e.releaseDate, title: e.title, video: e.video, voteAverage: e.voteAverage, voteCount: e.voteCount)).toList();
                                    return GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: movieRecommendations.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 16,
                                            mainAxisExtent: 330
          
                                        ), itemBuilder: (context, index){
                                      return Container(
                                        // color: Colors.yellow,
                                        child: Stack(
                                          children: [
                                            Positioned(
          
                                              child: Container(
                                                  width: double.infinity,
                                                  height: screenHeight*0.2,
                                                  margin: EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                      imageUrl: "$imageBaseUrl/${movieRecommendations[index].backdropPath}",
                                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                              ),
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                            ),
          
                                            InkWell(
                                              child: Container(
                                                margin: EdgeInsets.all(8.0),
                                                width:  double.infinity,
                                                height: screenHeight*0.2,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: FractionalOffset.bottomCenter,
                                                        end: FractionalOffset.topCenter,
                                                        colors: [
                                                          Colors.white.withOpacity(0.3),
                                                          Colors.white.withOpacity(0.0),
                                                        ]
                                                    ),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PopularMoviesDetailsPage(popularMovies: movie[index]))
                                                );
                                              },
                                            ),
          
          
                                            Container(
                                              margin: EdgeInsets.all(14.0),
                                              width: double.infinity,
                                              height: screenHeight*0.2,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:8.0, bottom: 6),
                                                child: Text(movieRecommendations[index].title,
                                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),

                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    );
          
                                  }
                                  return Center(child: CupertinoActivityIndicator());
                                }),
                          ),
                        ),
          
          
                      ],
                    )
          
          
                );
              } else if(state is MovieDetailsFailed){
                return Center(child: Text("Ecast"));
              }
              return Center(child: CupertinoActivityIndicator());
            },
          ),
        )


    );
  }

  Future<void> youtube(Dio _dio) async {
    var response = await _dio.get("${baseUrl}movie/${widget.popularMovies.id}/videos?api_key=$apiKey");
    if(response.statusCode == 200){
      var movieTrailers = MovieTrailersResults.fromJson(response.data);
      var movieTrailersList = movieTrailers.results;
      var key = movieTrailersList![0].key;
      Uri url = Uri.parse('https://www.youtube.com/watch?v=$key');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      return;
    }

  }

  void _loadMovieDetails() {
    BlocProvider.of<MovieDetailsCubit>(context).loadMovieDetails(widget.popularMovies.id);
  }

  void _loadMovieCredit() {
    BlocProvider.of<MovieCreditCubit>(context).loadMovieCredit(widget.popularMovies.id);
  }

  void _loadSimilarMovies() {
    BlocProvider.of<SimilarMoviesCubit>(context).loadSimilarMovies(widget.popularMovies.id);
  }

  void _loadNowPlayingMovies() {
    BlocProvider.of<NowPlayingMoviesCubit>(context).loadNowPlayingMovies();
  }

  void _loadNowUpComingMovies() {
    BlocProvider.of<UpcomingMoviesCubit>(context).loadUpComingMovies();
  }

  void _loadTopRatedMovies() {
    BlocProvider.of<TopRatedMoviesCubit>(context).loadTopRatedMovies();
  }

  void _loadRecommendedMovies() {
    BlocProvider.of<MovieRecommendationsCubit>(context).loadRecommendedMovies(widget.popularMovies.id);
  }

  void _loadMovieImages() {
    BlocProvider.of<MovieImagesCubit>(context).loadMovieImages(widget.popularMovies.id);
  }

  void _loadMovieTrailers() {
    BlocProvider.of<MovieTrailersCubit>(context).loadMovieTrailers(widget.popularMovies.id);
  }


}


