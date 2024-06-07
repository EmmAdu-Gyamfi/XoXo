import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../data/movie_image_results.dart';
import '../pages/settings.dart';
part 'movie_images_state.dart';

class MovieImagesCubit extends Cubit<MovieImagesState> {
  MovieImagesCubit() : super(MovieImagesInitial());

  final _dio = Dio();

  Future <void> loadMovieImages(int id) async {
    try{
      emit(MovieImagesLoadingProgress());

      var response = await _dio.get("${baseUrl}movie/$id/images?api_key=$apiKey");

      if(response.statusCode == 200) {

        var movieImagesResults = MovieImagesResults.fromJson(response.data);

        emit(MovieImagesLoadingSucceeded(movieImagesResults));

      } else {
        emit(MovieImagesLoadingFailed(response.statusMessage));
      }

    } catch(e){
      emit(MovieImagesLoadingFailed(e.toString()));
    }

  }
}
