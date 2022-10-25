import 'package:flutter/cupertino.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/helpers/image_helper.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

AssetImage defaultAssetImage() {
  return const AssetImage('images/placeholders/image-loading.png');
}

Image defaultImage() {
  return Image.asset('images/placeholders/image-loading.png');
}

AssetImage defaultErrorImage16x9() {
  return const AssetImage('images/layout/sorry-16x9.jpg');
}

AssetImage defaultQuizImage() {
  return const AssetImage('images/layout/quiz.png');
}

AssetImage defaultAccountImage() {
  return const AssetImage('images/placeholders/account.png');
}

String? getYoutubeThumbnailUrl(String? videoUrl) {
  if (videoUrl == null) {
    return null;
  }

  final Uri? uri = Uri.tryParse(videoUrl);

  if (uri == null) {
    return null;
  }

  String? youtubeId = uri.queryParameters['v'];
  if (youtubeId == null && uri.pathSegments.isNotEmpty) {
    youtubeId = uri.pathSegments[0];
  }

  if (youtubeId == null) {
    return null;
  }

  return 'https://img.youtube.com/vi/$youtubeId/0.jpg';
}

String getFullResourceUrl(String url) {
  return '$cmsUrl$url';
}

NetworkImage avatarImage(String url) {
  return NetworkImage(getFullResourceUrl(url));
}

Widget questionImage(String? thumbnail, {double? height, double? width}) {
  if (thumbnail == null) {
    return LayoutUtils.fadeInImage(
        fit: BoxFit.contain, image: defaultAssetImage());
  }

  return LayoutUtils.fadeInImage(
      fit: BoxFit.contain,
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      image: NetworkImage(getFullResourceUrl(thumbnail)));
}

Widget thumbnailImage(String? thumbnail,
    {BoxFit fit = BoxFit.cover, String? error, String? placeholder}) {
  if (thumbnail == null) {
    return LayoutUtils.fadeInImage(
        placeholder: placeholder,
        fit: fit,
        image: error == null ? AssetImage(error ?? '') : defaultAssetImage());
  }

  return LayoutUtils.fadeInImage(
    placeholder: placeholder,
    fit: fit,
    error: error,
    image: NetworkImage(getFullResourceUrl(thumbnail)),
  );
}

Widget accountImage(String? url) {
  if (url == null) {
    return LayoutUtils.fadeInImage(
      fit: BoxFit.cover,
      image: AssetImage(defaultAccountImageUrl),
      placeholder: defaultAccountImageUrl,
    );
  }

  return LayoutUtils.fadeInImage(
      fit: BoxFit.cover,
      image: NetworkImage(getFullResourceUrl(url)),
      placeholder: defaultAccountImageUrl);
}

Widget imageWidget(String path) {
  return thumbnailImage(path);
}

Widget thumbnailImageHeight(String? thumbnail, double height) {
  if (thumbnail == null) {
    return LayoutUtils.fadeInImage(
        height: height, fit: BoxFit.cover, image: defaultAssetImage());
  }

  return LayoutUtils.fadeInImage(
    fit: BoxFit.cover,
    image: NetworkImage(getFullResourceUrl(thumbnail)),
  );
}

DateTime safeConvertDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return DateTime(1980);
  }

  return dateTime;
}

bool dynamicToBoolean(dynamic input) {
  if (input == null) {
    return false;
  }

  return input == true;
}

double dynamicToDouble(dynamic input) {
  if (input == null) {
    return 0.0;
  }

  return double.parse(input.toString());
}

int dynamicToInt(dynamic input) {
  if (input == null || input == '') {
    return 0;
  }

  return int.parse(input.toString());
}

DateTime? dynamicToDateTime(dynamic input) {
  if (input == null) {
    return null;
  }

  return DateTime.parse(input.toString());
}

double safeDouble(double? value) {
  if (value == null || value.isNaN || value.isInfinite) {
    return 0;
  }

  return value;
}
