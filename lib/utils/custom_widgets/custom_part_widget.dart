import 'dart:developer';
import 'dart:io';

import 'package:am_sys/model/add_assert_request/add_assert_request.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/loadder/progress_indicator.dart';
import 'package:am_sys/utils/media_selector/meadia_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CustomPartWidget extends StatefulWidget {
  final int index, listSize;
  final SpareParts sparePartModel;
  final Function onRemove;
  List<XFile?> listSelectedImagesSparePartsImages;
  final VoidCallback addCallBack;

  CustomPartWidget({
    super.key,
    required this.index,
    required this.sparePartModel,
    required this.onRemove,
    required this.listSize,
    required this.listSelectedImagesSparePartsImages,
    required this.addCallBack,
  });

  @override
  State<CustomPartWidget> createState() => _CustomPartWidgetState();
}

class _CustomPartWidgetState extends State<CustomPartWidget> {
  List<XFile?> listSelectedImagesSparePartsImages = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void didUpdateWidget(covariant CustomPartWidget oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.text = widget.sparePartModel.partName ?? '';
      numberController.text = widget.sparePartModel.partNumber ?? '';
      // listSelectedImagesSparePartsImages = widget.listSelectedImagesSparePartsImages;
      if (oldWidget.listSelectedImagesSparePartsImages != widget.listSelectedImagesSparePartsImages) {
        setState(() {
          listSelectedImagesSparePartsImages = List.from(widget.listSelectedImagesSparePartsImages);
        });
      }
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TextFormField of Part Number
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'Part ${widget.index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (widget.listSize > 1)
              FilledButton.icon(
                onPressed: () => widget.onRemove(),
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  size: 20,
                ),
                label: const Text(
                  "Remove",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  minimumSize: Size.zero,
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        TextFormField(
          validator: (value) {
            return (value == null || value.isEmpty) ? "field required" : null;
          },
          textInputAction: TextInputAction.next,
          controller: numberController,
          onChanged: (value) {
            setState(() {
              widget.sparePartModel.partNumber = value;
            });
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(255),
          ],
          decoration: InputDecoration(
            label: const Text(AppConstants.partNumber),
            fillColor: AppColors.listBGColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.listBGColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            // border: const OutlineInputBorder(
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(8),
            //   ),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: AppColors.primaryColor,
            //     width: 2,
            //   ),
            // ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        /// TextFormField of Part Name
        TextFormField(
          validator: (value) {
            return (value == null || value.isEmpty) ? "field required" : null;
          },
          onChanged: (value) {
            setState(() {
              widget.sparePartModel.partName = value;
            });
          },
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(255),
          ],
          controller: nameController,
          decoration: InputDecoration(
            label: const Text(AppConstants.partName),
            fillColor: AppColors.listBGColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.listBGColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            // border: const OutlineInputBorder(
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(8),
            //   ),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: AppColors.primaryColor,
            //     width: 2,
            //   ),
            // ),
          ),
        ),
        const SizedBox(height: 20),

        /// ----------------- SpareParts Images ------------------- ///

        /// Image selection button
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(
                        width: 1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      _showSparPartActionSheet(context: context);
                    },
                    child: Text(
                      AppConstants.clickToSelectImage,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            (widget.index == (widget.listSize - 1))
                ? Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.add,
                          size: 24,
                        ),
                        onPressed: widget.addCallBack,
                        label: const Text(
                          AppConstants.add,
                          // style: textStyle,
                        ),
                        style: TextButton.styleFrom(),
                      ),
                    ),
                  )
                : const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
          ],
        ),

        /// Selected images shown in Grid format
        if (listSelectedImagesSparePartsImages.isNotEmpty) const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            return Image.file(
              File(listSelectedImagesSparePartsImages[index]!.path),
              fit: BoxFit.cover,
            );
          },
          itemCount: listSelectedImagesSparePartsImages.length,
        ),
      ],
    );
  }

  void _showSparPartActionSheet({required BuildContext context}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              pickSparePartImage(source: ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              pickSparePartImage(source: ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  pickSparePartImage({required ImageSource source}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 40),
          color: AppColors.whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ShowLoader(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );

    MediaSelector().openMediaPicker(context, source: source, pickMultiple: false, callBack: (file) {
      if (!(file?.isEmpty ?? true)) {
        setState(
          () {
            listSelectedImagesSparePartsImages = file ?? [];

            for (var element in listSelectedImagesSparePartsImages) {
              final bytes = File(element!.path).readAsBytesSync().lengthInBytes;
              final kb = bytes / 1024;
              log('****** ${element!.path} ******::$kb kb');
            }
          },
        );
      }
      Navigator.of(context).pop();
    }, isCropImage: false);
  }
}
