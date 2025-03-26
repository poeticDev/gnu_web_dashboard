class Room {
  final int key;
  final int buildingNum;
  final int roomNum;
  late final String roomId;

  Room({
    required this.key,
    required this.buildingNum,
    required this.roomNum,
  }) {
    roomId =
        '0-${buildingNum.toString().padLeft(3, '0')}-${roomNum.toString().padLeft(4, '0')}';
  }
}
