import 'package:flutter/material.dart';
import 'package:gnu_web_dashboard/common/component/custom_text_form_field.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';
import 'package:gnu_web_dashboard/common/util/data/grid_manager.dart';
import 'package:gnu_web_dashboard/common/util/data/model/Weekday.dart';
import 'package:gnu_web_dashboard/common/util/data/model/lecture.dart';
import 'package:gnu_web_dashboard/common/util/data/model/trina_columns.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';
import 'package:trina_grid/trina_grid.dart';

class LectureDialog extends StatefulWidget {
  final List<Lecture>? lectureList;

  const LectureDialog({required this.lectureList, super.key});

  @override
  State<LectureDialog> createState() => _LectureDialogState();
}

class _LectureDialogState extends State<LectureDialog> {
  late TrinaGridStateManager stateManager;

  String lectureName = '';
  String instructorName = '';
  int colorIndex = 0;

  double id = 0;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double FIELD_PADDING_VERTICAL = 12.0;
    const double FIELD_PADDING_HORIZONTAL = 12.0;
    return AlertDialog(
      title: Text('강의 시간표 생성/수정하기'),
      actions: [
        TextButton(
          onPressed: () {
            _onSaveButtonPressed();
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
          height: 500,
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

  Future<void> _onSaveButtonPressed() async {}

  TrinaGrid _RenderLectureGrid() {
    return TrinaGrid(
      columns: lectureColumns,
      rows: lectureRows,
      // rows: [],
      onLoaded: (event) {
        stateManager = event.stateManager;
      },
      onChanged: (event) {
        dLog(event.value);
      },
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
    stateManager.appendNewRows();
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
            borderColor = Colors.grey.withAlpha(80);
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
