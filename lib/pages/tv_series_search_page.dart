import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xoxo/pages/settings.dart';
import 'package:xoxo/pages/tv_series_details_page.dart';

import '../cubit/popular_tv_series_cubit.dart';
import '../cubit/query_tv_series_cubit.dart';
import '../cubit/query_tv_series_with_genre_and_year_cubit.dart';
import '../cubit/tv_series_genres_cubit.dart';
import '../data/popular_tv_series.dart';
import '../data/tv_series_genres.dart';


class TvSeriesSearchPage extends StatefulWidget {
  const TvSeriesSearchPage({Key? key}) : super(key: key);


  @override
  _TvSeriesSearchPageState createState() => _TvSeriesSearchPageState();
}

class _TvSeriesSearchPageState extends State<TvSeriesSearchPage> {
  List<TvSeriesGenres> genreResults = [];
  List<String> genreNameList = [];

  String? genreUserInput;
  int? yearUserInput;
  var controller = TextEditingController();
  var yearTextController = TextEditingController();
  late String userInput = "";
  int pageCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPopularTvSeries();
    _loadTvSeriesGenres();
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
    if (pageCounter == 0) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(19, 19, 19, 1),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 16, right: 6),
                  child: Container(
                    // color: Colors.grey,
                    height: 60,
                    // search bar
                    child: Row(
                      children: <Widget>[
            
                        Expanded(
                          child: TextField(
            
                            onSubmitted: (inputValue) {
                              setState(() {
                                userInput = inputValue;
                                pageCounter = 1;
                              });
                              _loadQueryTvSeries();
                            },
            
                            controller: controller,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.white,),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  )
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15),
                              hintText: "Search for a tv show...",
                              hintStyle: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                        PopupMenuButton(
                            icon: Icon(Icons.sort, color: Colors.white,),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            itemBuilder: (context){
                              return <PopupMenuEntry>[
                                PopupMenuItem(
                                    child: Container(
                                      height: screenHeight*0.27,
                                      width: screenWidth*0.6,
                                      color: Colors.grey,
                                      child: Column(
                                        children:<Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text("Filter", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),),
                                          ),
            
                                          BlocBuilder<TvSeriesGenresCubit, TvSeriesGenresState>(builder: (context, state){
                                            if(state is TvSeriesGenresLoadingSucceeded){
            
                                              genreResults = state.tvSeriesGenresResults.genres;
            
                                              genreResults.map((e) => genreNameList.add(e.name)).toList(growable: true);
                                            }
                                            return SizedBox();
                                          }),
            
            
            
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: TextDropdownFormField(
                                              onChanged: (dynamic genre){
                                                setState(() {
                                                  genreUserInput = genre.toString();
                                                });
                                              },
            
                                              options: genreNameList,
                                              decoration: InputDecoration(
                                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                                  labelText: "Genre"),
            
                                              dropdownHeight: 220,
            
                                            ),
                                          ),
            
                                          Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: TextField(
                                                onChanged: (year){
                                                  yearUserInput = int.tryParse(year);
                                                },
                                                controller: yearTextController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Year",
                                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                                  border: OutlineInputBorder(),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
            
                                                ),
                                              )
            
                                          ),
            
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pageCounter = 2;
                                                    });
            
                                                    _loadQueryTvSeriesWithGenreAndYear();
                                                    Navigator.pop(context);
            
            
                                                  },
                                                  style: ButtonStyle(
                                                      fixedSize: MaterialStateProperty.all(Size(250, 50))
                                                  ),
                                                  child: Text("APPLY FILTER", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                          )
            
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                    )
                                )
            
                              ];
                            }
                        )
            
                      ],
                    ),
                  ),
                ),
            
                // popular tv series
                Expanded(
                  child: BlocBuilder<PopularTvSeriesCubit, PopularTvSeriesState>(
                    builder: (context, state) {
                      if (state is PopularTvSeriesLoadingInProgress) {
                        return Center(child: CupertinoActivityIndicator(),);
                      } else if (state is PopularTvSeriesLoadingSucceeded) {
                        var data = state.popularTvSeriesResults;
                        var popularTvSeries = data.results;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Text("Popular Tv Shows",
                                  style: GoogleFonts.poppins(fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),),
                              ),
            
                              Divider(
                                height: 4,
                                endIndent: 330,
                                indent: 20,
                                thickness: 4,
                                color: Colors.white,
                              ),
            
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 16),
                                  itemCount: popularTvSeries.length,
            
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TvSeriesDetailsPage(
                                                        popularTvSeries: popularTvSeries[index])));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16, bottom: 16),
                                        // color: Colors.black26,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
            
                                            Container(
                                              padding: EdgeInsets.only(bottom: 8),
                                              width: double.infinity,
                                              // height: 210,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Text(
                                                popularTvSeries[index].name,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
            
                                              ),
                                            ),
            
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                    width: 150,
                                                    height: 220,
                                                    // margin: EdgeInsets.all(16.0),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.black,
            
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                      child: CachedNetworkImage(
                                                        imageUrl: "$imageBaseUrl/${popularTvSeries[index]
                                                            .posterPath}",
                                                        placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                ),
            
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 8),
                                                    // color: Colors.blue,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(
            
                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "Released in ${popularTvSeries[index]
                                                                .firstAirDate}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),),
                                                          // color: Colors.black,
                                                          height: 40,
                                                        ),
                                                        Container(
            
                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "Rating: ${popularTvSeries[index]
                                                                .voteAverage}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),),
                                                          // color: Colors.black,
                                                          height: 40,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "${popularTvSeries[index]
                                                                .overview}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 3,
                                                          ),
                                                          // color: Colors.red,
                                                          height: 170,
                                                          width: 225,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
            
            
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        );
                      }
                      return Center(child: CupertinoActivityIndicator());
                    },
                  ),
                ),
              ],
            ),
          )


      );
      // search results page
    }
    else if(pageCounter == 1){
      return Scaffold(
          backgroundColor: Color.fromRGBO(19, 19, 19, 1),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 16, right: 6),
                  child: Container(
                    // color: Colors.grey,
                    height: 60,
                    // search bar
                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: TextField(

                            onSubmitted: (inputValue) {
                              setState(() {
                                userInput = inputValue;
                                pageCounter = 1;
                              });
                              _loadQueryTvSeries();
                            },

                            controller: controller,
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.white,),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  )
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15),
                              hintText: "Search for a tv show...",
                              hintStyle: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                        PopupMenuButton(
                            icon: Icon(Icons.sort, color: Colors.white,),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            itemBuilder: (context){
                              return <PopupMenuEntry>[
                                PopupMenuItem(
                                    child: Container(
                                      height: screenHeight*0.27,
                                      width: screenWidth*0.6,
                                      color: Colors.grey,
                                      child: Column(
                                        children:<Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text("Filter", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),),
                                          ),

                                          BlocBuilder<TvSeriesGenresCubit, TvSeriesGenresState>(builder: (context, state){
                                            if(state is TvSeriesGenresLoadingSucceeded){

                                              genreResults = state.tvSeriesGenresResults.genres;

                                              genreResults.map((e) => genreNameList.add(e.name)).toList(growable: true);
                                            }
                                            return SizedBox();
                                          }),



                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: TextDropdownFormField(
                                              onChanged: (dynamic genre){
                                                setState(() {
                                                  genreUserInput = genre.toString();
                                                });
                                              },

                                              options: genreNameList,
                                              decoration: InputDecoration(
                                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                                  labelText: "Genre"),

                                              dropdownHeight: 220,

                                            ),
                                          ),

                                          Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: TextField(
                                                onChanged: (year){
                                                  yearUserInput = int.tryParse(year);
                                                },
                                                controller: yearTextController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Year",
                                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                                  border: OutlineInputBorder(),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),

                                                ),
                                              )

                                          ),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pageCounter = 2;
                                                    });

                                                    _loadQueryTvSeriesWithGenreAndYear();
                                                    Navigator.pop(context);


                                                  },
                                                  style: ButtonStyle(
                                                      fixedSize: MaterialStateProperty.all(Size(250, 50))
                                                  ),
                                                  child: Text("APPLY FILTER", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                    )
                                )

                              ];
                            }
                        )

                      ],
                    ),
                  ),
                ),

                // popular tv series
                Expanded(
                  child: BlocBuilder<QueryTvSeriesCubit, QueryTvSeriesState>(
                    builder: (context, state) {
                      if (state is QueryTvSeriesLoadingProgress) {
                        return Center(child: CupertinoActivityIndicator(),);
                      } else if (state is QueryTvSeriesLoadingSucceeded) {
                        var data = state.queryTvSeriesResults;
                        var popularTvSeries = data.results;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Text("Popular Tv Shows",
                                  style: GoogleFonts.poppins(fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),),
                              ),

                              Divider(
                                height: 4,
                                endIndent: 330,
                                indent: 20,
                                thickness: 4,
                                color: Colors.white,
                              ),

                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 16),
                                  itemCount: popularTvSeries.length,

                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        PopularTvSeries queryTvSeries = PopularTvSeries
                                          (backdropPath: popularTvSeries[index].backdropPath,
                                            firstAirDate: popularTvSeries[index].firstAirDate,
                                            genreIds: popularTvSeries[index].genreIds,
                                            id: popularTvSeries[index].id,
                                            name: popularTvSeries[index].name,
                                            originCountry: popularTvSeries[index].originCountry,
                                            originalLanguage: popularTvSeries[index].originalLanguage,
                                            originalName: popularTvSeries[index].originalName,
                                            overview: popularTvSeries[index].overview,
                                            popularity: popularTvSeries[index].popularity,
                                            posterPath: popularTvSeries[index].posterPath,
                                            voteAverage: popularTvSeries[index].voteAverage,
                                            voteCount: popularTvSeries[index].voteCount);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TvSeriesDetailsPage(
                                                        popularTvSeries: queryTvSeries)));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16, bottom: 16),
                                        // color: Colors.black26,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [

                                            Container(
                                              padding: EdgeInsets.only(bottom: 8),
                                              width: double.infinity,
                                              // height: 210,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Text(
                                                popularTvSeries[index].name,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),

                                              ),
                                            ),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                    width: 150,
                                                    height: 220,
                                                    // margin: EdgeInsets.all(16.0),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.black,

                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                      child: CachedNetworkImage(
                                                        imageUrl: "$imageBaseUrl/${popularTvSeries[index]
                                                            .posterPath}",
                                                        placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                ),

                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 8),
                                                    // color: Colors.blue,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(

                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "Released in ${popularTvSeries[index]
                                                                .firstAirDate}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),),
                                                          // color: Colors.black,
                                                          height: 40,
                                                        ),
                                                        Container(

                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "Rating: ${popularTvSeries[index]
                                                                .voteAverage}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),),
                                                          // color: Colors.black,
                                                          height: 40,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "${popularTvSeries[index]
                                                                .overview}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 3,
                                                          ),
                                                          // color: Colors.red,
                                                          height: 170,
                                                          width: 225,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),


                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        );
                      }
                      return Center(child: CupertinoActivityIndicator());
                    },
                  ),
                ),
              ],
            ),
          )


      );
    }
    else {
      return Scaffold(
          backgroundColor: Color.fromRGBO(19, 19, 19, 1),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 16, right: 6),
                  child: Container(
                    // color: Colors.grey,
                    height: 60,
                    // search bar
                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: TextField(

                            onSubmitted: (inputValue) {
                              setState(() {
                                userInput = inputValue;
                                pageCounter = 1;
                              });
                              _loadQueryTvSeries();
                            },

                            controller: controller,
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.white,),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  )
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15),
                              hintText: "Search for a tv show...",
                              hintStyle: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                        PopupMenuButton(
                            icon: Icon(Icons.sort, color: Colors.white,),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            itemBuilder: (context){
                              return <PopupMenuEntry>[
                                PopupMenuItem(
                                    child: Container(
                                      height: screenHeight*0.27,
                                      width: screenWidth*0.6,
                                      color: Colors.grey,
                                      child: Column(
                                        children:<Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text("Filter", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),),
                                          ),

                                          BlocBuilder<TvSeriesGenresCubit, TvSeriesGenresState>(builder: (context, state){
                                            if(state is TvSeriesGenresLoadingSucceeded){

                                              genreResults = state.tvSeriesGenresResults.genres;

                                              genreResults.map((e) => genreNameList.add(e.name)).toList(growable: true);
                                            }
                                            return SizedBox();
                                          }),



                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: TextDropdownFormField(
                                              onChanged: (dynamic genre){
                                                setState(() {
                                                  genreUserInput = genre.toString();
                                                });
                                              },

                                              options: genreNameList,
                                              decoration: InputDecoration(
                                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                                  labelText: "Genre"),

                                              dropdownHeight: 220,

                                            ),
                                          ),

                                          Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: TextField(
                                                onChanged: (year){
                                                  yearUserInput = int.tryParse(year);
                                                },
                                                controller: yearTextController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Year",
                                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                                  border: OutlineInputBorder(),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),

                                                ),
                                              )

                                          ),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pageCounter = 2;
                                                    });

                                                    _loadQueryTvSeriesWithGenreAndYear();
                                                    Navigator.pop(context);


                                                  },
                                                  style: ButtonStyle(
                                                      fixedSize: MaterialStateProperty.all(Size(250, 50))
                                                  ),
                                                  child: Text("APPLY FILTER", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                    )
                                )

                              ];
                            }
                        )

                      ],
                    ),
                  ),
                ),

                // popular tv series
                Expanded(
                  child: BlocBuilder<QueryTvSeriesWithGenreAndYearCubit, QueryTvSeriesWithGenreAndYearState>(
                    builder: (context, state) {
                      if (state is QueryTvSeriesWithGenreAndYearLoadingProgress) {
                        return Center(child: CupertinoActivityIndicator(),);
                      } else if (state is QueryTvSeriesWithGenreAndYearLoadingSucceeded) {
                        var data = state.queryTvSeriesResults;
                        var popularTvSeries = data.results;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Text("Popular Tv Shows",
                                  style: GoogleFonts.poppins(fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),),
                              ),

                              Divider(
                                height: 4,
                                endIndent: 330,
                                indent: 20,
                                thickness: 4,
                                color: Colors.white,
                              ),

                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 16),
                                  itemCount: popularTvSeries.length,

                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        PopularTvSeries queryTvSeries = PopularTvSeries
                                          (backdropPath: popularTvSeries[index].backdropPath,
                                            firstAirDate: popularTvSeries[index].firstAirDate,
                                            genreIds: popularTvSeries[index].genreIds,
                                            id: popularTvSeries[index].id,
                                            name: popularTvSeries[index].name,
                                            originCountry: popularTvSeries[index].originCountry,
                                            originalLanguage: popularTvSeries[index].originalLanguage,
                                            originalName: popularTvSeries[index].originalName,
                                            overview: popularTvSeries[index].overview,
                                            popularity: popularTvSeries[index].popularity,
                                            posterPath: popularTvSeries[index].posterPath,
                                            voteAverage: popularTvSeries[index].voteAverage,
                                            voteCount: popularTvSeries[index].voteCount);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TvSeriesDetailsPage(
                                                        popularTvSeries: queryTvSeries)));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16, bottom: 16),
                                        // color: Colors.black26,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [

                                            Container(
                                              padding: EdgeInsets.only(bottom: 8),
                                              width: double.infinity,
                                              // height: 210,
                                              alignment: Alignment.bottomLeft,
                                              // color: Colors.amberAccent,
                                              child: Text(
                                                popularTvSeries[index].name,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),

                                              ),
                                            ),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                    width: 150,
                                                    height: 220,
                                                    // margin: EdgeInsets.all(16.0),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.black,

                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                      child: CachedNetworkImage(
                                                        imageUrl: "$imageBaseUrl/${popularTvSeries[index]
                                                            .posterPath}",
                                                        placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                ),

                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 8),
                                                    // color: Colors.blue,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(

                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "Released in ${popularTvSeries[index]
                                                                .firstAirDate}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),),
                                                          // color: Colors.black,
                                                          height: 40,
                                                        ),
                                                        Container(

                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "Rating: ${popularTvSeries[index]
                                                                .voteAverage}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),),
                                                          // color: Colors.black,
                                                          height: 40,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(
                                                              8),
                                                          child: Text(
                                                            "${popularTvSeries[index]
                                                                .overview}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                color: Colors.white,
                                                                fontSize: 16),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 3,
                                                          ),
                                                          // color: Colors.red,
                                                          height: 170,
                                                          width: 225,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),


                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        );
                      }
                      return Center(child: CupertinoActivityIndicator());
                    },
                  ),
                ),
              ],
            ),
          )


      );
    }
  }

  void _loadQueryTvSeries() {
    BlocProvider.of<QueryTvSeriesCubit>(context).loadQueryTvSeries(userInput);
  }

  void _loadPopularTvSeries() {
    BlocProvider.of<PopularTvSeriesCubit>(context).loadPopularTvSeries();
  }

  void _loadTvSeriesGenres() {
    BlocProvider.of<TvSeriesGenresCubit>(context).loadTvSeriesGenres();
  }



  void _loadQueryTvSeriesWithGenreAndYear() {
    var k = genreResults.where((e) => e.name == genreUserInput).toList();
    if(k.isNotEmpty){
      var genreId = k[0].id;
      BlocProvider.of<QueryTvSeriesWithGenreAndYearCubit>(context).loadQueryTvSeriesWithGenreAndYearCubit(genreId, yearUserInput);
    } else{
      int? nullInt;
      BlocProvider.of<QueryTvSeriesWithGenreAndYearCubit>(context).loadQueryTvSeriesWithGenreAndYearCubit(nullInt, yearUserInput);
    }

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);




}



