import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

typedef ImageSelectionCallBack = void Function(List<XFile>? file);

class MediaSelector {
  factory MediaSelector() {
    return _singleton;
  }

  static final MediaSelector _singleton = MediaSelector._internal();

  MediaSelector._internal() {
    log("Instance created MediaSelector");
  }

  ///Get Permission Message
  String _getMessageForPermission(ImageSource source) {
    if (source == ImageSource.camera) {
      return 'Access your camera so you can include a photo in your profile, go to settings and allow access.';
    } else {
      return 'Access to your photos or videos so you can include them in your profile, go to settings and allow access.';
    }
  }

  /// Rational Permission Dialog
  _showRationalPermissionDialog(BuildContext context, ImageSource source) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(_getMessageForPermission(source)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  //region Check for permission group
  Future<PermissionStatus> checkForPermission(Permission permission, {bool isContinuous = false}) async {
    if (Platform.isIOS) {
      return await _checkPermissionForIOS(permission);
    } else if (Platform.isAndroid) {
      return await _checkPermissionForAndroid(permission, isContinuous);
    } else {
      return PermissionStatus.denied;
    }
  }

  //endregion

  //region IOS
  Future<PermissionStatus> _checkPermissionForIOS(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    log(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return permissionStatus;
    } else if (permissionStatus == PermissionStatus.limited) {
      return permissionStatus;
    } else if (permissionStatus == PermissionStatus.denied) {
      log("PermissionGroup :: $permission");
      PermissionStatus status = await permission.request();
      return status;
    } else {
      return PermissionStatus.denied;
    }
  }

  //endregion

  //region Android
  Future<PermissionStatus> _checkPermissionForAndroid(Permission permission, bool isContinuous) async {
    PermissionStatus permissionStatus = await permission.status;
    log(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return permissionStatus;
    } else if (permissionStatus == PermissionStatus.denied) {
      PermissionStatus pStatus = await permission.request();
      log(" PermissionStatus :: ${pStatus.toString()}");
      if (pStatus == PermissionStatus.granted) {
        return pStatus;
      } else if (pStatus == PermissionStatus.permanentlyDenied) {
        return pStatus;
      } else {
        if (isContinuous) {
          bool status = await _checkPermissionForNeverAsk(permission);
          return status ? PermissionStatus.granted : pStatus;
        } else {
          return pStatus;
        }
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return permissionStatus;
    }
    return permissionStatus;
  }

  Future<bool> _checkPermissionForNeverAsk(Permission permission) async {
    log("_check Permission For NeverAsk");
    PermissionStatus permissionStatus = await permission.request();
    log(" PermissionStatus :: ${permissionStatus.toString()}");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return false;
    } else {
      bool status = await _checkPermissionForNeverAsk(permission);
      return status;
    }
  }

  ///Open Image Picker for Image Selection
  Future<void> openMediaPicker(BuildContext context,
      {required ImageSource source,
      required ImageSelectionCallBack callBack,
      bool pickMultiple = false,
      bool isImageResize = true,
      bool isCropImage = false}) async {
    ///Check Permission for camera
    if (source == ImageSource.camera) {
      PermissionStatus permissionAllowed = await checkForPermission(Permission.camera);

      if (permissionAllowed != PermissionStatus.granted) {
        log("Permission Declined for Camera");
        if (permissionAllowed == PermissionStatus.permanentlyDenied || Platform.isIOS) {
          if (context.mounted) {
            _showRationalPermissionDialog(context, source);
          }
        }
        // callBack(null);
        return;
      }
    }

    ///Check Permission for Gallery
    else {
      AndroidDeviceInfo? info;
      if (Platform.isAndroid) {
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        info = await deviceInfoPlugin.androidInfo;
      }
      Permission permission = (Platform.isIOS || (info!.version.sdkInt >= 33)) ? Permission.photos : Permission.storage;
      PermissionStatus permissionAllowed = await checkForPermission(permission);
      if (permissionAllowed != PermissionStatus.granted) {
        log("Permission Declined for Photo");
        if (permissionAllowed == PermissionStatus.permanentlyDenied || Platform.isIOS) {
          if (context.mounted) {
            _showRationalPermissionDialog(context, source);
          }
        }
        // callBack(null);
        return;
      }
    }

    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;

      if (pickMultiple) {
        List<XFile> images = await picker.pickMultiImage(
          imageQuality: 60,
          limit: 3,
        );

        if (images.isNotEmpty) {
          for (var img in images) {
            File fixedRotationFile = await FlutterExifRotation.rotateAndSaveImage(path: img.path);
            XFile xfile = XFile(fixedRotationFile.path);
            log("Path Fixed Rotation Galley :: ${fixedRotationFile.path}");
            img = xfile;
          }
        }

        callBack((images.isNotEmpty) ? images : []);
      } else {
        if (isImageResize) {
          pickedFile = await picker.pickImage(source: source, maxHeight: 1080.0, maxWidth: 720.0);
        } else {
          pickedFile = await picker.pickImage(source: source);
        }

        XFile? selectedFile = (pickedFile != null) ? XFile(pickedFile.path) : null;

        ///Crop Image
        if ((pickedFile != null) && isCropImage) {
          CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: File(pickedFile.path).path, aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ], uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.grey,
                toolbarWidgetColor: Colors.white,
                backgroundColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ]);

          selectedFile = XFile(croppedFile!.path);
        }

        log("Path Galley :: ${selectedFile?.path ?? ''}");
        if (selectedFile != null) {
          File fixedRotationFile = await FlutterExifRotation.rotateAndSaveImage(path: selectedFile.path);
          XFile xfile = XFile(fixedRotationFile.path);
          log("Path Fixed Rotation Galley :: ${fixedRotationFile.path}");
          selectedFile = xfile;
        }
        callBack((selectedFile != null) ? [selectedFile] : null);
      }
    } catch (error) {
      log("Error :: ${error.toString()}");
    }
  }

  ///Open Video Picker for Video Selection
// Future<void> openVideoPicker(BuildContext context,
//     {required ImageSelectionCallBack callBack}) async {
//   AndroidDeviceInfo? info;
//   if (Platform.isAndroid) {
//     final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     info = await deviceInfoPlugin.androidInfo;
//   }
//
//   // Check Permission for Gallery
//   Permission permission = (Platform.isAndroid && (info!.version.sdkInt >= 33))
//       ? Permission.videos
//       : Permission.storage;
//   PermissionStatus permissionAllowed = await checkForPermission(permission);
//   if (permissionAllowed != PermissionStatus.granted) {
//     log("Permission Declined for Video");
//     if (permissionAllowed == PermissionStatus.permanentlyDenied || Platform.isIOS) {
//       if (context.mounted) {
//         _showRationalPermissionDialog(context, ImageSource.gallery);
//       }
//     }
//     callBack(null);
//     return;
//   }
//
//   try {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? images = await picker.pickMultiImage();
//
//     if (images != null && images.isNotEmpty) {
//       List<File> selectedFiles = images.map((image) => File(image.path)).toList();
//       callBack(selectedFiles);
//     } else {
//       callBack(null);
//     }
//   } catch (error) {
//     log("Error :: ${error.toString()}");
//   }
//   // try {
//   //   final ImagePicker picker = ImagePicker();
//   //   final List<XFile> images = await picker.pickMultiImage();
//   //
//   //   XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
//   //
//   //   File? selectedFile = (pickedFile != null) ? File(pickedFile.path) : null;
//   //
//   //   log("Path Gallery :: ${selectedFile?.path ?? ''}");
//   //   if (selectedFile != null) {
//   //     callBack([selectedFile]);
//   //   } else {
//   //     callBack(null);
//   //   }
//   // } catch (error) {
//   //   log("Error :: ${error.toString()}");
//   // }
// }
}
