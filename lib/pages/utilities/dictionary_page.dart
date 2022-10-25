import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dictionary_controller.dart';
import 'package:stna_lms_flutter/controllers/dictionary_tab_controller.dart';
import 'package:stna_lms_flutter/helpers/text_helper.dart';
import 'package:stna_lms_flutter/models/dictionary_model.dart';
import 'package:stna_lms_flutter/pages/utilities/toggle_favorite_word.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/constant_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:badges/badges.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class DictionaryPage extends GetView<DictionaryController> {
  final DictionaryTabController _tabx = Get.put(DictionaryTabController());

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  DictionaryPage({Key? key}) : super(key: key);

  void _playPronunciation(String link) async {
    try {
      await controller.playPronounciation(link);
    } catch (err) {
      AlertUtils.error('Không thể phát âm của từ vựng. Vui lòng thử lại');
    }
  }

  onSearchTextChanged(String text) async {
    controller.filterDictionary(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          showBack: true,
          title: "Từ Điển Tiếng Anh",
          showSearch: true,
          searching: onSearchTextChanged,
          hintTextSearch: "Nhập từ khoá để tìm từ vựng",
          bottom: TabBar(
            controller: _tabx.controller,
            tabs: _tabx.myTabs,
          )),
      body: TabBarView(
          controller: _tabx.controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [_buildDictionaryListWord(), _buildFavoriteListWord()]),
    );
  }

  void _showWordDetail(DictionaryWordModel word) async {
    List<String> wordTypes = word.wordTypes != null ? word.wordTypes! : [];
    List<Widget> definitions = [
      _buildDefinitionDetail(word.meaning, word.examples)
    ];

    controller.viewWord(word);

    Get.defaultDialog(
        title:
            '#${word.orderNumber ?? 0}: ${TextHelper.lowerCase(word.word)} /${TextHelper.lowerCase(word.pronunciation)}/',
        backgroundColor: Get.theme.cardColor,
        titleStyle:
            AppTextThemes.heading7().copyWith(color: AppStyles.blueDark),
        barrierDismissible: true,
        radius: 10.sp,
        content: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: _wp * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: _hp * 20,
                  decoration: LayoutUtils.boxDecoration(),
                  padding: EdgeInsets.all(5.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                    child: LayoutUtils.fadeInImage(
                        image:
                            NetworkImage(getFullResourceUrl(word.image ?? '')),
                        error: 'images/layout/sorry-16x9.jpg',
                        placeholder:
                            'images/placeholders/image-loading-16x9.jpg',
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              _buildWordTypeList(wordTypes),
              Container(
                  height: _hp * 30,
                  width: Get.width,
                  padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.only(bottom: 15, left: 5, top: 0),
                      itemCount: definitions.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return definitions[index];
                      })),
              const SizedBox(height: 5),
              ToggleFavoriteWord(word: word),
              const SizedBox(height: 5),
              GestureDetector(
                  onTap: () {
                    _playPronunciation(word.pronunciationAudio ?? '');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: _wp * 5, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: AppStyles.green,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget _buildWordExamples(List<DictionaryWordExampleModel>? examples) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(width: 10.0, color: AppStyles.green),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...((examples ?? [])
                .map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.example ?? '',
                          style: AppTextThemes.heading7(),
                        ),
                        Text(
                          e.hint ?? '',
                          style: AppTextThemes.heading7().copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppStyles.secondary,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ))
                .toList())
          ],
        ));
  }

  Widget _buildDefinitionDetail(
      String? meaning, List<DictionaryWordExampleModel>? examples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 10.0, color: AppStyles.blueDark),
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: _wp * 50,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          meaning ?? '',
                          style: AppTextThemes.heading7(),
                        ))
                  ],
                )
              ],
            )),
        const SizedBox(
          height: 5,
        ),
        _buildWordExamples(examples)
      ],
    );
  }

  Widget _buildDictionaryListWord() {
    return GetBuilder<DictionaryController>(
        id: 'dictionary_words',
        builder: (controller) {
          return _buildListWord(
              controller.isLoading.value, controller.listWord, false);
        });
  }

  Widget _buildFavoriteListWord() {
    return GetBuilder<DictionaryController>(
        id: 'favorite_words',
        builder: (controller) {
          return _buildListWord(controller.isLoadingFavorite.value,
              controller.listWordFavorite, true);
        });
  }

  Widget _buildListWord(
      bool isLoading, List<DictionaryWordModel> words, bool isFavorite) {
    if (isLoading) {
      return Center(
        child: activityIndicator(),
      );
    }

    if (words.isEmpty) {
      return Center(
        child: textHeading("Không có kết quả"),
      );
    }

    return Scaffold(
      body: Obx(() {
        return LazyLoadScrollView(
            onEndOfPage: controller.loadNextPage,
            child: ListView.builder(
                padding:
                    EdgeInsets.only(left: 20.sp, top: 10.sp, bottom: 10.sp),
                itemCount: words.length,
                itemBuilder: (BuildContext context, int index) {
                  var word = words[index];
                  List<String> wordTypes = word.wordTypes ?? [];
                  final textWord = TextHelper.lowerCase(words[index].word);
                  final pronunciation =
                      '/${TextHelper.lowerCase(word.pronunciation ?? '')}/';
                  final textWordStyle = AppTextThemes.heading5();
                  final TextStyle pronunciationStyle = AppTextThemes.heading5()
                      .copyWith(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic);
                  final wordSize =
                      getTextSize(context, textWord, textWordStyle);
                  final pronunciationSize =
                      getTextSize(context, pronunciation, pronunciationStyle);
                  final isColumn = (wordSize.width + pronunciationSize.width) >
                      Get.width - 140.sp;

                  return GestureDetector(
                    child: Badge(
                        showBadge: !isFavorite,
                        badgeContent: Text(
                          '${(words[index].orderNumber ?? 0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        gradient: LayoutUtils.gradientBlueDark,
                        borderRadius: BorderRadius.circular(5.sp),
                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                        elevation: 2.sp,
                        shape: BadgeShape.square,
                        position: BadgePosition.topStart(),
                        child: Container(
                          decoration: LayoutUtils.boxDecoration(),
                          margin: EdgeInsets.only(bottom: 20.sp, right: 15.sp),
                          child: IntrinsicHeight(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 5.sp, right: 5.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15.sp,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: isColumn
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          textWord,
                                                          style: textWordStyle,
                                                        ),
                                                        Text(
                                                          pronunciation,
                                                          style:
                                                              pronunciationStyle,
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          textWord,
                                                          style: textWordStyle,
                                                        ),
                                                        Text(
                                                          pronunciation,
                                                          style:
                                                              pronunciationStyle,
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                            SizedBox(width: 5.sp),
                                            IconButton(
                                                onPressed: () {
                                                  _playPronunciation(words[
                                                              index]
                                                          .pronunciationAudio ??
                                                      '');
                                                },
                                                icon: Icon(
                                                  Icons.volume_up_rounded,
                                                  size: 18.sp,
                                                ))
                                          ],
                                        ),
                                      ),
                                      _buildWordTypeList(wordTypes),
                                      SizedBox(height: 5.sp)
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    await controller.toggleFavoriteWord(
                                        word.id ?? 0, word.orderNumber ?? 0);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.sp),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.sp, horizontal: 5.sp),
                                    decoration: BoxDecoration(
                                        gradient: word.isFavorite
                                            ? LayoutUtils.gradientBlueDark
                                            : LayoutUtils.gradientGrey,
                                        borderRadius:
                                            BorderRadius.circular(5.sp)),
                                    child: Icon(
                                      word.isFavorite
                                          ? Icons.flag_rounded
                                          : Icons.outlined_flag_rounded,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  ))
                            ],
                          )),
                        )),
                    onTap: () {
                      _showWordDetail(word);
                    },
                  );
                }));
      }),
    );
  }

  Size getTextSize(BuildContext context, String text, TextStyle textStyle) {
    final Size size = (TextPainter(
            text: TextSpan(text: text, style: textStyle),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    return size;
  }

  Widget _buildWordTypeList(List<String> types) {
    List<String> distinctTypes = [];

    // distinct
    for (var type in types) {
      if (!distinctTypes.contains(type)) {
        distinctTypes.add(type);
      }
    }

    // sort
    distinctTypes.sort((String a, String b) => a.compareTo(b));

    if (distinctTypes.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30.sp,
          width: _wp * 80,
          child: ListView.separated(
              padding: EdgeInsets.only(bottom: _hp * 0.5, top: _hp * 0.5),
              scrollDirection: Axis.horizontal,
              itemCount: distinctTypes.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 5.sp,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                var type = distinctTypes[index];
                var color = AppStyles.grey;
                int typeIndex =
                    ConstantUtils.wordTypes.indexOf(type.toLowerCase());
                if (typeIndex < 0 ||
                    typeIndex > (AppStyles.colorWheels.length - 1)) {
                  color = AppStyles.grey;
                } else {
                  color = AppStyles.colorWheels[typeIndex];
                }

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LayoutUtils.radialGradient(
                          [color, color.withOpacity(0.6)]),
                      borderRadius: BorderRadius.circular(5.sp)),
                  padding: EdgeInsets.symmetric(horizontal: 15.sp),
                  child: Text(
                    distinctTypes[index],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextThemes.heading7().copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
