import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gnu_web_dashboard/common/component/custom_text_form_field.dart';
import 'package:gnu_web_dashboard/common/component/custom_toast.dart';
import 'package:gnu_web_dashboard/common/component/splash_circle.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';
import 'package:gnu_web_dashboard/common/util/data/model/Weekday.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/common/util/data/model/trina_columns.dart';
import 'package:gnu_web_dashboard/common/util/network/google_sheets.dart';
import 'package:trina_grid/trina_grid.dart';

class LectureDialog extends StatefulWidget {
  final List<Lecture>? lectureList;
  final int idInteger;
  final GoogleSheets gSheet;

  const LectureDialog({
    this.lectureList,
    super.key,
    required this.idInteger,
    required this.gSheet,
  });

  @override
  State<LectureDialog> createState() => _LectureDialogState();
}

class _LectureDialogState extends State<LectureDialog> {
  bool isLoading = false;

  late FToast fToast;
  late TrinaGridStateManager stateManager;

  String lectureName = '';
  String instructorName = '';
  int colorIndex = 0;
  Weekday weekday = Weekday.monday;
  TimeOfDay startAt = TimeOfDay.now();
  TimeOfDay endAt = TimeOfDay.now();

  final GridManager gridManager = GridManager();
  List<TrinaRow> lectureRows = [];

  @override
  void initState() {
    if (widget.lectureList != null) {
      lectureName = widget.lectureList!.first.lectureName;
      instructorName = widget.lectureList!.first.instructorName;
      colorIndex = widget.lectureList!.first.colorIndex;

      for (Lecture lecture in widget.lectureList!) {
        lectureRows.add(gridManager.getRowFromLectureModel(lecture));
      }

      if (mounted) {
        setState(() {});
      }
    }
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double FIELD_PADDING_VERTICAL = 12.0;
    const double FIELD_PADDING_HORIZONTAL = 12.0;

    return isLoading
        ? SplashCircle(statusMsg: '강의 정보 생성/수정 중')
        : AlertDialog(
          title: Text('강의 시간표 생성/수정하기'),
          actions: [
            TextButton(
              onPressed: () async {
                await _onSaveButtonPressed();
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              height: 480,
              child: Wrap(
                // crossAxisAlignment: CrossAxisAlignment.start,
                runSpacing: FIELD_PADDING_VERTICAL,
                spacing: FIELD_PADDING_HORIZONTAL,
                children: [
                  SizedBox(
                    width: 140,
                    child: CustomTextFormField(
                      title: '강의자명',
                      hintText: '강의자 이름을 적어주세요.',
                      initialValue: instructorName,
                      textInputType: TextInputType.multiline,
                      onChanged: (inputText) {
                        instructorName = inputText;
                      },
                      maxLines: 2,
                      isRequired: true,
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: CustomTextFormField(
                      title: '강의명',
                      hintText: '강의 이름을 적어주세요.',
                      textInputType: TextInputType.multiline,
                      initialValue: lectureName,
                      onChanged: (inputText) {
                        lectureName = inputText;
                      },
                      maxLines: 3,
                      isRequired: true,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.0,
                    children: [
                      Text('강의 시간', style: FIELD_TITLE_TEXT_STYLE),
                      Row(
                        spacing: FIELD_PADDING_HORIZONTAL,
                        children: [
                          SizedBox(
                            width: 340,
                            height: 200,
                            child: _RenderLectureGrid(),
                          ),
                          Column(
                            spacing: FIELD_PADDING_VERTICAL,
                            children: [
                              ElevatedButton(
                                onPressed: _handleAddRow,
                                child: Text('행 추가'),
                              ),
                              ElevatedButton(
                                onPressed: _handleRemoveCurrentRow,
                                child: Text('선택 제거'),
                              ),
                              ElevatedButton(
                                onPressed: _handleRemoveAllRows,
                                child: Text('일괄 제거'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.0,
                    children: [
                      Text('색상', style: FIELD_TITLE_TEXT_STYLE),
                      Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: _RenderColorRow(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Future<void> _onSaveButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    final List<Lecture> newLectureList = [];
    final List<double> newIdList = [];

    for (TrinaRow row in stateManager.rows) {
      final double id = row.cells['id']!.value;
      final String? weekday = row.cells['weekday']?.value;
      if (weekday == null) {
        showCustomToast(toastMsg: '요일이 정해지지 않은 강의가 있습니다!', fToast: fToast);
        return;
      }
      final String? startAt = row.cells['startAt']?.value;
      if (startAt == null) {
        showCustomToast(toastMsg: '시작 시간이 정해지지 않은 강의가 있습니다!', fToast: fToast);
        return;
      }

      final String? endAt = row.cells['endAt']?.value;
      if (endAt == null) {
        showCustomToast(toastMsg: '종료 시간이 정해지지 않은 강의가 있습니다!', fToast: fToast);
        return;
      }
      Lecture lecture = Lecture(
        id: id,
        lectureName: lectureName,
        instructorName: instructorName,
        weekday: getWeekDayFromKr(weekday),
        startAt: getTimeFromString(startAt),
        endAt: getTimeFromString(endAt),
        colorIndex: colorIndex,
      );

      newLectureList.add(lecture);
      newIdList.add(id);
    }

    for (Lecture lecture in newLectureList) {
      await widget.gSheet.insertLecture(lecture);
    }

    if (widget.lectureList != null) {
      List<double> oldIdList = widget.lectureList!.map((e) => e.id).toList();
      for (double id in oldIdList) {
        if (!newIdList.contains(id)) {
          await widget.gSheet.deleteById(id);
        }
      }
    }

    setState(() {
      isLoading = false;
    });

    // showCustomToast(toastMsg: '강의 생성/수정이 정상적으로 완료되었습니다.', fToast: fToast);
  }

  TrinaGrid _RenderLectureGrid() {
    return TrinaGrid(
      columns: lectureColumns,
      rows: lectureRows,
      onLoaded: (event) {
        stateManager = event.stateManager;
      },
      onChanged: (event) {},
      configuration: TrinaGridConfiguration(
        style: TrinaGridStyleConfig.dark(
          rowColor: BG_COLOR,
          gridBackgroundColor: GRID_BG_COLOR,
          borderColor: Colors.grey,
          oddRowColor: BG_COLOR,
          evenRowColor: GRID_BG_COLOR,
          iconColor: GRID_ICON_COLOR,
        ),
        scrollbar: TrinaGridScrollbarConfig(isAlwaysShown: true),
      ),
    );
  }

  void _handleAddRow() {
    final newRows = stateManager.getNewRows(count: 1);

    double maxId = widget.idInteger + 0.0;

    for (var lectureRow in lectureRows) {
      double id = lectureRow.cells['id']?.value ?? maxId;
      maxId = maxId < id ? id : maxId;
      if (maxId + 0.1 == widget.idInteger + 1.0) {
        return;
      }
    }

    for (var e in newRows) {
      e.cells['id']?.value = maxId + 0.1;

      if (stateManager.currentRow != null) {
        e.cells['weekday']?.value =
            stateManager.currentRow!.cells['weekday']?.value;
        e.cells['startAt']?.value =
            stateManager.currentRow!.cells['startAt']?.value;
        e.cells['endAt']?.value =
            stateManager.currentRow!.cells['endAt']?.value;
      }
    }

    stateManager.appendRows(newRows);
  }

  void _handleRemoveCurrentRow() {
    stateManager.removeCurrentRow();
  }

  void _handleRemoveAllRows() {
    stateManager.removeAllRows();
  }

  Widget _RenderColorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...List.generate(6, (index) {
          Color borderColor = TIMETABLE_DIVIDER_COLOR;
          double borderWidth = 1;
          double dotSize = 24;

          if (colorIndex == index) {
            borderColor = Colors.grey.withAlpha(120);
            borderWidth = 4;
            dotSize = 36;
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                colorIndex = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: LECTURE_BG_COLORS[index],
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              width: dotSize,
              height: dotSize,
            ),
          );
        }),
      ],
    );
  }
}
