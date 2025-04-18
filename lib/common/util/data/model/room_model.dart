class Room {
  final int key;
  final int buildingNum;
  final int roomNum;
  late final String roomId;
  final String roomName;
  final Map<String, dynamic> equipMap;

  Room({
    required this.key,
    required this.buildingNum,
    required this.roomNum,
    required this.roomName,
    required this.equipMap,
  }) {
    roomId =
        '0-${buildingNum.toString().padLeft(3, '0')}-${roomNum.toString().padLeft(4, '0')}';
  }
}

final initialRooms = [
  Room(
    key: 1,
    buildingNum: 4,
    roomNum: 111,
    roomName: '4동 111호 PBL',
    equipMap: {
      "wall_hub": true,
      "class_hub": true,
      "All": true,
      "교수PC": true,
      "조명": true,
      "냉난방기": true,
      "PBL 디스플레이": true,
      "학생PC": false,
      "재실": true,
    },
  ),
  Room(
    key: 2,
    buildingNum: 601,
    roomNum: 1007,
    roomName: '601동 1007호 PBL',
    equipMap: {
      "wall_hub": true,
      "class_hub": true,
      "All": true,
      "교수PC": true,
      "조명": true,
      "냉난방기": true,
      "PBL 디스플레이": true,
      "학생PC": false,
      "재실": true,
    },
  ),
  Room(
    key: 3,
    buildingNum: 601,
    roomNum: 1011,
    roomName: '601동 1011호 G큐브',
    equipMap: {
      "wall_hub": false,
      "class_hub": false,
      "All": true,
      "교수PC": true,
      "조명": true,
      "냉난방기": true,
      "PBL 디스플레이": false,
      "학생PC": false,
      "재실": true,
    },
  ),
  Room(
    key: 4,
    buildingNum: 24,
    roomNum: 116,
    roomName: '24동 116호 G큐브',
    equipMap: {
      "wall_hub": false,
      "class_hub": false,
      "All": true,
      "교수PC": true,
      "조명": true,
      "냉난방기": true,
      "PBL 디스플레이": false,
      "학생PC": false,
      "재실": true,
    },
  ),
];
