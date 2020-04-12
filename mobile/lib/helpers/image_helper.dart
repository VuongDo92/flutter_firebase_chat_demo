import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bittrex_app/config/env.dart';
import 'package:core/repositories/providers/api_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Image;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PickedAssetImageSource extends ImageSource {
  final Asset asset;

  PickedAssetImageSource(this.asset);

  Future<List<int>> getBytes() {
    return ImageUtils.resizeAndCompressAsset(asset, quality: 80);
  }

  int get width => asset.originalWidth;
  int get height => asset.originalHeight;
  String get contentType => 'jpeg';
}

class FileImageSource extends ImageSource {
  final File file;
  final int width;
  final int height;

  FileImageSource(this.file, {this.width = 0, this.height = 0});

  Future<List<int>> getBytes() {
    return file.readAsBytes();
  }

  String get contentType => 'jpeg';
}

class MemoryImageSource extends ImageSource {
  final ui.Image image;

  MemoryImageSource(this.image);

  Future<List<int>> getBytes() async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asInt8List();
  }

  int get width => image.width;
  int get height => image.height;
  String get contentType => 'png';
}

class ImageUtils {
  static Future<List<int>> resizeAndCompressAsset(Asset asset,
      {int quality = 80, int maxSize = 10000, bool release = true}) async {
    ByteData byteData = await asset.requestOriginal(quality: quality);

    final request = _ResizeCompressAssetRequest(
        byteData: byteData, quality: quality, maxSize: maxSize);
    final bytes = await compute(_resizeAndCompressAsset, request);
    if (release) {
      byteData = null;
    }
    return bytes;
  }

  static ImageProcessing resizeAndCompressProcessing({
    int quality = 80,
    int maxSize = 2000,
  }) {
    ImageProcessing processing = (Uint8List data) {
      final request = _ResizeCompressDataRequest(
        data: data,
        quality: quality,
        maxSize: maxSize,
      );
      return compute(_resizeAndCompressData, request);
    };
    return processing;
  }

  static Future<String> downloadAndSaveImage(
      String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static resizedImageUrl(BuildContext context, String originalUrl,
      {double width, double height}) {
    final env = Provider.of<Env>(context);

    if (originalUrl.contains(env.defaultProfilePictureKey)) {
      return originalUrl;
    } else if (originalUrl.contains(env.fbHost)) {
      return transformedFBUrl(context, originalUrl);
    }

    final ratio = MediaQuery.of(context).devicePixelRatio.round();
    final imageRequest = const JsonEncoder().convert({
      "bucket": env.s3Bucket,
      "key": Uri.decodeFull(originalUrl
          .replaceAll('${env.s3Hosts.first}/', '')
          .replaceAll('${env.s3Hosts[1]}/', '')
          .replaceAll('${env.s3Bucket}/', '')),
      "edits": {
        "resize": {
          "width": (width ?? 50) * ratio,
          "height": (height ?? 50) * ratio,
          "fit": "cover"
        }
      }
    });
    var bytes = utf8.encode(imageRequest);
    var base64Str = base64.encode(bytes);

    return '${env.cloudFrontUrl}/$base64Str';
  }

  static transformedFBUrl(BuildContext context, String originalUrl) {
    final env = Provider.of<Env>(context);

    if (originalUrl.contains(env.defaultProfilePictureKey)) {
      return originalUrl;
    } else if (originalUrl.contains(env.fbHost)) {
      Uri uri = Uri.parse(originalUrl);
      return 'https://graph.facebook.com/v3.2/${uri.queryParameters['asid']}/picture?type=large';
    }

    return originalUrl;
  }
}

class _ResizeCompressAssetRequest {
  final ByteData byteData;
  final int quality;
  final int maxSize;
  _ResizeCompressAssetRequest({this.byteData, this.quality, this.maxSize});
}

List<int> _resizeAndCompressAsset(_ResizeCompressAssetRequest request) {
  Image.Image image = Image.decodeImage(request.byteData.buffer.asUint8List());
  if (image.width >= image.height && image.width > request.maxSize) {
    Image.Image smallerImage = Image.copyResize(image, width: request.maxSize);
    return Image.encodeJpg(smallerImage, quality: request.quality);
  }
  if (image.width < image.height && image.height > request.maxSize) {
    Image.Image smallerImage = Image.copyResize(image, height: request.maxSize);
    return Image.encodeJpg(smallerImage, quality: request.quality);
  }
  return Image.encodeJpg(image, quality: request.quality);
}

class _ResizeCompressDataRequest {
  final Uint8List data;
  final int quality;
  final int maxSize;
  _ResizeCompressDataRequest({this.data, this.quality, this.maxSize});
}

Uint8List _resizeAndCompressData(_ResizeCompressDataRequest request) {
  try {
    Image.Image image = Image.decodeImage(request.data);
    if (image.width >= image.height && image.width > request.maxSize) {
      Image.Image smallerImage =
          Image.copyResize(image, width: request.maxSize);
      return Image.encodeJpg(smallerImage, quality: request.quality);
    }
    if (image.width < image.height && image.height > request.maxSize) {
      Image.Image smallerImage =
          Image.copyResize(image, height: request.maxSize);
      return Image.encodeJpg(smallerImage, quality: request.quality);
    }
    return Image.encodeJpg(image, quality: request.quality);
  } catch (e) {
    return request.data;
  }
}
