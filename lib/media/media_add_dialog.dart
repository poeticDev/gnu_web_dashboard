import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_web_dashboard/common/component/custom_text_form_field.dart';
import 'package:gnu_web_dashboard/common/component/custom_toast.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/media_controller.dart';
import 'package:gnu_web_dashboard/common/util/data/model/media_item_model.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';

class MediaAddDialog extends StatefulWidget {
  final String? roomId;
  final double width;
  final double height;
  final WidgetRef ref;

  MediaAddDialog({
    super.key,
    required this.width,
    required this.height,
    this.roomId,
    required this.ref,
  });

  @override
  State<MediaAddDialog> createState() => _MediaAddDialogState();
}

class _MediaAddDialogState extends State<MediaAddDialog> {
  /// 1) 식별 키
  late String itemKey;

  /// 2) 대상 강의실
  List<String> roomId = [];

  /// 3) 미디어 이름
  String title = '';

  /// 4) 미디어 타입
  MediaType type = MediaType.image;

  /// 5) 주소
  String url = '';

  /// 6) 파일명
  /// - 없으면 url 마지막 부분에서 파일명 추출
  String? fileName;

  /// 7) 저장위치
  MediaFrom from = MediaFrom.etc;

  /// 8) 미디어 표출 방식
  /// - cover(기본): 꽉 채움
  /// - contain: 여백이 있더라도 다 나오게)
  BoxFit fit = BoxFit.cover;

  /// 9) 표출 순서 : 기본 생성순
  int orderNum = 999;

  /// 토스트 팝업
  late FToast fToast;

  @override
  void initState() {
    if (widget.roomId != null) {
      roomId.add(widget.roomId!);
    }
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  // 일단 현재는 하드코딩으로 등록하되, 나중에는 서버에서 룸 정보를 불러오는 방식으로 할 것
  final List<Room> roomList =
      initialRooms
          .where(
            (room) =>
                room.equipMap['wall_hub'] != null &&
                room.equipMap['wall_hub'] == true,
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    const double FIELD_PADDING_VERTICAL = 12.0;

    return AlertDialog(
      title: Text('미디어 아이템 추가하기'),
      actions: [
        TextButton(onPressed: _onSaveButtonPressed, child: Text('저장')),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
      ],
      content: SizedBox(
        width: widget.width,
        height: widget.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Text('대상 강의실(키오스크)', style: FIELD_TITLE_TEXT_STYLE),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  DropdownSearch<String>.multiSelection(
                    mode: Mode.form,
                    popupProps: PopupPropsMultiSelection<String>.menu(
                      showSelectedItems: true,
                      constraints: BoxConstraints(maxHeight: 180),
                    ),
                    items:
                        (filter, cs) =>
                            roomList.map((room) => room.roomName).toList(),
                    selectedItems: roomId,
                    onChanged: (roomNameList) {
                      for (String roomName in roomNameList) {
                        final room =
                            roomList
                                .firstWhere((room) => room.roomName == roomName)
                                .roomId;

                        roomId = [...roomId, room];
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              CustomTextFormField(
                title: '미디어 이름',
                hintText: '관리를 위한 이름입니다. 실제 화면에는 표출되지 않습니다.',
                // initialValue: title,
                onChanged: (inputText) {
                  title = inputText;
                },
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Text('미디어 타입', style: FIELD_TITLE_TEXT_STYLE),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  DropdownSearch<String>(
                    mode: Mode.form,
                    popupProps: PopupPropsMultiSelection<String>.menu(
                      showSelectedItems: true,
                      constraints: BoxConstraints(maxHeight: 100),
                    ),
                    items:
                        (filter, cs) =>
                            MediaType.values
                                .map((mediaType) => mediaType.label)
                                .toList(),
                    onChanged: (mediaTypeLabel) {
                      if (mediaTypeLabel != null)
                        type = mediaTypeFromLabel(mediaTypeLabel);
                    },
                  ),
                ],
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              CustomTextFormField(
                title: '주소',
                hintText: '다운받을 수 있는 웹 주소를 적어주세요. 대상 기기가 자동으로 다운로드합니다.',
                onChanged: (inputText) {
                  url = inputText;
                },
                isRequired: true,
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              CustomTextFormField(
                title: '파일명',
                hintText: '일반적으로 공백으로 두셔도 됩니다. 위 주소에 파일명이 없는 경우에만 입력해주세요.',
                // initialValue: title,
                onChanged: (inputText) {
                  if (inputText == '') {
                    fileName = null;
                  } else {
                    fileName = inputText;
                  }
                },
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Text('저장 위치', style: FIELD_TITLE_TEXT_STYLE),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  DropdownSearch<String>(
                    mode: Mode.form,
                    selectedItem: from.label,
                    popupProps: PopupPropsMultiSelection<String>.menu(
                      showSelectedItems: true,
                      constraints: BoxConstraints(maxHeight: 100),
                    ),
                    items:
                        (filter, cs) =>
                            MediaFrom.values
                                .map((mediaFrom) => mediaFrom.label)
                                .toList(),
                    onChanged: (mediaFromLabel) {
                      if (mediaFromLabel != null)
                        from = mediaFromFromLabel(mediaFromLabel);
                    },
                  ),
                ],
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('표출 방식', style: FIELD_TITLE_TEXT_STYLE),
                  SizedBox(height: 6.0),
                  DropdownSearch<String>(
                    mode: Mode.form,
                    selectedItem: fit.label,
                    popupProps: PopupPropsMultiSelection<String>.menu(
                      showSelectedItems: true,
                      constraints: BoxConstraints(maxHeight: 180),
                    ),
                    items:
                        (filter, cs) =>
                            [
                              BoxFit.cover,
                              BoxFit.contain,
                              BoxFit.fill,
                            ].map((boxFit) => boxFit.label).toList(),
                    onChanged: (boxFitLabel) {
                      if (boxFitLabel != null)
                        fit = boxFitFromLabel(boxFitLabel);
                    },
                  ),
                ],
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              CustomTextFormField(
                title: '표출 순서',
                textInputType: TextInputType.number,
                hintText: '기본적으로 등록순으로 표출됩니다.',
                // initialValue: title,
                onChanged: (inputText) {
                  if (inputText == '') {
                    orderNum = 999;
                  } else {
                    orderNum = int.tryParse(inputText)!;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveButtonPressed() async {
    if (roomId.isEmpty) {
      showCustomToast(toastMsg: '대상 강의실을 선택해주세요!', fToast: fToast);
    } else if (url == '') {
      showCustomToast(toastMsg: '주소를 입력해주세요!', fToast: fToast);
    } else {
      if (title == '') {
        title = '무명';
      }

      final MediaItem mediaItem = MediaItem.withoutKey(
        roomIdList: roomId,
        title: title,
        type: type,
        url: url,
        fileName: fileName,
        from: from,
        fit: fit,
        orderNum: orderNum,
      );

      final result = await widget.ref
          .read(mediaControllerProvider.notifier)
          .upsertSingleMediaItemToServer(mediaItem: mediaItem);

      if (result == 0)
        showCustomToast(toastMsg: '미디어가 성공적으로 등록되었습니다!', fToast: fToast);
      else {
        showCustomToast(
          toastMsg: '미디어 등록 중 에러가 발생했습니다. 실제로 미디어가 등록되었는지 확인해주세요.',
          fToast: fToast,
        );
      }
      Navigator.of(context).pop();
    }
  }
}
