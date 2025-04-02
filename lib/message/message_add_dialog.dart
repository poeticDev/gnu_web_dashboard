import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_web_dashboard/common/component/custom_text_form_field.dart';
import 'package:gnu_web_dashboard/common/component/custom_toast.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/message_controller.dart';
import 'package:gnu_web_dashboard/common/util/data/model/message_model.dart';
import 'package:gnu_web_dashboard/common/util/data/model/room_model.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class MessageAddDialog extends StatefulWidget {
  final String? roomId;
  final double width;
  final double height;
  final WidgetRef ref;

  const MessageAddDialog({
    super.key,
    required this.width,
    required this.height,
    this.roomId,
    required this.ref,
  });

  @override
  State<MessageAddDialog> createState() => _MessageAddDialogState();
}

class _MessageAddDialogState extends State<MessageAddDialog> {
  /// 2) 대상 강의실
  List<String> roomId = [];

  /// 3) 메세지 내용
  String content = '';

  /// 4) 대상 기기
  List<String> target = ['wall_hub'];

  /// 4) 표출 기간
  DateTime? until;

  /// 5) 메세지 타입
  MessageType type = MessageType.normal;

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

  final List<Room> roomList =
      initialRooms
          .where(
            (room) =>
                ((room.equipMap['wall_hub'] != null &&
                        room.equipMap['wall_hub'] == true) ||
                    (room.equipMap['class_hub'] != null &&
                        room.equipMap['class_hub'] == true)),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    const double FIELD_PADDING_VERTICAL = 12.0;

    return AlertDialog(
      title: Text('메세지 추가하기'),
      actions: [
        TextButton(onPressed: _onSaveButtonPressed, child: Text('저장')),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
      ],
      content: Container(
        width: widget.width,
        height: widget.height,
        constraints: BoxConstraints(minWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Text('대상 강의실', style: FIELD_TITLE_TEXT_STYLE),
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
                title: '메세지',
                hintText: '전달하고 싶은 메세지를 입력하세요.',
                onChanged: (inputText) {
                  content = inputText;
                },
                isRequired: true,
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Text('대상 기기', style: FIELD_TITLE_TEXT_STYLE),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  DropdownSearch<String>.multiSelection(
                    mode: Mode.form,
                    popupProps: PopupPropsMultiSelection<String>.menu(
                      showSelectedItems: true,
                      constraints: BoxConstraints(maxHeight: 140),
                    ),
                    items: (filter, cs) => ['키오스크', '강의실 태블릿'],
                    selectedItems: target,
                    onChanged: (targetLabelList) {
                      for (String targetLabel in targetLabelList) {
                        if (targetLabel == '키오스크') {
                          targetLabel = 'wall_hub';
                        } else if (targetLabel == '강의실 태블릿') {
                          targetLabel = 'class_hub';
                        }

                        target = [...target, targetLabel];
                      }
                    },
                  ),
                  Text(
                    "* 강의실 태블릿은 추후 지원예정입니다.",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              GestureDetector(
                onTap: () async {
                  until = await showOmniDateTimePicker(
                    context: context,
                    initialDate: until ?? DateTime.now().add(Duration(days: 1)),
                  );

                  setState(() {});
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    title: '표출기간',
                    initialValue:
                        until == null
                            ? null
                            : '${until!.year}년 ${until!.month}월 ${until!.day}일 ${until!.hour}시 ${until!.minute}분까지',
                    hintText: '언제까지 표출할 것인지 입력해주세요. 미지정시 내일 현재 시간으로 설정됩니다.',
                    onChanged: (inputText) {},
                    isRequired: true,
                    isReadOnly: true,
                  ),
                ),
              ),
              SizedBox(height: FIELD_PADDING_VERTICAL),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Text('*', style: TextStyle(color: Colors.red)),
                      Text('메세지 타입', style: FIELD_TITLE_TEXT_STYLE),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  DropdownSearch<String>(
                    mode: Mode.form,
                    selectedItem: type.label,
                    popupProps: PopupProps<String>.menu(
                      showSelectedItems: true,
                      constraints: BoxConstraints(maxHeight: 180),
                    ),
                    items:
                        (filter, cs) =>
                            MessageType.values
                                .map((type) => type.label)
                                .toList(),
                    onChanged: (label) {
                      if (label != null) type = messageTypeFromLabel(label);
                    },
                  ),
                  Text(
                    "*'공지사항'과 '경고'는 표출이 끝날 때까지 미디어창을 가리며 크게 표시됩니다.",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ],
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
    } else if (content == '') {
      showCustomToast(toastMsg: '메세지를 입력해주세요!', fToast: fToast);
    } else if (target.isEmpty) {
      showCustomToast(toastMsg: '대상 기기를 선택해주세요!', fToast: fToast);
    } else {
      until ??= DateTime.now().add(Duration(days: 1));

      final Message message = Message.withoutKey(
        roomIdList: roomId,
        content: content,
        target: target,
        until: until!,
        type: type,
      );

      dLog('message: ${message.getMessageMap()}');

      final result = await widget.ref
          .read(messageControllerProvider.notifier)
          .upsertSingleMessageToServer(message: message);

      if (result == 0)
        showCustomToast(toastMsg: '메세지가 성공적으로 등록되었습니다!', fToast: fToast);
      else {
        showCustomToast(
          toastMsg: '메세지 등록 중 에러가 발생했습니다. 메세지가 등록되었는지 확인해주세요.',
          fToast: fToast,
        );
      }
      Navigator.of(context).pop();
    }
  }
}
