import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/utilities_controller.dart';
import 'package:stna_lms_flutter/models/dictionary_model.dart';
import 'package:stna_lms_flutter/models/pagination_filter_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';

class DictionaryController extends GetxController {
  final UtilitiesController _utilitiesController =
      Get.put(UtilitiesController());

  var isLoading = false.obs;
  var isLoadingFavorite = false.obs;
  RxList<DictionaryWordModel> listWord = <DictionaryWordModel>[].obs;
  RxList<DictionaryWordModel> listWordFavorite = <DictionaryWordModel>[].obs;
  var currentTabIndex = 0;
  bool isFavoriteWord = false;

  GetStorage storage = GetStorage();

  final paginationFilterDict = PaginationFilterModel().obs;
  final paginationFilterFavorites = PaginationFilterModel().obs;

  final isLastPageDict = false.obs;
  final isLastPageFavorites = false.obs;

  int get pageDict => paginationFilterDict.value.page;
  int get pageFavorites => paginationFilterFavorites.value.page;

  bool get isShowingDictionary => currentTabIndex == 0;

  final int _pageSize = 15;
  late AudioPlayer audioPlayer;

  @override
  void onInit() {
    ever(
        paginationFilterDict,
        (_) => getDictionaryWords(
            search: paginationFilterDict.value.search,
            page: paginationFilterDict.value.page,
            pageSize: paginationFilterDict.value.pageSize));
    ever(
        paginationFilterFavorites,
        (_) => getFavoriteWords(
            search: paginationFilterFavorites.value.search,
            page: paginationFilterFavorites.value.page,
            pageSize: paginationFilterFavorites.value.pageSize));
    changePaginationFilter();

    super.onInit();

    audioPlayer = AudioPlayer();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void changePaginationFilter({
    int page = 1,
    int pageSize = 15,
    String text = '',
  }) {
    if (isShowingDictionary) {
      paginationFilterDict.update((val) {
        if (val != null) {
          val.search = text;
          val.page = page;
          val.pageSize = pageSize;
        }
      });
    } else {
      paginationFilterFavorites.update((val) {
        if (val != null) {
          val.search = text;
          val.page = page;
          val.pageSize = pageSize;
        }
      });
    }
  }

  void loadNextPage() {
    if (isShowingDictionary) {
      if (listWord.length >= _pageSize) {
        changePaginationFilter(page: pageDict + 1, pageSize: _pageSize);
      }
    } else {
      if (listWordFavorite.length >= _pageSize) {
        changePaginationFilter(page: pageFavorites + 1, pageSize: _pageSize);
      }
    }
  }

  Future playPronounciation(String link) async {
    await audioPlayer.setUrl(getFullResourceUrl(link));
    audioPlayer.play();
  }

  Future filterDictionary(String text) async {
    changePaginationFilter(text: text);
  }

  Future viewWord(DictionaryWordModel word) async {
    String? token = storage.read(jwtTokenKey);
    return APIService.postLogActivity(token,
        type: 'view_word',
        activity: 'người dùng xem từ vựng "${word.word}"',
        relatedId: word.id);
  }

  Future<void> getDictionaryWords(
      {String search = '', int page = 1, int pageSize = 15}) async {
    int selectedDictionaryID = _utilitiesController.selectedDictionaryID.value;

    if (selectedDictionaryID == 0) {
      AlertUtils.warn('Chưa chọn từ điển nào !!!');
      return;
    }

    try {
      isLoading.value = true;

      String? token = storage.read(jwtTokenKey);
      var result = await APIService.fetchDictionaryWords(
          token, selectedDictionaryID,
          page: page, pageSize: pageSize, search: search);
      if (result.isEmpty) {
        isLastPageDict.value = true;
      }

      if (page == 1) {
        // reset search result
        listWord.assignAll(result);
      } else {
        listWord.addAll(result);
      }

      listWord.sort((a, b) => a.orderNumber!.compareTo(b.orderNumber!));

      isFavoriteWord = false;
      update(['dictionary_words']);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getFavoriteWords(
      {String search = '', int page = 1, int pageSize = 15}) async {
    int selectedDictionaryID = _utilitiesController.selectedDictionaryID.value;

    if (selectedDictionaryID == 0) {
      AlertUtils.warn('Chưa chọn từ điển nào !!!');
      return;
    }

    try {
      isLoadingFavorite.value = true;

      String? token = storage.read(jwtTokenKey);
      var result = await APIService.fetchFavoriteWords(token,
          search: search, page: page, pageSize: pageSize);
      if (result.isEmpty) {
        isLastPageFavorites.value = true;
      }

      if (page == 1) {
        // reset search result
        listWordFavorite.assignAll(result);
      } else {
        listWordFavorite.addAll(result);
      }

      listWordFavorite.sort((a, b) => a.orderNumber!.compareTo(b.orderNumber!));
      isFavoriteWord = true;
      update(['favorite_words']);
    } finally {
      isLoadingFavorite.value = false;
    }
  }

  Future toggleFavoriteWord(int wordId, int orderNumber) async {
    try {
      String? token = storage.read(jwtTokenKey);
      var result =
          await APIService.postToggleFavoriteWord(token, wordId, orderNumber);

      if (result) {
        if (currentTabIndex == 0) {
          var wordIndex =
              listWord.indexWhere((element) => element.id == wordId);
          if (wordIndex > -1) {
            listWord[wordIndex].isFavorite = !listWord[wordIndex].isFavorite;
            update(['dictionary_words']);
          }
        } else {
          var wordIndex =
              listWordFavorite.indexWhere((element) => element.id == wordId);
          if (wordIndex > -1) {
            listWordFavorite[wordIndex].isFavorite =
                !listWordFavorite[wordIndex].isFavorite;
            update(['favorite_words']);
          }
        }
      } else {
        AlertUtils.error();
      }
    } finally {}
  }
}
