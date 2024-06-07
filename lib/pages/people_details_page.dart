import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xoxo/pages/settings.dart';

import '../cubit/people_cubit.dart';

class PeopleDetailsPage extends StatefulWidget {
  final int castId;
  const PeopleDetailsPage({Key? key,required this.castId}) : super(key: key);

  @override
  State<PeopleDetailsPage> createState() => _PeopleDetailsPageState();
}

class _PeopleDetailsPageState extends State<PeopleDetailsPage> {
  bool hasBiography = true;
  bool hasKnownForDepartment = true;
  bool hasHomePage = true;
  bool hasDeathDate = true;
  late DateDuration age ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPeople();
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
      body:  BlocBuilder<PeopleCubit, PeopleState>(builder: (context, state){
        if(state is PeopleLoadingInProgress){
          return CupertinoActivityIndicator(color: Colors.white,);

        }
        else if(state is PeopleLoadingSucceeded) {
          var person = state.people;

          var dateOfBirth = DateTime.tryParse( person.birthday);

          var dateOfDeath = DateTime.tryParse( person.deathday.toString());



          SchedulerBinding.instance.addPostFrameCallback((_) {

            setState(() {
              age = AgeCalculator.age(dateOfBirth!);
            });

            if(person.deathday == null){
              setState(() {
                hasDeathDate =false;
              });
            }

            if(person.biography == null){
              setState(() {
                hasBiography = false;
              });
            }
            if(person.homepage == null){
              setState(() {
                hasHomePage = false;
              });
            }
            if(person.knownForDepartment == null){
              setState(() {
                hasKnownForDepartment = false;
              });
            }
            // add your code here.


          });



          return SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight*0.4,
                      width: double.infinity,
                      // color: Colors.blue,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(55)),
                        child:
                        CachedNetworkImage(
                          imageUrl:"$imageBaseUrl/${person
                              .profilePath}",
                          placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:16.0, top: 8),
                            child: Text("${person.name}",style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                          ),



                          Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Chip(
                              label: hasKnownForDepartment ? Text(person.knownForDepartment,style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)) : Text(""),
                              color: MaterialStateProperty.all(Colors.yellow),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:16.0, bottom: 16),
                      child: hasHomePage ? InkWell(
                          onTap: () => launchUrl(person.homepage.toString() as Uri),
                          child: Text("Homepage: ${person.homepage}",style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15),)) : Text(""),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:16.0, bottom: 8),
                      child:  Container(
                        child:   Text("Place of birth: ${person.placeOfBirth}", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16)) ,
                      ) ,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:16.0, bottom: 8),
                      child:  Container(
                        child:   Text("Date of birth: ${person.birthday} (${age.years}years)", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16)) ,
                      ) ,
                    ),

                    hasDeathDate ? Padding(
                      padding: const EdgeInsets.only(left:16.0, bottom: 8),
                      child:  Container(
                        child:   Text("Date of demise: ${person.deathday} (at age ${age.years})", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16)) ,
                      ) ,
                    ) : Text(""),



                    Padding(
                      padding: const EdgeInsets.only(left:16.0, bottom: 0),
                      child:  Container(
                        child: Text("Biography", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)) ,
                      ) ,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Divider(
                        height: 0,
                        endIndent: 350,
                        indent: 20,
                        thickness: 4,
                        color: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:16.0, right: 16.0, top: 8),
                      child: hasBiography ? Container(
                        child:   Text(person.biography, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15)) ,
                      ) : Container(),
                    ) // child widget, replace with your own


                    // child widget, replace with your own


                  ]
              ),


            ),
          );
        }
        return Center(child: CupertinoActivityIndicator(color: Colors.white,));
      }),
      // body:
    );
  }

  void _loadPeople() {
    BlocProvider.of<PeopleCubit>(context).loadPeople(widget.castId);

  }
}

